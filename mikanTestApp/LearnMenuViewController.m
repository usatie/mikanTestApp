//
//  FirstViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnMenuViewController.h"
#import "LearnViewController.h"

@interface LearnMenuViewController ()

@end

@implementation LearnMenuViewController
#pragma mark Initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( [[segue identifier] isEqualToString:@"segueToLearn"] ) {
//        LearnViewController *learnVC = [segue destinationViewController];
//        learnVC.learnCategoryId = (int)_sectionSegmentedControl.selectedSegmentIndex+1;
//        learnVC.frequency = (int)_frequencySegmentedControl.selectedSegmentIndex+1;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:_sectionSegmentedControl.selectedSegmentIndex+1 forKey:@"learnCategoryId"];
        [ud setInteger:_frequencySegmentedControl.selectedSegmentIndex+1 forKey:@"frequency"];
    }

}

@end
