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
    int progress;
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
- (void)initAlertView{
    self.cancelAlertView = [[UIAlertView alloc] initWithTitle:@"再開" message:@"学習をつづけますか？" delegate:self cancelButtonTitle:@"ここまでの結果を表示" otherButtonTitles:@"はい", nil];
}

- (void)finishTest {
    [DBHandler insertTestResult:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:1];
    [self performSegueWithIdentifier:@"segueToResult" sender:self];
}

- (void)cancelButtonPushed {
    DLog(@"test was cancelled");
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.resultsArray count])];
    [DBHandler insertTestResult:[self.testWordsDic[@"wordId"] objectsAtIndexes:indexSet] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:1];
    [self performSegueWithIdentifier:@"segueToResult" sender:self];
}


#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TestResultViewController にtestWordsDicを引き渡し
    if ([segue.identifier isEqualToString:@"segueToResult"]) {
        RelearnTestResultViewController *vc = segue.destinationViewController;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.resultsArray count])];
        vc.testedWordsDic = [self getSmallDictionary:self.testWordsDic indexSet:indexSet];
    }
}

#pragma mark Timer
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

- (NSDictionary *)getSmallDictionary:(NSDictionary *)dic indexSet:(NSIndexSet *)indexSet
{
    NSMutableDictionary *smallDic = [[NSMutableDictionary alloc] init];
    
    for (id key in dic) {
        [smallDic setObject:[[dic objectForKey:key] objectsAtIndexes:indexSet] forKey:key];
    }
    
    return smallDic;
}
@end
