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
#import "LearnMenuViewController.h"

typedef void(^completion)(BOOL);


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
    //testedWordsDicはTestViewControllerのprepareForSegueで貰ってくる。
    wordsDic = [[NSMutableDictionary alloc] initWithDictionary:_testedWordsDic];
    [wordsDic addEntriesFromDictionary:[DBHandler getHasRememberedDicWithWordIdArray:_testedWordsDic[@"wordId"]]];
    
    //init scroll view
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 55*[wordsDic[@"wordId"] count]);
    [self.view addSubview:scrollView];
    
    //init table view
    tableView = [[WordTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,55*[wordsDic[@"wordId"] count]) wordsDic:wordsDic];
    [scrollView addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"つぎへ" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPushed:)];
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
- (void)nextButtonPushed:(id)sender {
    //①アーカイブ情報を保存完了 ⇒ ②dismiss ⇒ ③buttonの数字をrefresh
    [self saveRememberedArray:^(BOOL ifSucceed){
        if (ifSucceed) {
            LearnMenuViewController *vc = [(UITabBarController *)self.presentingViewController viewControllers][0];
            [self dismissViewControllerAnimated:YES completion:^{
                [vc refreshButtonTitles];
            }];
        }
    }];
    
}

- (void)saveRememberedArray:(completion)compblock
{
    NSMutableArray *hasrememberedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        CustomTableViewCell *cell = (CustomTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
        [hasrememberedArray addObject:[NSNumber numberWithBool:cell.hasChecked]];
    }
    [DBHandler setHasRememberedWithArray:wordsDic[@"wordId"] hasRememberedArray:hasrememberedArray];
    compblock(YES);
}


@end