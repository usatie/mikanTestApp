//
//  DBHandler.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/16.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "DBHandler.h"

@implementation DBHandler

#pragma mark INIT method
+ (void)initDatabase
{
    DLog(@"initDatabase");
    
    // データベースファイルを格納するために文書フォルダーを取得
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
    DLog(@"%@",dbPath);
    BOOL checkDb;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // データベースファイルを確認
    checkDb = [fileManager fileExistsAtPath:dbPath];
    if(!checkDb){
        DLog(@"no db file");
        // ファイルが無い場合はコピー
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
        DLog(@"%@",defaultDBPath);
        checkDb = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!checkDb){
            // error
            DLog(@"Copy error = %@", defaultDBPath);
        }
    }
    else{
        DLog(@"DB file OK");
    }
}

#pragma mark INSERT and UPDATE methods
+ (void) insertTestResult:(NSNumber*)wordId
                   result:(BOOL)result
               userChoice:(int)userChoice
            answeringTime:(float)answeringTime
                 testType:(int)testType
              relearnFlag:(BOOL)relearnFlag
{
    
    NSString *sql=@"insert into log_test_result (test_type, word_id, test_result,created_at,user_choice,answer_duration,relearn_flag) values (?,?,?,?,?,?,?);";
    NSDate *now = [NSDate date];
    
    FMDatabase *db = [self getDBWithName:DB_NAME];
    
    [db open];
    [db executeUpdate:sql, [NSNumber numberWithInt:testType], wordId, [NSNumber numberWithBool:result],now,[NSNumber numberWithInt:userChoice],[NSNumber numberWithFloat:answeringTime],[NSNumber numberWithBool:relearnFlag]];
    sql = @"update word_record set latest_answer_duration = ?, test_count = test_count + 1, correct_count = correct_count + ?, updated_at = ? where id = ?;";
    [db executeUpdate:sql, [NSNumber numberWithFloat:answeringTime], [NSNumber numberWithInt:result], now, wordId];
    [db close];
}

+ (void) insertTestResultWithArray:(NSArray*)wordIdArray
              resultArray:(NSArray *)resultsArray
          userChoiceArray:(NSArray *)userChoicesArray
       answeringTimeArray:(NSArray *)answeringTimeArray
                 testType:(int)testType
              relearnFlag:(BOOL)relearnFlag{
    
    DLog(@"insertTestResult %@",wordIdArray);
    NSString *sql=@"insert into log_test_result (test_type, word_id, test_result,created_at,user_choice,answer_duration,relearn_flag) values (?,?,?,?,?,?,?);";
    NSString *sql2 = @"update word_record set has_tested = 1, latest_test_result = ?, latest_answer_duration = ?, test_count = test_count + 1, correct_count = correct_count + ?, updated_at = ? where id = ?;";
    NSDate *now = [NSDate date];
    
    FMDatabase *db = [self getDBWithName:DB_NAME];
    
    [db open];
    [db beginTransaction];
    BOOL isSucceeded = YES;
    for (int i = 0; i < wordIdArray.count; i++) {
        if (![db executeUpdate:sql, [NSNumber numberWithInt:testType], wordIdArray[i], resultsArray[i],now,userChoicesArray[i],answeringTimeArray[i],[NSNumber numberWithBool:relearnFlag]]) {
            isSucceeded  = NO;
            break;
        }
        if (![db executeUpdate:sql2, resultsArray[i], answeringTimeArray[i], resultsArray[i], now, wordIdArray[i]]) {
            isSucceeded = NO;
            break;
        }
    }
    if( isSucceeded ) [db commit];
    else [db rollback];

    [db close];
}

