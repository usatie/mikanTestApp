//
//  LearnTestResultViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/18.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnTestResultViewController.h"

@interface LearnTestResultViewController ()

@end

@implementation LearnTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
