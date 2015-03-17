//
//  Util.h
//  mikan
//
//  Created by tomoaki saito on 2014/09/17.
//  Copyright (c) 2014年 mikan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "fmdb/FMDatabase.h"
#import <AVFoundation/AVFoundation.h>

@interface UserUtil : NSObject

#pragma mark Post Data
- (NSArray *)makeParameterArray:(NSArray *)nameArray valueArray:(NSArray *)valueArray;
- (void)jsonLogData:(NSString *)action parameterArray:(NSArray *)parameter;
- (void)showLTSV;
- (void)postGetWordsDataBugReport:(NSString *)method category:(NSString *)category;

#pragma mark Audio
@property (strong, nonatomic) AVAudioPlayer* soundPlayer;
- (void) playSound:(NSString *)fileName playSoundFlag:(BOOL)playSoundFlag;

#pragma mark Configuration
- (NSUInteger)returnVersion:(NSString *)appVersion;

#pragma mark Small Settings
- (void) setExclusiveTouchForView:(UIView*)view;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end