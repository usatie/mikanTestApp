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
@end
