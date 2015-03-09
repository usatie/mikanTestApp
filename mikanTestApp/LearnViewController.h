//
//  TestViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "GGDraggableView.h"

@interface LearnViewController : UIViewController<GGDraggableViewDelegate>
- (IBAction)backButtonPushed:(id)sender;
- (IBAction)nextWordsButtonPushed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *nextWordsButton;
@property (strong, nonatomic) IBOutlet UIView *cardsBaseView;

@property int learnCategoryId;
@property int timeLimit;

@property NSDictionary *learnWordsDic;

@property AVAudioPlayer *audio;

@end
