//
//  Util.m
//  mikan
//
//  Created by tomoaki saito on 2014/09/17.
//  Copyright (c) 2014年 mikan. All rights reserved.
//

#import "UserUtil.h"

@implementation UserUtil

#pragma mark Audio

-(void)playSound:(NSString *)fileName playSoundFlag:(BOOL)playSoundFlag
{
    DLog(@"pronounce \"%@\"", fileName);
    if (!playSoundFlag)return;
    
    NSString *extension = @"mp3";
    NSArray *docDirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [docDirArray objectAtIndex:0];
    NSString *dirName = @"voice";
    NSString *filePath = [docDirPath stringByAppendingPathComponent:dirName];
    NSString *file = [NSString stringWithFormat:@"%@.%@",fileName, extension];
    filePath = [filePath stringByAppendingPathComponent:file];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSError *error;
    
    _soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&error];
    
    DLog(@"%@", fileUrl);
    
    if (error) {
        DLog(@"could not pronounce %@", fileName);
//        [self postFileNameToNCMB:fileName];
    }
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    
//    if ([fileName  isEqualToString: @"sound_finish"] ||[fileName isEqualToString:@"sound_correct"] || [fileName isEqualToString:@"sound_incorrect"]){
//        self.soundPlayer.volume = [ud floatForKey:@"soundEffectVolume"];
//    } else {
//        self.soundPlayer.volume = [ud floatForKey:@"pronounceSoundVolume"];
//    }
    [self.soundPlayer play];
}

#pragma mark Small Settings
-(void) setExclusiveTouchForView:(UIView*)view
{
    for (UIView *subview in view.subviews) {
        subview.exclusiveTouch = YES;
        [self setExclusiveTouchForView:subview];
    }
}

@end