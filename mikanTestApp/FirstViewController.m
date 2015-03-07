//
//  FirstViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "FirstViewController.h"
#import "TestViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
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
    if ( [[segue identifier] isEqualToString:@"segueToTest"] ) {
        TestViewController *testVC = [segue destinationViewController];
        testVC.modeId = (int)_modeSegmentedControl.selectedSegmentIndex;
        testVC.sectionId = (int)_sectionSegmentedControl.selectedSegmentIndex;
    }

}

@end
