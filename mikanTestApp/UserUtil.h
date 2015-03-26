//
//  Util.h
//  mikan
//
//  Created by tomoaki saito on 2014/09/17.
//  Copyright (c) 2014年 mikan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "fmdb/FMDatabase.h"

@interface UserUtil : NSObject

#pragma mark Audio
@property AVAudioPlayer *audio;
- (void) playSound:(NSString *)fileName playSoundFlag:(BOOL)playSoundFlag;

#pragma mark Small Settings
- (void) setExclusiveTouchForView:(UIView*)view;

@end