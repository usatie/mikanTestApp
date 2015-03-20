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
            japaneseHiddenFlug:YES
                     wordIndex:[self.wordsDic[@"wordId"][i] intValue]];
        cardView.sectionLabel.text = @"検証テスト";
        cardView.japaneseLabel.hidden = NO;
        [self.cardBaseView addSubview:cardView];
        [self.cardBaseView sendSubviewToBack:cardView];
    }
}

#pragma mark CardView delegate
- (void)displayNextCardDelegate:(BOOL)hasRememberd sender:(DraggableCardView *)sender{
    NSLog(@"displayNextCardDelegate tag = %d",(int)sender.tag);
    
    //知ってたらremove, 知らなかったらsendSubviewToBack
    if (hasRememberd) {
        [sender removeFromSuperview];
    } else {
        [self.cardBaseView sendSubviewToBack:sender];
        [sender resetViewPositionAndTransformations];
    }
    
    //cardsBaseViewのsubviewsが０だったらfinish
    if (self.cardBaseView.subviews.count == 0) {
        //play "finish!"
        if ([_delegate respondsToSelector:@selector(didSubviewsRemoved)]) {
            [_delegate didSubviewsRemoved];
        }
    } else {
        //play "next words"
        if ([_delegate respondsToSelector:@selector(willPlayNextWord)]) {
            [_delegate willPlayNextWord];
        }
    }
}



#pragma mark Button Actions
- (IBAction)cancelButtonPushed:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelButtonPushedDelegate)]) {
        [_delegate cancelButtonPushedDelegate];
    }
}

- (IBAction)knownButtonPushed:(id)sender {
    DraggableCardView *cardView = (DraggableCardView *)[self.cardBaseView.subviews objectAtIndex:self.cardBaseView.subviews.count-1];
    [self removeCardView:cardView];
}

- (IBAction)unknownButtonPushed:(id)sender {
    DraggableCardView *cardView = (DraggableCardView *)[self.cardBaseView.subviews objectAtIndex:self.cardBaseView.subviews.count-1];
    [self sendCardViewToBack:cardView];
}


#pragma mark Card Animation
- (void)removeCardView:(DraggableCardView *)cardView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         cardView.center = CGPointMake(cardView.originalPoint.x + 250 , cardView.originalPoint.y + 100);
                         cardView.transform = CGAffineTransformMakeRotation(0);}
                     completion:^(BOOL finished){
                         cardView.panGestureRecognizer.enabled = YES;
                         [self displayNextCardDelegate:YES sender:cardView];
                     }
     ];
    
}

- (void)sendCardViewToBack:(DraggableCardView *)cardView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         cardView.center = CGPointMake(cardView.originalPoint.x - 250 , cardView.originalPoint.y + 100);
                         cardView.transform = CGAffineTransformMakeRotation(0);}
                     completion:^(BOOL finished){
                         cardView.panGestureRecognizer.enabled = YES;
                         [self displayNextCardDelegate:NO sender:cardView];
                     }
     ];
}

@end