+ (void) insertLearnResultWithArray:(NSArray *)wordIdArray
                      durationArray:(NSArray *)durationArray
                     leftCountArray:(NSArray *)leftCountArray
                          learnType:(int)learnType
                        relearnFlag:(BOOL)relearnFlag
{
    FMDatabase *db = [self getDBWithName:DB_NAME];
    NSString *sql = @"insert into log_learn_result (word_id, learn_type, relearn_flag, left_count, duration, created_at) values (?,?,?,?,?,?);";
    NSString *sql_learn = @"update word_record set learn_count = learn_count + 1, left_count = ?, updated_at = ? where word_id = ?;";
    NSString *sql_relearn = @"update word_record set relearn_count = relearn_count + 1, left_count = ?, updated_at = ? where word_id = ?;";
    [db open];
    [db beginTransaction];
    NSDate *now = [NSDate date];
    BOOL isSucceeded = YES;
    for (int i=0; i<[wordIdArray count]; i++) {
        // insert log_learn_result
        if (![db executeUpdate:sql, wordIdArray[i], [NSNumber numberWithInt:learnType],[NSNumber numberWithBool:relearnFlag], leftCountArray[i], durationArray[i], now]){
            isSucceeded = NO;
            break;
        }
        
        // update count of word_record
        if (relearnFlag){
            if (![db executeUpdate:sql_relearn,leftCountArray[i],now,wordIdArray[i]]){
                isSucceeded = NO;
                break;
            }
        }else{
            if (![db executeUpdate:sql_learn,leftCountArray[i],now,wordIdArray[i]]){
                isSucceeded = NO;
                break;
            }
        }
    }
    if( isSucceeded ) [db commit];
    else [db rollback];
    [db close];
}


#pragma mark GET methods
+ (FMDatabase*) getDBWithName:(NSString*)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:dbName]];
    return db;
}

+(NSDictionary *)getHasRememberedDic:(NSString *)category
{
    NSMutableDictionary *hasRememberedDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *wordIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *japaneseLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *englishLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *testResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *hasRememberedArray = [[NSMutableArray alloc] init];
    NSMutableArray *hasTestedArray = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [self getDBWithName:DB_NAME];
    NSDictionary *categoryIdDic = [self getCategoryIdDic];
    NSString *sql = @"select w.id, w.japanese_label, w.english_label, r.latest_answer_duration, r.latest_test_result, r.has_tested, r.has_remembered from word as w left join word_record as r where w.id = r.word_id and w.category_id = ? and w.word_index <= ?";
    
    [db open];
    FMResultSet *result;
    result = [db executeQuery:sql, [categoryIdDic objectForKey:category],[NSNumber numberWithInt:WORD_ID_LIMIT]];
    
    while ([result next]) {
        [wordIdArray addObject:[result objectForColumnName:@"id"]];
        [japaneseLabelArray addObject:[result objectForColumnName:@"japanese_label"]];
        [englishLabelArray addObject:[result objectForColumnName:@"english_label"]];
        [testResultArray addObject:[self getEvaluationWithTime:[result objectForColumnName:@"latest_answer_duration"] hasCorrected:[result objectForColumnName:@"latest_test_result"] hasTested:[result objectForColumnName:@"has_tested"]]];
        [hasRememberedArray addObject:[result objectForColumnName:@"has_remembered"]];
        [hasTestedArray addObject:[result objectForColumnName:@"has_tested"]];
    }
    
    [hasRememberedDic setObject:wordIdArray forKey:@"wordId"];
    [hasRememberedDic setObject:englishLabelArray forKey:@"englishLabel"];
    [hasRememberedDic setObject:japaneseLabelArray forKey:@"japaneseLabel"];
    [hasRememberedDic setObject:testResultArray forKey:@"testResult"];
    [hasRememberedDic setObject:hasRememberedArray forKey:@"hasRemembered"];
    [hasRememberedDic setObject:hasTestedArray forKey:@"hasTested"];
    [db close];
    
    return hasRememberedDic;
}

+(NSDictionary *)getHasRememberedDicWithWordIdArray:(NSArray *)wordIdArray
{
    NSMutableDictionary *hasRememberedDic = [[NSMutableDictionary alloc] init];
//    NSMutableArray *wordIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *japaneseLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *englishLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *testResultArray = [[NSMutableArray alloc] init];
    NSMutableArray *hasRememberedArray = [[NSMutableArray alloc] init];
    NSMutableArray *hasTestedArray = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [self getDBWithName:DB_NAME];
//    NSDictionary *categoryIdDic = [self getCategoryIdDic];
    NSString *sql = @"select w.id, w.japanese_label, w.english_label, r.latest_answer_duration, r.latest_test_result, r.has_tested, r.has_remembered from word as w left join word_record as r where w.id = r.word_id and w.id = ? and w.word_index <= ?";
    
    [db open];
    FMResultSet *result;
    
    for (int i = 0; i <wordIdArray.count; i++) {
        result = [db executeQuery:sql, wordIdArray[i],[NSNumber numberWithInt:WORD_ID_LIMIT]];
        
        while ([result next]) {
            //        [wordIdArray addObject:[result objectForColumnName:@"id"]];
            [japaneseLabelArray addObject:[result objectForColumnName:@"japanese_label"]];
            [englishLabelArray addObject:[result objectForColumnName:@"english_label"]];
            [testResultArray addObject:[self getEvaluationWithTime:[result objectForColumnName:@"latest_answer_duration"] hasCorrected:[result objectForColumnName:@"latest_test_result"] hasTested:[result objectForColumnName:@"has_tested"]]];
            [hasRememberedArray addObject:[result objectForColumnName:@"has_remembered"]];
            [hasTestedArray addObject:[result objectForColumnName:@"has_tested"]];
        }

    }
    
    [hasRememberedDic setObject:wordIdArray forKey:@"wordId"];
    [hasRememberedDic setObject:englishLabelArray forKey:@"englishLabel"];
    [hasRememberedDic setObject:japaneseLabelArray forKey:@"japaneseLabel"];
    [hasRememberedDic setObject:testResultArray forKey:@"testResult"];
    [hasRememberedDic setObject:hasRememberedArray forKey:@"hasRemembered"];
    [hasRememberedDic setObject:hasTestedArray forKey:@"hasTested"];
    [db close];
    
    return hasRememberedDic;
}

