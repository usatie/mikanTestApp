//
//  AppConsts.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConsts : NSObject
extern NSString * const DB_NAME;
extern int const PROGRESS_LIMIT;
extern int const WORD_ID_LIMIT;

extern int const LEARN_TYPE_READ;
extern int const LEARN_TYPE_LISTEN;
extern int const TEST_TYPE_READ;
extern int const TEST_TYPE_LISTEN;
extern int const TEST_TYPE_RANKUP_READ;
extern int const TEST_TYPE_RANKUP_LISTEN;
@end
