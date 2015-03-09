//
//  SecondViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSDictionary *countDic;
}

@end

@implementation ResultsViewController


#pragma mark ViewController Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.resultsTableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Initialization
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    countDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"countDictionary"];
    NSInteger dataCount = [countDic[@"count"] count];
    return dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    // 再利用できるセルがあれば再利用する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %d    SCORE %d/30",countDic[@"countLabel"][indexPath.row],[countDic[@"section"][indexPath.row] intValue],[countDic[@"count"][indexPath.row] intValue]];
            break;
        case 1:
//            cell.textLabel.text = self.dataSourceAndroid[indexPath.row];
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Test Results";
}
- (IBAction)deleteButtonPushed:(id)sender {
    UIAlertView *deletionAlertView = [[UIAlertView alloc] initWithTitle:@"全ての記録を削除しますか？" message:@"全てのデータが削除され、復元不可能です。削除しますか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"全て削除", nil];
    [deletionAlertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"DismissButton pushed");
            //１番目のボタンが押されたときの処理を記述する
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"countDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.resultsTableView reloadData];
            break;
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self.resultsTableView reloadData];
    [refreshControl endRefreshing];
}
@end
