//
//  SampleLearnViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "SampleLearnViewController.h"

@interface SampleLearnViewController ()

@end

@implementation SampleLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)getWordsDic {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    BOOL learnMode = [ud boolForKey:@"learnMode"];
    return [DBHandler getRelearnWords:category limit:10 remembered:NO hasTested:learnMode];
}

- (void)didSubviewsRemoved {
    
    //(stop timer)
    
    //sound "finish"
    
    
    
    //1. generate next card
    //start timer
    //sound "next"
    [self.learnView generateCardView:5 cardCount:10];
    
    //2. segue to test
    
    //    [self.learnView generateCardView:5 cardCount:10];
}

- (void)willPlayNextWord {
    DLog(@"next card");
    //start timer
    
    //sound "next"
}


@end
