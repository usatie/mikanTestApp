//
//  FirstViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnMenuViewController.h"
#import "LearnViewController.h"
#import "DBHandler.h"

@interface LearnMenuViewController ()

@end

@implementation LearnMenuViewController
#pragma mark Initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *dic = [DBHandler getRelearnWords:[_sectionSegmentedControl titleForSegmentAtIndex:_sectionSegmentedControl.selectedSegmentIndex] limit:10 remembered:YES hasTested:YES];
    [_relearnButton setTitle:[NSString stringWithFormat:@"復習テスト（%lu）",[dic[@"wordId"] count]] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[_sectionSegmentedControl titleForSegmentAtIndex:_sectionSegmentedControl.selectedSegmentIndex] forKey:@"category"];
    [ud setBool:_learnModeSegmentedControl.selectedSegmentIndex forKey:@"learnMode"];
    [ud synchronize];

    if ( [[segue identifier] isEqualToString:@"segueToLearn"] ) {
//        LearnViewController *learnVC = [segue destinationViewController];
//        learnVC.learnCategoryId = (int)_sectionSegmentedControl.selectedSegmentIndex+1;
//        learnVC.frequency = (int)_frequencySegmentedControl.selectedSegmentIndex+1;
    }

}


- (IBAction)learnCategoryChanged:(id)sender {
    NSDictionary *dic = [DBHandler getRelearnWords:[_sectionSegmentedControl titleForSegmentAtIndex:_sectionSegmentedControl.selectedSegmentIndex] limit:10 remembered:YES hasTested:YES];
    [_relearnButton setTitle:[NSString stringWithFormat:@"復習テスト（%lu）",[dic[@"wordId"] count]] forState:UIControlStateNormal];
}
@end
