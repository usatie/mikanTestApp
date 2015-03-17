//
//  TestView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "answerButton.h"

@interface TestView : UIView
@property (strong, nonatomic) IBOutlet UILabel *englishLabel;
@property (strong, nonatomic) IBOutlet answerButton *answerButton1;
@property (strong, nonatomic) IBOutlet answerButton *answerButton2;
@property (strong, nonatomic) IBOutlet answerButton *answerButton3;
@property (strong, nonatomic) IBOutlet answerButton *answerButton4;

@property int answerButtonTag;
@property NSDictionary *testWordsDic; //wordIndex, english,

- (void)enableAllButtons;
- (void)disableAllButtons;
- (void)showWordWithIndex:(int)index;
@end
