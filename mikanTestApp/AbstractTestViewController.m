//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractTestViewController.h"
#import "UserUtil.h"


@interface AbstractTestViewController (){
    UserUtil *util;
    
    int testIndex;
    BOOL shouldPlaySound;
}

@end

@implementation AbstractTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /* 
     ToDo : GAITrackedViewController
     */
    [self initTestView];
    util = [[UserUtil alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark initialization
- (void)initTestView{
    self.testView = [[TestView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.testView];
    
    [self.testView.answerButton1 addTarget:self action:@selector(answerButtonPushed:) forControlEvents:UIControlEventTouchDown];
    [self.testView.answerButton2 addTarget:self action:@selector(answerButtonPushed:) forControlEvents:UIControlEventTouchDown];
    [self.testView.answerButton3 addTarget:self action:@selector(answerButtonPushed:) forControlEvents:UIControlEventTouchDown];
    [self.testView.answerButton4 addTarget:self action:@selector(answerButtonPushed:) forControlEvents:UIControlEventTouchDown];
}

- (void)loadUserDefaults
{
    shouldPlaySound = YES;
}

#pragma mark show methods
- (void)showNextWord
{
    [self.testView.answerButton1 setTitle:_testWordsDic[@"choicesArray"][testIndex][0] forState:UIControlStateNormal];
    [self.testView.answerButton2 setTitle:_testWordsDic[@"choicesArray"][testIndex][1] forState:UIControlStateNormal];
    [self.testView.answerButton3 setTitle:_testWordsDic[@"choicesArray"][testIndex][2] forState:UIControlStateNormal];
    [self.testView.answerButton4 setTitle:_testWordsDic[@"choicesArray"][testIndex][3] forState:UIControlStateNormal];
}

- (void)pronounceNextWord{
    [util playSound:_testWordsDic[@"english"][testIndex] playSoundFlag:shouldPlaySound];
}


#pragma mark Button Action
- (void)answerButtonPushed:(UIButton *)btn{
    DLog(@"answerButtonPushed tag = %d",(int)btn.tag);
    
    [self showNextWord];
    [self pronounceNextWord];
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
