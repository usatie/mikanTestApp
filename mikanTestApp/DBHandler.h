//
//  DBHandler.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/16.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHandler : NSObject

+ (void)initDatabase;
+ (void) insertTestResult:(NSNumber*)wordId
                   result:(BOOL)result
               userChoice:(int)userChoice
            answeringTime:(float)answeringTime
                 testType:(int)testType
              relearnFlag:(BOOL)relearnFlag;
@end
