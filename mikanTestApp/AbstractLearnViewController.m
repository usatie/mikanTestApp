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
    DLog(@"%@",self.learnView.wordsDic);
    _numberOfWords = (int)[self.learnView.wordsDic[@"wordId"] count];
    DLog(@"number = %d",_numberOfWords);
    [self.learnView generateCardView:0 cardCount:MIN(5, _numberOfWords)];
    [self.view addSubview:self.learnView];
}

#pragma mark delegate
- (void)cancelButtonPushedDelegate{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didAllSubviewsRemoved {
    [self playSound:@"sound_finish"];
    
    if (self.shouldLearnAgain) {
        //さらにカードを生成する場合はこちら
        learnedWordsCount += 5;
        if (self.numberOfWords-learnedWordsCount <= 5) {
            //残りカード枚数が5枚以下のときは次の学習で終わり
            self.shouldLearnAgain = NO;
        }
        [self.learnView generateCardView:learnedWordsCount cardCount:MIN(self.numberOfWords, learnedWordsCount+5)];
        [self willPlayNextWord];
    } else {
        //Learn終了時はこちら
        [self finishLearn];
    }
}

- (void)willPlayNextWord {
    DLog(@"next card");
    //sound "next"
    [self playSound:self.learnView.topCardView.englishLabel.text];
    //start timer
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
