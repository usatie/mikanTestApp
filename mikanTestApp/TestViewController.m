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
#pragma mark Definition

#define NUMBER_OF_QUESTION 30

#pragma mark Initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"modeID = %d, sectionID = %d",_modeId,_sectionId);
    _testWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark CSVHandling
- (NSDictionary *)getTestWordsDictionaryWithFileName:(NSString *)fileName
{
    NSString *csvFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
    NSData *csvData = [NSData dataWithContentsOfFile:csvFile];
    NSString *csv = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
    NSScanner *scanner = [NSScanner scannerWithString:csv];
    
    NSCharacterSet *chSet = [NSCharacterSet newlineCharacterSet];
    NSString *line;
    NSMutableArray *csvArray = [[NSMutableArray alloc] init];
    NSMutableArray *wordIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *englishLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *choicesArray = [[NSMutableArray alloc] init];
    NSMutableArray *answersArray = [[NSMutableArray alloc] init];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,4)];
    
    //csvから読み込み
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
        NSArray *array = [line componentsSeparatedByString:@","];
        [csvArray addObject:array];
        [scanner scanCharactersFromSet:chSet intoString:NULL];
    }
    
    //セクションの単語30個をランダムに並び替え
    for (int i = 0; i<NUMBER_OF_QUESTION; i++) {
        int randWordId = arc4random()%(NUMBER_OF_QUESTION-i)+NUMBER_OF_QUESTION*_sectionId;
        [englishLabelArray addObject:csvArray[randWordId][0]];
        [wordIdArray addObject:csvArray[randWordId][1]];
        [choicesArray addObject:[csvArray[randWordId] objectsAtIndexes:indexSet]];
        [answersArray addObject:csvArray[randWordId][6]];
        
        [csvArray removeObjectAtIndex:randWordId];
    }
    
    //Dictionary型にいれる
    return [[NSDictionary alloc] initWithObjects:@[wordIdArray,englishLabelArray,choicesArray,answersArray] forKeys:@[@"wordId",@"english",@"choices",@"answer"]];
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
