//
//  AbstractLearnViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "LearnView.h"
#import "DraggableCardView.h"

@protocol AbstractLearnViewControllerDelegate;

@interface AbstractLearnViewController : UIViewController<LearnViewDelegate,DraggableCardViewDelegate>
@property id<AbstractLearnViewControllerDelegate> delegate;
@property LearnView *learnView;

@property NSMutableArray *leftCountArray;
@property NSMutableArray *swipeDurationArray;

@property AVAudioPlayer *audio;
@property NSDate *date;

@property int numberOfWords;
@property BOOL shouldLearnAgain;


#pragma mark initialization methods(required in child class)
- (void)initLearnView;
- (void)initArrays;
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