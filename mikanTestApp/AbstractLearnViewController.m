//
//  AbstractLearnViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractLearnViewController.h"

@interface AbstractLearnViewController ()

@end

@implementation AbstractLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initLearnView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark initialization
- (void)initLearnView{
    self.learnView = [[LearnView alloc] initWithFrame:self.view.frame];
    self.learnView.delegate = self;
    [self.view addSubview:self.learnView];
}



#pragma mark delegate
- (void)cancelButtonPushedDelegate{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
