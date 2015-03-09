//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnViewController.h"

@interface LearnViewController (){
    int questionIndex;
    int correctCount;
}

@end

@implementation LearnViewController
#pragma mark Definition

#define NUMBER_OF_QUESTION 30
#define NUMBER_OF_WORDS_PER_LEAARNING 5
#define NUMBER_OF_WORDS_PER_CATEGORY 100

#pragma mark ViewController Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"modeID = %d, learnCategoryID = %d",_modeId,_learnCategoryId);
    _audio = [[AVAudioPlayer alloc] init];
    _learnWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
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
    NSMutableArray *englishArray = [[NSMutableArray alloc] init];
    NSMutableArray *japaneseArray = [[NSMutableArray alloc] init];
    NSIndexSet *categoryIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange((_learnCategoryId-1)*100, 100)];
    
    //csvから読み込み、各Arrayに一旦収納
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
        NSArray *array = [line componentsSeparatedByString:@","];
        [wordIdArray addObject:array[0]];
        [englishArray addObject:array[1]];
        [japaneseArray addObject:array[2]];
        [scanner scanCharactersFromSet:chSet intoString:NULL];
    }
    
    return [[NSDictionary alloc] initWithObjects:@[[wordIdArray objectsAtIndexes:categoryIndexSet],[englishArray objectsAtIndexes:categoryIndexSet],[japaneseArray objectsAtIndexes:categoryIndexSet]] forKeys:@[@"wordId",@"english",@"japanese"]];

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
    if (tagNum == [_learnWordsDic[@"answer"][[self wordIndex]] intValue]){
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
    _englishLabel.text = _learnWordsDic[@"english"][[self wordIndex]];
    for (int i = 1; i<=4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        [btn setTitle:[NSString stringWithFormat:@"　%d.　%@",i,_learnWordsDic[@"japanese"][[self wordIndex]]] forState:UIControlStateNormal];
    }
}

- (void)saveResult
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *countLabelArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"countDictionary"][@"countLabel"]];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"countDictionary"][@"section"]];
    NSMutableArray *countArray = [[NSMutableArray alloc] initWithArray:[ud objectForKey:@"countDictionary"][@"count"]];
    
    [countLabelArray addObject:@"TEST"];
    [sectionArray addObject:[NSNumber numberWithInt:_learnCategoryId]];
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