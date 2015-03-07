//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController (){
    int questionIndex;
    int correctCount;
}

@end

@implementation TestViewController
#pragma mark Definition

#define NUMBER_OF_QUESTION 30

#pragma mark Initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"modeID = %d, sectionID = %d",_modeId,_sectionId);
    _audio = [[AVAudioPlayer alloc] init];
    _testWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
    [self showNextWord];
    NSLog(@"testWordsDic = %@",_testWordsDic);
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
        [wordIdArray addObject:csvArray[randWordId][0]];
        [englishLabelArray addObject:csvArray[randWordId][1]];
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
    if (tagNum == [_testWordsDic[@"answer"][questionIndex-1] intValue]){
        [self playSound:@"sound_correct" playSoundFlag:YES];
        correctCount++;
    }
    else [self playSound:@"sound_incorrect" playSoundFlag:YES];
    if (questionIndex<NUMBER_OF_QUESTION) [self showNextWord];
    else [self saveResult];
}


- (void)showNextWord {
    _englishLabel.text = _testWordsDic[@"english"][questionIndex];
    for (int i = 1; i<=4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        [btn setTitle:[NSString stringWithFormat:@"　%d.　%@",i,_testWordsDic[@"choices"][questionIndex][i-1]] forState:UIControlStateNormal];
    }
    questionIndex++;
}

- (void)saveResult
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *correctCountArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"correctCountArray"]];
    [correctCountArray addObject:[NSNumber numberWithInt:correctCount]];
    [[NSUserDefaults standardUserDefaults] setObject:correctCountArray forKey:@"correctCountArray"];
    NSLog(@"correctCountArray = %@",correctCountArray);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playSound:(NSString *)fileName
   playSoundFlag:(BOOL)playSoundFlag
{
    NSLog(@"playSound \"%@\"", fileName);
    NSString *soundPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",fileName]];
    NSURL *url = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"could not pronounce %@", fileName);
    }
    [_audio play];
}


@end