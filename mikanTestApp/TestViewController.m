//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/19.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestViewController.h"
#import "TestResultViewController.h"

@interface TestViewController ()

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
    [DBHandler insertTestResultWithArray:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:0];
    
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

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TestResultViewController にtestWordsDicを引き渡し
    if ([segue.identifier isEqualToString:@"testToResult"]) {
        TestResultViewController *vc = segue.destinationViewController;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.testWordsDic];
        [dic setObject:self.isUnsureArray forKey:@"isUnsure"];
        vc.testedWordsDic = dic;
    }
}

#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    return _tmpDic;
}

@end
