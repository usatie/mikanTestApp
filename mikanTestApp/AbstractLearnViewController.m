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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark initialization
- (void)initLearnView{
    self.learnView = [[LearnView alloc] initWithFrame:self.view.frame];
    self.learnView.delegate = self;
    self.learnView.wordsDic = [self getWordsDic];
    DLog(@"%@",self.learnView.wordsDic);
    _numberOfWords = (int)[self.learnView.wordsDic[@"wordId"] count];
    DLog(@"number = %d",_numberOfWords);
    [self.learnView generateCardView:0 cardCount:MIN(5, _numberOfWords)];
    [self.view addSubview:self.learnView];
}

- (NSDictionary *)getWordsDic
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

- (void)didSubviewsRemoved {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    
    //(stop timer)
    
    //sound "finish"
    
    //1. generate next card
        //start timer
        //sound "next"
    
    
    //2. segue to test
    
//    [self.learnView generateCardView:5 cardCount:10];
}

- (void)willPlayNextWord {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    //start timer
    
    //sound "next"
}
@end
