//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController
#pragma mark Initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"modeID = %d, sectionID = %d",_modeId,_sectionId);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ButtonAction
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)answerButtonPushed:(id)sender {
    UIButton *btn = sender;
    int tagNum = (int)btn.tag;
    NSLog(@"answerButton %d is pushed",tagNum);
}
@end
