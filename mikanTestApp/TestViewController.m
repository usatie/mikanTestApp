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

#pragma mark ViewController Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"modeID = %d, sectionID = %d",_modeId,_sectionId);
    _audio = [[AVAudioPlayer alloc] init];
    _testWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
    _randWordIndexArray = [self getRandWordIndexArray];
    [self showNextWord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Get Sth Method
- (NSDictionary *)getTestWordsDictionaryWithFileName:(NSString *)fileName
{
    NSString *csvFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
    NSData *csvData = [NSData dataWithContentsOfFile:csvFile];
    NSString *csv = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
    NSScanner *scanner = [NSScanner scannerWithString:csv];
    
    NSCharacterSet *chSet = [NSCharacterSet newlineCharacterSet];
    NSString *line;
    NSMutableArray *wordIdArray = [[NSMutableArray alloc] init];
    NSMutableArray *englishLabelArray = [[NSMutableArray alloc] init];
    NSMutableArray *choicesArray = [[NSMutableArray alloc] init];
    NSMutableArray *answersArray = [[NSMutableArray alloc] init];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2,4)];
    
    //csvから読み込み、各Arrayに一旦収納
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
        NSArray *array = [line componentsSeparatedByString:@","];
        [wordIdArray addObject:array[0]];
        [englishLabelArray addObject:array[1]];
        [choicesArray addObject:[array objectsAtIndexes:indexSet]];
        [answersArray addObject:array[6]];

        [scanner scanCharactersFromSet:chSet intoString:NULL];
    }
    
    return [[NSDictionary alloc] initWithObjects:@[wordIdArray,englishLabelArray,choicesArray,answersArray] forKeys:@[@"wordId",@"english",@"choices",@"answer"]];
}

- (NSArray *)getRandWordIndexArray{
    NSMutableArray *wordIndexArray = [[NSMutableArray alloc] init];
    NSMutableArray *randWordIndexArray = [[NSMutableArray alloc] init];
    
    while (wordIndexArray.count < NUMBER_OF_QUESTION) {
        [wordIndexArray addObject:[NSNumber numberWithInteger:wordIndexArray.count]];
    }
    for (int i = 0; i<NUMBER_OF_QUESTION; i++) {
        int randNum = arc4random()%(NUMBER_OF_QUESTION-i);
        int randWordId = [wordIndexArray[randNum] intValue] + NUMBER_OF_QUESTION*(_sectionId-1);
        [randWordIndexArray addObject:[NSNumber numberWithInt:randWordId]];
        [wordIndexArray removeObjectAtIndex:randNum];
    }
    return randWordIndexArray;
}

- (int)wordIndex{
    return [_randWordIndexArray[questionIndex] intValue];
}

#pragma mark ButtonAction
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)answerButtonPushed:(id)sender {
    UIButton *btn = sender;
    int tagNum = (int)btn.tag;
    if (tagNum == [_testWordsDic[@"answer"][[self wordIndex]] intValue]){
        [self playSound:@"sound_correct"];
        correctCount++;
    } else {
        [self playSound:@"sound_incorrect"];
    }
    questionIndex++;
    if (questionIndex<NUMBER_OF_QUESTION) [self showNextWord];
    else [self saveResult];
}


#pragma mark Word Related Method
- (void)showNextWord {
    _englishLabel.text = _testWordsDic[@"english"][[self wordIndex]];
    for (int i = 1; i<=4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        [btn setTitle:[NSString stringWithFormat:@"　%d.　%@",i,_testWordsDic[@"choices"][[self wordIndex]][i-1]] forState:UIControlStateNormal];
    }
}

- (void)saveResult
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *countLabelArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"countDictionary"][@"countLabel"]];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"countDictionary"][@"section"]];
    NSMutableArray *countArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"countDictionary"][@"count"]];
    
    [countLabelArray addObject:@"TEST"];
    [sectionArray addObject:[NSNumber numberWithInt:_sectionId]];
    [countArray addObject:[NSNumber numberWithInt:correctCount]];
    
    NSDictionary *countDic = [NSDictionary dictionaryWithObjects:@[countLabelArray,sectionArray,countArray] forKeys:@[@"countLabel",@"section",@"count"]];
    NSLog(@"countDic = %@",countDic);
    
    [[NSUserDefaults standardUserDefaults] setObject:countDic forKey:@"countDictionary"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)playSound:(NSString *)fileName
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