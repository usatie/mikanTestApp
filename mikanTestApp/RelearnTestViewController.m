//
//  RelearnTestViewController.m
//  
//
//  Created by Shun Usami on 2015/03/17.
//
//

#import "RelearnTestViewController.h"
#import "RelearnTestResultViewController.h"

@interface RelearnTestViewController () {
    NSTimer *timer;
    BOOL isTimerValid;
}

@end

@implementation RelearnTestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Test Override Methods 
- (void)finishTest {
    [self.audio stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopTimer];
    [DBHandler insertTestResult:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:1];
    
    [self performSegueWithIdentifier:@"testToResult" sender:self];
}

- (void)cancelButtonPushed {
    DLog(@"test was cancelled");
    [self.audio stop];
    [self dismissViewControllerAnimated:YES completion:^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self stopTimer];
    }];
}


#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TestResultViewController にtestWordsDicを引き渡し
    if ([segue.identifier isEqualToString:@"segueToResult"]) {
        RelearnTestResultViewController *vc = segue.destinationViewController;
        vc.testedWordsDic = self.testWordsDic;
    }
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
    DLog(@"stopTimer");
    if (isTimerValid) {
        [timer invalidate];
    }
    isTimerValid = NO;
}

- (void)timerAction
{
    DLog(@"timerAction");
    [self answerButtonPushedDelegate:NO choice:5];
}


#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    if ([ud boolForKey:@"totalRelearnMode"]) {
        return [DBHandler getRelearnWords:category limit:250 remembered:YES hasTested:YES];
    } else{
        return [DBHandler getRelearnWords:category limit:10 remembered:YES hasTested:YES];
    }
}
@end
