//
//  DBHandler.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/16.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "DBHandler.h"

@implementation DBHandler

+(void) initDatabaseVer2
{
//    DLog(@"initDatabase");
    
    // データベースファイルを格納するために文書フォルダーを取得
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:DB_NAME];
//    DLog(@"%@",dbPath);
    BOOL checkDb;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // データベースファイルを確認
    checkDb = [fileManager fileExistsAtPath:dbPath];
    if(!checkDb){
//        DLog(@"no db file");
        // ファイルが無い場合はコピー
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
//        DLog(@"%@",[[[NSBundle mainBundle]resourcePath] stringByAppendingPathComponent:DB_NAME]);
//        DLog(@"%@",[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME_VER_2]);
//        DLog(@"%@",defaultDBPath);
        checkDb = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!checkDb){
            // error
//            DLog(@"Copy error = %@", defaultDBPath);
        }
    }
    else{
        DLog(@"DB file OK");
    }
    
}
@end
