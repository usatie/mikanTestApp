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
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark delegate method
- (void)cardViewSwipedDelegate:(BOOL)hasRememberd cardView:(DraggableCardView *)cardView
{
    cardView.swipeDuration += -[_date timeIntervalSinceNow];
    
    //知ってたらremove, 知らなかったらsendSubviewToBack
    if (hasRememberd) {
        _leftCountArray[cardView.tag-1] = [NSNumber numberWithInt:cardView.leftCount];
        _swipeDurationArray[cardView.tag-1] = [NSNumber numberWithFloat:cardView.swipeDuration];
        [cardView removeFromSuperview];
    } else {
        cardView.leftCount++;
        [self.learnView.cardBaseView sendSubviewToBack:cardView];
        [cardView resetViewPositionAndTransformations];
    }
    
    //cardViewが0枚で、shouldLearnAgainだったらもう一度Learn
    NSArray *cardViews = self.learnView.cardBaseView.subviews;
    if (cardViews.count==0 && self.shouldLearnAgain) {
        [self playSound:@"sound_finish"];
        learnedWordsCount += 5;
        int remainingWordsCount = self.numberOfWords-learnedWordsCount;
        self.shouldLearnAgain = remainingWordsCount>5 ? YES:NO;
        [self.learnView generateCardView:learnedWordsCount cardCount:MIN(learnedWordsCount+5, self.numberOfWords) delegate:self];
        [self playSound:self.learnView.topCardView.englishLabel.text];
        [self startTimer];
    }
    //cardViewが0枚で、shouldLearnAgainだったらfinish
    else if (cardViews.count==0 && !self.shouldLearnAgain) {
        [self playSound:@"sound_finish"];
        [self finishLearn];
    }
    //cardViewが残ってたら次の単語を発音
    else {
        self.learnView.topCardView = (DraggableCardView *)[cardViews objectAtIndex:cardViews.count-1];
        [self playSound:self.learnView.topCardView.englishLabel.text];
        [self startTimer];
    }
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

#pragma mark sound (will be Deprecated)
-(void)playSound:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3",fileName] ofType:nil];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) NSLog(@"error. could not pronounce %@", fileName);
        [_audio play];
    } else {
    }
}
@end
