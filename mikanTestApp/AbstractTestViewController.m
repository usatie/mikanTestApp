//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractTestViewController.h"


@interface AbstractTestViewController (){
}

@end

@implementation AbstractTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.testView = [[TestView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.testView];
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

@end
