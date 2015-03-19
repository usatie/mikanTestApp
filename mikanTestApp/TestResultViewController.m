//
//  TestResultViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/19.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestResultViewController.h"

#import "WordTableView.h"
#import "CustomTableViewCell.h"
#import "DBHandler.h"

@interface TestResultViewController (){
    NSMutableDictionary *wordsDic;
    
    UIScrollView *scrollView;
    WordTableView *tableView;
}

@end

@implementation TestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDictionary *testedWordsDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"testWordsDic"];
    wordsDic = [[NSMutableDictionary alloc] initWithDictionary:testedWordsDic];
    [wordsDic addEntriesFromDictionary:[DBHandler getHasRememberedDicWithWordIdArray:testedWordsDic[@"wordId"]]];
    
    //init scroll view
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(320, 550);
    [self.view addSubview:scrollView];
    
    //init table view
    tableView = [[WordTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 55*[wordsDic[@"wordId"] count]) wordsDic:wordsDic];
    [scrollView addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"おわり" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPushed:)];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"つぎへ" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPushed:)];
//    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TableView delegate methods
#pragma mark Button Actions
//- (IBAction)backButtonPushed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSMutableArray *hasrememberedArray = [[NSMutableArray alloc] init];
//        for (int i = 0; i<10; i++) {
//            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
//            CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
//            [hasrememberedArray addObject:[NSNumber numberWithBool:cell.hasChecked]];
//        }
//        [DBHandler setHasRememberedWithArray:wordsDic[@"wordId"] hasRememberedArray:hasrememberedArray];
//    }];
//}

- (IBAction)nextButtonPushed:(id)sender {
    DLog(@"next");
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *hasrememberedArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<10; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            [hasrememberedArray addObject:[NSNumber numberWithBool:cell.hasChecked]];
        }
        [DBHandler setHasRememberedWithArray:wordsDic[@"wordId"] hasRememberedArray:hasrememberedArray];
    }];

    //    [self dismissViewControllerAnimated:YES completion:^{
    //        NSMutableArray *hasrememberedArray = [[NSMutableArray alloc] init];
    //        for (int i = 0; i<10; i++) {
    //            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
    //            CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
    //            [hasrememberedArray addObject:[NSNumber numberWithBool:cell.hasChecked]];
    //        }
    //        [DBHandler setHasRememberedWithArray:testedWordsDic[@"wordId"] hasRememberedArray:hasrememberedArray];
    //    }];
}

@end