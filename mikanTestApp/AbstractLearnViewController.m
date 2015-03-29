//
//  AbstractLearnViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractLearnViewController.h"

@interface AbstractLearnViewController () {
    int learnedWordsCount;
}

@end

@implementation AbstractLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _util = [[UserUtil alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark initialization (required in child class)
- (void)initLearnView{
    self.learnView = [[LearnView alloc] initWithFrame:self.view.frame];
    self.learnView.delegate = self;
    self.learnView.wordsDic = [self getWordsDic];
    [self.view addSubview:self.learnView];

    _numberOfWords = (int)[self.learnView.wordsDic[@"wordId"] count];
    [self.learnView generateCardView:0 cardCount:MIN(5, _numberOfWords) delegate:self];
}

- (void)initArrays
{
    _leftCountArray = [[NSMutableArray alloc] init];
    _swipeDurationArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _numberOfWords; i++) {
        [_leftCountArray addObject:@0];
        [_swipeDurationArray addObject:@0];
    }
}
#pragma mark delegate method (Abstract)
- (void)cancelButtonPushedDelegate{
    DLog(@"cancelButtonPushedDelegate");
    [self stopTimer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark delegate method
- (void)cardViewSwipedDelegate:(BOOL)hasRememberd cardView:(DraggableCardView *)cardView
{
    [self stopTimer];
    cardView.swipeDuration += -[_date timeIntervalSinceNow];

    //知ってたらremove, 知らなかったらsendSubviewToBack
    NSMutableArray *cardViews = [NSMutableArray arrayWithArray:self.learnView.cardBaseView.subviews];
    if (hasRememberd) {
        _leftCountArray[cardView.tag-1] = [NSNumber numberWithInt:cardView.leftCount];
        _swipeDurationArray[cardView.tag-1] = [NSNumber numberWithFloat:cardView.swipeDuration];
        [cardView removeCardViewAndTransformations];
        
        //実際にremoveFromSuperViewされるのは0.2秒後なのでここでArrayから削除
        [cardViews removeObjectAtIndex:cardViews.count-1];
        
        //cardViewが0枚で、shouldLearnAgainだったらもう一度Learn
        if (cardViews.count==0 && self.shouldLearnAgain) {
            [_util playSound:@"sound_finish" playSoundFlag:YES];
            learnedWordsCount += 5;
            int remainingWordsCount = self.numberOfWords-learnedWordsCount;
            self.shouldLearnAgain = remainingWordsCount>5 ? YES:NO;
            [self.learnView generateCardView:learnedWordsCount cardCount:MIN(learnedWordsCount+5, self.numberOfWords) delegate:self];
            [self performSelector:@selector(playFirstWord) withObject:nil afterDelay:0.8];
            return;
        }
        
        //cardViewが0枚で、shouldLearnAgainだったらfinish
        else if (cardViews.count == 0 && !self.shouldLearnAgain) {
            [_util playSound:@"sound_finish" playSoundFlag:YES];
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
            [self finishLearn];
            return;
        }
    } else {
        cardView.leftCount++;
        cardView.japaneseLabel.hidden = YES;
        [self.learnView.cardBaseView sendSubviewToBack:cardView];
        [cardView resetViewPositionAndTransformations];
        cardViews = [NSMutableArray arrayWithArray:self.learnView.cardBaseView.subviews];
    }
    
    //次の単語を発音
    self.learnView.topCardView = (DraggableCardView *)[cardViews objectAtIndex:cardViews.count-1];
    [_util playSound:self.learnView.topCardView.englishLabel.text playSoundFlag:YES];
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:0.5];
}

#pragma mark play first word method(after generating next cards)
- (void)playFirstWord
{
    NSArray *cardViews = self.learnView.cardBaseView.subviews;
    self.learnView.topCardView = (DraggableCardView *)[cardViews objectAtIndex:cardViews.count-1];
    [_util playSound:self.learnView.topCardView.englishLabel.text playSoundFlag:YES];
    [self startTimer];
}

#pragma mark override methods (required)
- (NSDictionary *)getWordsDic
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @{};
}

- (void)finishLearn
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark Override method (optional)
- (void)startTimer {
    _date = [NSDate date];
    DLog(@"if you want to add timer, please override this method");
}
- (void)stopTimer {
    DLog(@"if you want to add timer, please override this method");
}
- (void)timerAction {
    DLog(@"if you want to add timer, please override this method");
}


@end
