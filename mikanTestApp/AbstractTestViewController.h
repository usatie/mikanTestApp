//
//  TestViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@interface AbstractTestViewController : UIViewController
@property TestView *testView;

@property NSDictionary *testWordsDic; //wordIndex, english, choice1,choice2,choice3,choice4,answerIndex,wordIndexを要素に持つDictionary
@property NSDictionary *testResultsDic; //resultsArray, choiceArray, answerDurationArrayを要素に持つDictionary

@property NSMutableArray *resultsArray;
@property NSMutableArray *userChoicesArray;
@property NSMutableArray *answerDurationArray;

@property BOOL relearnFlag;


//Temporary properties
@property AVAudioPlayer *audio;
@end
