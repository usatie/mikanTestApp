//
//  DBHandler.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/16.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DBHandler : NSObject

+ (void)initDatabase;


+ (FMDatabase*) getDBWithName:(NSString*)dbName;


+ (void) insertTestResult:(NSNumber*)wordId
                   result:(BOOL)result
               userChoice:(int)userChoice
            answeringTime:(float)answeringTime
                 testType:(int)testType
              relearnFlag:(BOOL)relearnFlag;
+ (void) insertTestResult:(NSArray*)wordIdArray
              resultArray:(NSArray *)resultsArray
          userChoiceArray:(NSArray *)userChoicesArray
       answeringTimeArray:(NSArray *)answeringTimeArray
                 testType:(int)testType
              relearnFlag:(BOOL)relearnFlag;

+(NSDictionary *)getHasRememberedDic:(NSString *)category;
+(NSDictionary *)getHasRememberedDicWithWordIdArray:(NSArray *)wordIdArray;

+(void)setHasRememberedWithArray:(NSArray *)wordsIdArray
              hasRememberedArray:(NSArray *)hasRememberedArray;

//+ (NSDictionary *) getUnrememberedRelearnWords:(NSString*)category
//                                         limit:(int)limit;
+ (NSDictionary *) getRelearnWords:(NSString*)category
                             limit:(int)limit
                        remembered:(BOOL)remembered
                         hasTested:(BOOL)hasTested;
@end
