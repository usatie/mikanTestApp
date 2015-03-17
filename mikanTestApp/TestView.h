//
//  TestView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestView : UIView
#pragma mark Xib file related things
@property (strong, nonatomic) IBOutlet UILabel *englishLabel;
@property (strong, nonatomic) IBOutlet UIButton *answerButton1;
@property (strong, nonatomic) IBOutlet UIButton *answerButton2;
@property (strong, nonatomic) IBOutlet UIButton *answerButton3;
@property (strong, nonatomic) IBOutlet UIButton *answerButton4;

- (IBAction)answerButtonPushed:(id)sender;

#pragma mark properties
@property NSDictionary *testWordsDic;
@property NSMutableDictionary *testResultsDic; //results,choice

#pragma mark methods
- (void)didTimeOut;

@end
