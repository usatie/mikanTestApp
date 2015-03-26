//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/19.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestViewController.h"
#import "TestResultViewController.h"

@interface TestViewController (){
    NSTimer *timer;
    BOOL isTimerValid;
    int progress;
    
}

@end

@implementation TestViewController
#pragma mark ViewController Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Test Override methods
- (void)finishTest {
    [DBHandler insertTestResult:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:0];
    
    [self performSegueWithIdentifier:@"testToResult" sender:self];
}

- (void)cancelButtonPushed {
    DLog(@"test was cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonPushedBeforeAnswering
{
    [self.cancelAlertView show];
}

//#pragma mark Timer (override)
//- (void)startTimer
//{
//    if (isTimerValid) {
//        [timer invalidate];
//    }
//    timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
//    isTimerValid = YES;
//}
//
//- (void)stopTimer
//{
//    DLog(@"stopTimer");
//    if (isTimerValid) {
//        [timer invalidate];
//    }
//    isTimerValid = NO;
//}
//
//- (void)timerAction
//{
//    DLog(@"timerAction");
//    [self answerButtonPushedDelegate:NO choice:5];
//}
#pragma mark Timer (override)
- (void)startTimer
{
    if (isTimerValid) {
        [timer invalidate];
    }
    progress = 0;
    self.testView.progressBar.progress = 1.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    isTimerValid = YES;
    
}

- (void)stopTimer
{
    DLog(@"stopTimer");
    if (isTimerValid) {
        [timer invalidate];
    }
    isTimerValid = NO;
}

- (void)timerAction
{
    progress ++;
    if (progress > 3000) {
        [self answerButtonPushedDelegate:NO choice:5];
    } else {
        [self.testView.progressBar setProgress:1.0-progress/3000.0];
    }
}


#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TestResultViewController にtestWordsDicを引き渡し
    if ([segue.identifier isEqualToString:@"testToResult"]) {
        TestResultViewController *vc = segue.destinationViewController;
        vc.testedWordsDic = self.testWordsDic;
    }
}

#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    return _tmpDic;
}

@end
