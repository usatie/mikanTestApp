//
//  LearnView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnView.h"

@implementation LearnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"LearnView" bundle:[NSBundle mainBundle]];
        NSArray *array = [nib instantiateWithOwner:self options:nil];
        self = [array objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

#pragma mark Card View method
- (void)generateCardView :(int)learnWordsIndex cardCount:(int)cardCount
{
    for (int i=learnWordsIndex; i < cardCount; i++) {
        DraggableCardView *cardView;
        cardView = [[DraggableCardView alloc]initWithFrame:CGRectMake(0, 0, 290, 340)];
        cardView.panGestureRecognizer.enabled = YES;
        cardView.tag = i+1;
        cardView.delegate = self;
        [cardView setParameter:self.wordsDic[@"english"][i]
                      japanese:self.wordsDic[@"japanese"][i]
                        number:[NSString stringWithFormat:@"%@",self.wordsDic[@"wordId"][i]]
            japaneseHiddenFlug:YES];
        cardView.sectionLabel.text = @"検証テスト";
        cardView.japaneseLabel.hidden = NO;
        [self.cardBaseView addSubview:cardView];
        [self.cardBaseView sendSubviewToBack:cardView];
        
        //set top card
        _topCardView = (DraggableCardView *)[self.cardBaseView.subviews objectAtIndex:self.cardBaseView.subviews.count-1];
    }
}

#pragma mark CardView delegate
- (void)cardViewSwipedDelegate:(BOOL)hasRememberd cardView:(DraggableCardView *)cardView
{
    if ([_delegate respondsToSelector:@selector(cardViewSwiped:cardView:)]) {
        [_delegate cardViewSwiped:hasRememberd cardView:cardView];
    }
}



#pragma mark Button Actions
- (IBAction)cancelButtonPushed:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelButtonPushedDelegate)]) {
        [_delegate cancelButtonPushedDelegate];
    }
}

- (IBAction)knownButtonPushed:(id)sender {
    [self removeCardView:_topCardView];
}

- (IBAction)unknownButtonPushed:(id)sender {
    [self sendCardViewToBack:_topCardView];
}


#pragma mark Card Animation
- (void)removeCardView:(DraggableCardView *)cardView
{
    [self disableButtons];
    cardView.panGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:0.2
                     animations:^{
                         cardView.center = CGPointMake(cardView.originalPoint.x + 250 , cardView.originalPoint.y + 100);
                         cardView.transform = CGAffineTransformMakeRotation(0);}
                     completion:^(BOOL finished){
                         cardView.panGestureRecognizer.enabled = YES;
                         [self cardViewSwipedDelegate:YES cardView:cardView];
                         [self enableButtons];
                     }
     ];
    
}

- (void)sendCardViewToBack:(DraggableCardView *)cardView
{
    [self disableButtons];
    cardView.panGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:0.2
                     animations:^{
                         cardView.center = CGPointMake(cardView.originalPoint.x - 250 , cardView.originalPoint.y + 100);
                         cardView.transform = CGAffineTransformMakeRotation(0);}
                     completion:^(BOOL finished){
                         cardView.panGestureRecognizer.enabled = YES;
                         [self cardViewSwipedDelegate:NO cardView:cardView];
                         [self enableButtons];
                     }
     ];
}

#pragma mark card availability
- (void)enableButtons{
    _knownButton.enabled = YES;
    _unknownButton.enabled = YES;
}
- (void)disableButtons{
    _knownButton.enabled = NO;
    _unknownButton.enabled = NO;
}

@end
