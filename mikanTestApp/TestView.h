//
//  TestView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "answerButton.h"

@protocol TestViewDelegate;

@interface TestView : UIView
@property id <TestViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *englishLabel;
@property (strong, nonatomic) IBOutlet answerButton *answerButton1;
@property (strong, nonatomic) IBOutlet answerButton *answerButton2;
@property (strong, nonatomic) IBOutlet answerButton *answerButton3;
@property (strong, nonatomic) IBOutlet answerButton *answerButton4;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

- (IBAction)answerButtonPushed:(id)sender;
- (IBAction)cancelButton:(id)sender;

@property int answerButtonTag;
@property NSDictionary *testWordsDic; //wordIndex, english,

- (void)enableAllButtons;
- (void)disableAllButtons;
- (void)showWordWithIndex:(int)index;
@end

@protocol TestViewDelegate <NSObject>

@required
- (void)answerButtonPushedDelegate:(BOOL)result choice:(int)choice;
- (void)cancelButtonPushedDelegate;
@end