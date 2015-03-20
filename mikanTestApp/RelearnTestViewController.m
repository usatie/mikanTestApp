//
//  RelearnTestViewController.m
//  
//
//  Created by Shun Usami on 2015/03/17.
//
//

#import "RelearnTestViewController.h"
#import "RelearnTestResultViewController.h"

@interface RelearnTestViewController ()

@end

@implementation RelearnTestViewController
- (void)viewDidLoad {
    self.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Test Delegate Methods
- (void)finishDelegate{
    [DBHandler insertTestResult:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:0];
    [self performSegueWithIdentifier:@"segueToResult" sender:self];
}

- (void)testCancelDelegate {
    DLog(@"test was cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TestResultViewController にtestWordsDicを引き渡し
    if ([segue.identifier isEqualToString:@"segueToResult"]) {
        RelearnTestResultViewController *vc = segue.destinationViewController;
        vc.testedWordsDic = self.testWordsDic;
    }
}

#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    NSString *category = [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
    return [DBHandler getRelearnWords:category limit:10 remembered:YES hasTested:YES];
}
@end
