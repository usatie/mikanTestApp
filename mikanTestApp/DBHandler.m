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

#pragma mark GET methods
+ (FMDatabase*) getDBWithName:(NSString*)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *dir   = [paths objectAtIndex:0];
    FMDatabase *db= [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:dbName]];
    return db;
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

+ (void) insertTestResult:(NSArray*)wordIdArray
              resultArray:(NSArray *)resultsArray
          userChoiceArray:(NSArray *)userChoicesArray
       answeringTimeArray:(NSArray *)answeringTimeArray
                 testType:(int)testType
              relearnFlag:(BOOL)relearnFlag{
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
    NSString *sql = @"select w.id, w.japanese_label, w.english_label, r.latest_answer_duration, r.latest_test_result, r.has_tested, r.has_remembered from word as w left join word_record as r where w.id = r.word_id and w.category_id = ?";
    
    [db open];
    FMResultSet *result;
    result = [db executeQuery:sql, [categoryIdDic objectForKey:category]];
    
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
