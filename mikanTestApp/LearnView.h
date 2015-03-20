//
//  LearnView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableCardView.h"


@protocol LearnViewDelegate;

@interface LearnView : UIView<DraggableCardViewDelegate>
@property id <LearnViewDelegate> delegate;
@property NSDictionary *wordsDic;

- (void)generateCardView :(int)learnWordsIndex cardCount:(int)cardCount;

@property (strong, nonatomic) IBOutlet UIView *cardBaseView;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)cancelButtonPushed:(id)sender;
- (IBAction)knownButtonPushed:(id)sender;
- (IBAction)unknownButtonPushed:(id)sender;

@end

@protocol LearnViewDelegate <NSObject>
@optional

@required
- (void)cancelButtonPushedDelegate;
- (void)didSubviewsRemoved;
- (void)willPlayNextWord;
@end