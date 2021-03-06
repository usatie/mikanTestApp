//
//  LearnView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableCardView.h"
@class AbstractLearnViewController;

@protocol LearnViewDelegate;

@interface LearnView : UIView
@property id <LearnViewDelegate> delegate;
@property NSDictionary *wordsDic;
@property DraggableCardView *topCardView;


- (void)generateCardView :(int)learnWordsIndex cardCount:(int)cardCount delegate:(AbstractLearnViewController *)learnVC;
- (void)removeCardView:(DraggableCardView *)cardView;
- (void)sendCardViewToBack:(DraggableCardView *)cardView;

@property (strong, nonatomic) IBOutlet UIView *cardBaseView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *knownButton;
@property (strong, nonatomic) IBOutlet UIButton *unknownButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;


- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)knownButtonPushed:(id)sender;
- (IBAction)unknownButtonPushed:(id)sender;



@end

@protocol LearnViewDelegate <NSObject>
@optional

@required
- (void)cancelButtonPushedDelegate;
- (void)cardViewSwipedDelegate:(BOOL)hasRememberd cardView:(DraggableCardView *)cardView;
@end