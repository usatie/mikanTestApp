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


#pragma mark initialization
- (void)initLearnView{
    self.learnView = [[LearnView alloc] initWithFrame:self.view.frame];
    self.learnView.delegate = self;
    self.learnView.wordsDic = [self getWordsDic];
    [self.view addSubview:self.learnView];

    _numberOfWords = (int)[self.learnView.wordsDic[@"wordId"] count];
    [self.learnView generateCardView:0 cardCount:MIN(5, _numberOfWords)];
}

#pragma mark delegate method (Abstract)
- (void)cancelButtonPushedDelegate{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cardViewSwiped
{
    //cardsBaseViewのsubviewsが０だったらfinish
    if (self.learnView.cardBaseView.subviews.count == 0) {
        //play "finish!"
        [self didAllSubviewsRemoved];
    } else {
        //set top card
        NSArray *cardViews = self.learnView.cardBaseView.subviews;
        self.learnView.topCardView = (DraggableCardView *)[cardViews objectAtIndex:cardViews.count-1];
        
        //play "next words"
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
    DLog(@"if you want to add timer, please override this method");
}
- (void)stopTimer {
    DLog(@"if you want to add timer, please override this method");
}
- (void)timerAction {
    DLog(@"if you want to add timer, please override this method");
}

#pragma mark custom method
- (void)didAllSubviewsRemoved {
    [self playSound:@"sound_finish"];
    
    if (self.shouldLearnAgain) {//残りが5枚以下の時は次が最後
        learnedWordsCount += 5;
        if (self.numberOfWords-learnedWordsCount <= 5) {
            self.shouldLearnAgain = NO;
        }
        [self.learnView generateCardView:learnedWordsCount cardCount:MIN(learnedWordsCount+5, self.numberOfWords)];
        [self playSound:self.learnView.topCardView.englishLabel.text];
        [self startTimer];
    } else {//Learn終了時
        [self finishLearn];
    }
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
