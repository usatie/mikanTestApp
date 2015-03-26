//
//  AbstractLearnViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearnView.h"
#import <AVFoundation/AVFoundation.h>

@protocol AbstractLearnViewControllerDelegate;

@interface AbstractLearnViewController : UIViewController<LearnViewDelegate>
@property id<AbstractLearnViewControllerDelegate> delegate;
@property LearnView *learnView;
@property int numberOfWords;
@property AVAudioPlayer *audio;
@property BOOL shouldLearnAgain;


- (void)initLearnView;
#pragma mark override methods (required)
- (NSDictionary *)getWordsDic;
- (void)finishLearn;
#pragma mark override methods (optional)
- (void)startTimer;
- (void)stopTimer;
- (void)timerAction;
@end



@protocol AbstractLearnViewControllerDelegate <NSObject>
@optional
@end