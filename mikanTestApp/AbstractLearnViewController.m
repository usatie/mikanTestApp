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
    //本当はsubClassから天下りでwordsDicを貰ってくる。
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    BOOL learnMode = [ud boolForKey:@"learnMode"];
    self.learnView.wordsDic = [DBHandler getRelearnWords:category limit:10 remembered:NO hasTested:learnMode];
    //
    [self.learnView generateCardView:0 cardCount:5];
    [self.view addSubview:self.learnView];
}

- (NSDictionary *)getTestWords
{
    // 継承したクラスで実装する
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @{};
}


#pragma mark delegate
- (void)cancelButtonPushedDelegate{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
