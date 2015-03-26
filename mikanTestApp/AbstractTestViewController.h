//
//  AbstractTestViewController.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestView.h"
#import <AVFoundation/AVFoundation.h>

@interface AbstractTestViewController : UIViewController<TestViewDelegate>
@property TestView *testView;
@property UIAlertView *cancelAlertView;

@property NSDictionary *testWordsDic; //wordIndex, english, choicesArray,answerIndex,wordIndexを要素に持つDictionary
@property NSDictionary *testResultsDic; //resultsArray, choiceArray, answerDurationArrayを要素に持つDictionary

@property NSMutableArray *resultsArray;
@property NSMutableArray *userChoicesArray;
@property NSMutableArray *answerDurationArray;

@property UserUtil *util;

@property BOOL relearnFlag;
@property int testIndex;

#pragma mark Button Actions
- (void)cancelButtonPushed;
- (void)showAndPlayNextWord;
- (void)answerButtonPushedDelegate:(BOOL)result choice:(int)choice;

#pragma mark override methods (required)
- (NSDictionary *)getTestWords;
- (void)finishTest;

#pragma mark override methods (optional)
- (void)startTimer;
- (void)stopTimer;
- (void)timerAction;
- (void)cancelButtonPushedBeforeAnswering;
@end