+(void)setHasRememberedWithArray:(NSArray *)wordsIdArray
              hasRememberedArray:(NSArray *)hasRememberedArray
{
    FMDatabase *db = [self getDBWithName:DB_NAME];
    [db open];
    
    NSString* sql=@"update word_record set has_remembered = ? where word_id = ?;";
    
    for (int i=0; i<[wordsIdArray count]; i++) {
        [db executeUpdate:sql, hasRememberedArray[i],wordsIdArray[i]];
    }
    
    [db close];
    
    DLog(@"update hasRelearned");
}

+ (NSDictionary *) getRelearnWords:(NSString*)category
                             limit:(int)limit
                        remembered:(BOOL)remembered
                         hasTested:(BOOL)hasTested
{
    NSMutableDictionary *relearnWordsDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *wordIndexArray = [[NSMutableArray alloc] init];
    NSMutableArray *englishLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *japaneseLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *pinyinLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *choicesArray = [[NSMutableArray alloc] init];
//    NSMutableArray *choice1Array = [[NSMutableArray alloc] init];
//    NSMutableArray *choice2Array = [[NSMutableArray alloc] init];
//    NSMutableArray *choice3Array = [[NSMutableArray alloc] init];
//    NSMutableArray *choice4Array = [[NSMutableArray alloc] init];
    NSMutableArray *answerIndexArray = [[NSMutableArray alloc] init];
    NSMutableArray *rankIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *wordIdArray = [[NSMutableArray alloc] init];
    
    NSDictionary *categoryIdDic = [self getCategoryIdDic];
    FMDatabase* db = [self getDBWithName:DB_NAME];
    NSString* sql;
    [db open];
//    sql = @"select w.*, r.updated_at from word as w left join word_record as r where w.id = r.word_id and w.category_id = ? and r.has_tested = 1 and r.has_remembered = 0 order by random() limit ?";
    sql = @"select w.*, r.updated_at from word as w left join word_record as r where w.id = r.word_id and w.category_id = ? and r.has_tested = ? and r.has_remembered = ? and w.word_index <= ? order by random() limit ?";
    FMResultSet *wordResult = [db executeQuery:sql,[categoryIdDic objectForKey:category],[NSNumber numberWithBool:hasTested],[NSNumber numberWithBool:remembered],[NSNumber numberWithInt:WORD_ID_LIMIT],[NSNumber numberWithInt:limit]];
    sql = @"select japanese_label from word where part_id = ? and id != ? and japanese_label != ? order by random() limit 3";
    while ([wordResult next]) {
        int partId = [wordResult intForColumn:@"part_id"];
        [wordIndexArray addObject:[NSNumber numberWithInt:[wordResult intForColumn:@"word_index"]]];//0
        [englishLabelArray addObject:[wordResult stringForColumn:@"english_label"]];//1
        [japaneseLabelArray addObject:[wordResult stringForColumn:@"japanese_label"]];//2
        [pinyinLabelArray addObject:[wordResult stringForColumn:@"pinyin_label"]];


        //random choice make
        FMResultSet *choiceResult = [db executeQuery:sql,[NSNumber numberWithInt:partId],[NSNumber numberWithInt:[wordResult intForColumn:@"id"]],[wordResult stringForColumn:@"japanese_label"]];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[wordResult stringForColumn:@"japanese_label"]];
        while ([choiceResult next]) {
            [array addObject:[choiceResult stringForColumnIndex:0]];
        }
        [choicesArray addObject:array];
        //till this line
        
        [answerIndexArray addObject:[NSNumber numberWithInt:[wordResult intForColumn:@"answer_index"]]];//7
        [rankIdArray addObject:[NSNumber numberWithInt:[wordResult intForColumn:@"rank_id"]]];//8
        [wordIdArray addObject:[NSNumber numberWithInt:[wordResult intForColumn:@"id"]]];//9
    }
    
    [relearnWordsDic setObject:wordIndexArray forKey:@"wordIndex"];
    [relearnWordsDic setObject:englishLabelArray forKey:@"english"];
    [relearnWordsDic setObject:japaneseLabelArray forKey:@"japanese"];
    [relearnWordsDic setObject:pinyinLabelArray forKey:@"pinyin"];

    [relearnWordsDic setObject:choicesArray forKey:@"choicesArray"];
    [relearnWordsDic setObject:answerIndexArray forKey:@"answerIndex"];
    [relearnWordsDic setObject:rankIdArray forKey:@"rankId"];
    [relearnWordsDic setObject:wordIdArray forKey:@"wordId"];
    [db close];
    
    return relearnWordsDic;
}

