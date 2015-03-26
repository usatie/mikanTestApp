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






#pragma mark INSERT and UPDATE methods

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
+ (void) insertLearnResultWithArray:(NSArray *)wordIdArray
                      durationArray:(NSArray *)durationArray
                     leftCountArray:(NSArray *)leftCountArray
                          learnType:(int)learnType
                        relearnFlag:(BOOL)relearnFlag;




#pragma mark GET methods

+ (FMDatabase*) getDBWithName:(NSString*)dbName;
+ (NSDictionary *)getHasRememberedDic:(NSString *)category;
+ (NSDictionary *)getHasRememberedDicWithWordIdArray:(NSArray *)wordIdArray;

+ (void)setHasRememberedWithArray:(NSArray *)wordsIdArray
              hasRememberedArray:(NSArray *)hasRememberedArray;

//+ (NSDictionary *) getUnrememberedRelearnWords:(NSString*)category
//                                         limit:(int)limit;
+ (NSDictionary *) getRelearnWords:(NSString*)category
                             limit:(int)limit
                        remembered:(BOOL)remembered
                         hasTested:(BOOL)hasTested;
+ (NSArray *) getRelearnWordsCount:(NSString*)category;
@end
