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
    BOOL isTimerValid;
    NSTimer *timer;
}

@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLearnView];
    [self initArrays];
    [self playSound:self.learnView.topCardView.englishLabel.text];
    [self startTimer];
    if (self.numberOfWords > 5) {
        self.shouldLearnAgain = YES;
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
        NSMutableDictionary *resultsDic = [[NSMutableDictionary alloc] initWithDictionary:self.learnView.wordsDic];
        [resultsDic setObject:self.leftCountArray forKey:@"leftCount"];
        [resultsDic setObject:self.swipeDurationArray forKey:@"swipeDuration"];
        DLog(@"wordsDic = %@",resultsDic);
        
        TestViewController *vc = segue.destinationViewController;
        vc.tmpDic = resultsDic;
    }
}

#pragma mark override method
- (NSDictionary *)getWordsDic {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    BOOL learnMode = [ud boolForKey:@"learnMode"];
    return [DBHandler getRelearnWords:category limit:10 remembered:NO hasTested:learnMode];
}

- (void)finishLearn
{
    [self stopTimer];
    DLog(@"swipeDuration = %@, leftCount = %@",self.swipeDurationArray, self.leftCountArray);
    [DBHandler insertLearnResultWithArray:self.learnView.wordsDic[@"wordId"] durationArray:self.swipeDurationArray leftCountArray:self.leftCountArray learnType:LEARN_TYPE_READ relearnFlag:NO];
    [self performSegueWithIdentifier:@"learnToTest" sender:self];
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
    self.date = [NSDate date];
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
    [self.learnView sendCardViewToBack:self.learnView.topCardView];
}

#pragma mark sound (will be Deprecated)
-(void)playSound:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3",fileName] ofType:nil];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) NSLog(@"error. could not pronounce %@", fileName);
        [self.audio play];
    } else {
    }
}

@end