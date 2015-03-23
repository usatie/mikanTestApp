//
//  LearnViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnViewController.h"
#import "DraggableCardView.h"
#import "TestViewController.h"

@interface LearnViewController (){
    BOOL shouldLearnAgain;
    BOOL isTimerValid;
    NSTimer *timer;
}

@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLearnView];
    [self willPlayNextWord];
    [self startTimer];
    if (self.numberOfWords > 5) {
        shouldLearnAgain = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"learnToTest"]) {
        TestViewController *vc = segue.destinationViewController;
        vc.tmpDic = self.learnView.wordsDic;
    }
}

#pragma mark override method
- (NSDictionary *)getWordsDic {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    BOOL learnMode = [ud boolForKey:@"learnMode"];
    return [DBHandler getRelearnWords:category limit:10 remembered:NO hasTested:learnMode];//[DBHandler getRelearnWords:category limit:10 remembered:YES hasTested:YES];
}

- (void)didSubviewsRemoved {
    
    //(stop timer)
    [self playSound:@"sound_finish"];
    
    if (shouldLearnAgain) {
        //1. generate next card
        //start timer
        shouldLearnAgain = NO;
        [self.learnView generateCardView:5 cardCount:self.numberOfWords];
        [self willPlayNextWord];
    } else {
        //2. segue to test
        [self stopTimer];
        [self performSegueWithIdentifier:@"learnToTest" sender:self];
        DLog(@"segue to test");
    }
    
}

- (void)willPlayNextWord {
    DLog(@"next card");
    //sound "next"
//    DraggableCardView *cardView = (DraggableCardView *)[self.learnView.cardBaseView.subviews objectAtIndex:self.learnView.cardBaseView.subviews.count-1];
    [self playSound:self.learnView.topCardView.englishLabel.text];

    //start timer
    [self startTimer];
}

- (void)cancelButtonPushedDelegate{
    [self stopTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Timer
- (void)startTimer
{
    if (isTimerValid) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    isTimerValid = YES;
}

- (void)stopTimer
{
    if (isTimerValid) {
        [timer invalidate];
    }
    isTimerValid = NO;
}

- (void)timerAction
{
    DLog(@"timerAction");
//    DraggableCardView *cardView = (DraggableCardView *)[self.learnView.cardBaseView.subviews objectAtIndex:self.learnView.cardBaseView.subviews.count-1];
    [self.learnView sendCardViewToBack:self.learnView.topCardView];
}

#pragma mark sound
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