+ (NSArray *) getRelearnWordsCount:(NSString*)category
{
    NSMutableArray *countArray = [[NSMutableArray alloc] init];
    
    NSDictionary *categoryIdDic = [self getCategoryIdDic];
    FMDatabase* db = [self getDBWithName:DB_NAME];
    NSString* sql;
    [db open];
    sql = @"select count(w.id) from word as w left join word_record as r where w.id = r.word_id and w.category_id = ? and r.has_tested = 1 and r.has_remembered = 1 and w.word_index <= ?";
    FMResultSet *wordResult = [db executeQuery:sql,[categoryIdDic objectForKey:category],[NSNumber numberWithInt:WORD_ID_LIMIT]];
    while ([wordResult next]) {
        [countArray addObject:[NSNumber numberWithInt:[wordResult intForColumnIndex:0]]];
    }
    sql = @"select count(w.id) from word as w left join word_record as r where w.id = r.word_id and w.category_id = ? and r.has_tested = 0 and r.has_remembered = 0 and w.word_index <= ?";
    wordResult = [db executeQuery:sql,[categoryIdDic objectForKey:category],[NSNumber numberWithInt:WORD_ID_LIMIT]];
    while ([wordResult next]) {
        [countArray addObject:[NSNumber numberWithInt:[wordResult intForColumnIndex:0]]];
    }
    sql = @"select count(w.id) from word as w left join word_record as r where w.id = r.word_id and w.category_id = ? and r.has_tested = 1 and r.has_remembered = 0 and w.word_index <= ?";
    wordResult = [db executeQuery:sql,[categoryIdDic objectForKey:category],[NSNumber numberWithInt:WORD_ID_LIMIT]];
    while ([wordResult next]) {
        [countArray addObject:[NSNumber numberWithInt:[wordResult intForColumnIndex:0]]];
    }
    
    [db close];
    
    return countArray;
}

//mtp
+ (NSMutableDictionary*) getCategoryIdDic
{
    // return category dictionary. key:name value:id
    FMDatabase *db= [self getDBWithName:DB_NAME];
    [db open];
    NSString *sql=@"select id, name from category;";
    FMResultSet *results = [db executeQuery:sql];
    
    NSMutableDictionary *categoryId = [NSMutableDictionary dictionary];
    
    while ([results next]){
        [categoryId setObject:[NSNumber numberWithInt:[results intForColumn:@"id"]] forKey:[results stringForColumn:@"name"]];
    }
    return categoryId;
}
+ (NSNumber *) getEvaluationWithTime:(NSNumber *)thinkTime
                        hasCorrected:(NSNumber *)hasCorrected
                           hasTested:(NSNumber *)hasTested
{
    if (![hasTested boolValue]) return @-1;
    else if (![hasCorrected boolValue]) return [NSNumber numberWithFloat:0];
    else if ([thinkTime floatValue] < 1) return [NSNumber numberWithFloat:3];
    else if ([thinkTime floatValue] < 1.5) return [NSNumber numberWithFloat:2];
    else return [NSNumber numberWithFloat:1];
}

@end
