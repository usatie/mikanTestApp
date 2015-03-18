//
//  LearnTestResultViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/18.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnTestResultViewController.h"
#import "WordTableView.h"
#import "CustomTableViewCell.h"
#import "DBHandler.h"

@interface LearnTestResultViewController (){
    UIScrollView *scrollView;
    NSDictionary *testedWordsDic;
    NSDictionary *hasRememberedDic;
    NSArray *resultImageNameArray;
    
    WordTableView *tableView;
}

@end

@implementation LearnTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    testedWordsDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"testWordsDic"];
    hasRememberedDic = [DBHandler getHasRememberedDicWithWordIdArray:testedWordsDic[@"wordId"]];
    resultImageNameArray = @[@"bad.png",@"good.png",@"great.png",@"excellent.png"];
    NSMutableDictionary *wordsDic = [[NSMutableDictionary alloc] initWithDictionary:testedWordsDic];
    [wordsDic addEntriesFromDictionary:hasRememberedDic];
    tableView = [[WordTableView alloc] initWithFrame:CGRectMake(0, 20+self.navigationController.navigationBar.frame.size.height, 320, 550) wordsDic:wordsDic];
    [self.view addSubview:tableView];
    
    DLog(@"%@",hasRememberedDic);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"%@",hasRememberedDic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TableView delegate methods
#pragma mark Button Actions
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *hasrememberedArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<10; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            [hasrememberedArray addObject:[NSNumber numberWithBool:cell.hasChecked]];
        }
        [DBHandler setHasRememberedWithArray:testedWordsDic[@"wordId"] hasRememberedArray:hasrememberedArray];
    }];
}
@end