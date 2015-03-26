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
- (void) playSound:(NSString *)fileName playSoundFlag:(BOOL)playSoundFlag
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3",fileName] ofType:nil];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) NSLog(@"error. could not pronounce %@", fileName);
        [self.audio play];
    } else {
    }
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