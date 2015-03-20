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
        [self generateCardView:0 cardCount:5];
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
        [cardView setParameter:@"english"
                      japanese:@"japanese"
                        number:@"2"
            japaneseHiddenFlug:YES
                     wordIndex:1];
        
        //        [cardView setParameter:_learnWordsDic[@"english"][i]
        //                      japanese:_learnWordsDic[@"japanese"][i]
        //                        number:[NSString stringWithFormat:@"%@",_learnWordsDic[@"wordId"][i]]
        //            japaneseHiddenFlug:YES
        //                     wordIndex:[_learnWordsDic[@"wordId"][i] intValue]];
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
        [sender resetViewPositionAndTransformations];
        [self.cardBaseView sendSubviewToBack:sender];
    }
    
    //cardsBaseViewのsubviewsが０だったらfinish
    if (self.cardBaseView.subviews.count == 0) {
        //play "finish!"
    } else {
        //play "next words"
    }
}



#pragma mark Button Actions
- (IBAction)cancelButtonPushed:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelButtonPushedDelegate)]) {
        [_delegate cancelButtonPushedDelegate];
    }
}
@end
