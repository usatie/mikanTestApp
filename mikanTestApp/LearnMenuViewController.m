//
//  FirstViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnMenuViewController.h"
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
    [self refreshButtonTitles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[_sectionSegmentedControl titleForSegmentAtIndex:_sectionSegmentedControl.selectedSegmentIndex] forKey:@"category"];
    if (sender == _learnNewWordsButton) {
        [ud setBool:NO forKey:@"learnMode"];
    } else if (sender == _learnButton){
        [ud setBool:YES forKey:@"learnMode"];
    } else if (sender == _totalRelearnButton){
        [ud setBool:YES forKey:@"totalRelearnMode"];
    } else if (sender == _relearnButton) {
        [ud setBool:NO forKey:@"totalRelearnMode"];
    }
    [ud synchronize];
}

- (void)refreshButtonTitles{
    NSArray *arr = [DBHandler getRelearnWordsCount:[_sectionSegmentedControl titleForSegmentAtIndex:_sectionSegmentedControl.selectedSegmentIndex]];
    [_relearnButton setTitle:[NSString stringWithFormat:@"記憶済（%@）",arr[0]] forState:UIControlStateNormal];
    [_learnNewWordsButton setTitle:[NSString stringWithFormat:@"未学習（%@）",arr[1]] forState:UIControlStateNormal];
    [_learnButton setTitle:[NSString stringWithFormat:@"学習中（%@）",arr[2]] forState:UIControlStateNormal];
}

- (IBAction)learnCategoryChanged:(id)sender {
    [self refreshButtonTitles];
}
@end
