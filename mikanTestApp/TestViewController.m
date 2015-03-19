//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/19.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    [[NSUserDefaults standardUserDefaults] setObject:self.testWordsDic forKey:@"testWordsDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"testToResult" sender:self];
}

- (void)testCancelDelegate {
    DLog(@"test was cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    return _tmpDic;//[DBHandler getRelearnWords:@"TOEIC" limit:10 remembered:NO hasTested:NO];//[self getTestWordsDictionaryWithFileName:@"sample_test"];
}

@end
