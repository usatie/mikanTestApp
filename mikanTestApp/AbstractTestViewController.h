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

@property NSDictionary *testWordsDic; //wordIndex, english, choicesArray,answerIndex,wordIndexを要素に持つDictionary
@property NSDictionary *testResultsDic; //resultsArray, choiceArray, answerDurationArrayを要素に持つDictionary

@property NSMutableArray *resultsArray;
@property NSMutableArray *userChoicesArray;
@property NSMutableArray *answerDurationArray;

@property BOOL relearnFlag;
@property int testIndex;

- (NSDictionary *)getTestWords;
- (void)finishTest;
- (void)cancelButtonPushed;
- (void)showAndPlayNextWord;
- (void)answerButtonPushedDelegate:(BOOL)result choice:(int)choice;
//Temporary properties
@property AVAudioPlayer *audio;


@end