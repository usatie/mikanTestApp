//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractTestViewController.h"
#import "UserUtil.h"
#import "answerButton.h"

@interface AbstractTestViewController (){
    UserUtil *util;
    
    int testIndex;
    int answerButtonTag;
    int choiceIndex;
    
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
    util = [[UserUtil alloc] init];
    _resultsArray = [[NSMutableArray alloc] init];
    _userChoicesArray = [[NSMutableArray alloc] init];
    _answerDurationArray = [[NSMutableArray alloc] init];
    _testWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
    DLog(@"testWordsDic = %@",_testWordsDic);
    


    [self initTestView];
    [self showAndPlayNextWord];
    
    //prepare
//    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3",@"sound_correct"] ofType:nil];
//    if (path) {
//        NSURL *url = [NSURL fileURLWithPath:path];
//        NSError *error;
//        _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        if (error) NSLog(@"error. could not pronounce the first file");
//        [_audio prepareToPlay];
//    } else {
//        //        NSLog(@"path is nil. Could not pronounce %@", fileName);
//    }
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
- (void)showAndPlayNextWord
{
    //[1...4]をランダムに並び替える
    NSMutableArray *randArray = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4]];
    for (int i = 0; i<4; i++) {
        [randArray exchangeObjectAtIndex:arc4random()%4 withObjectAtIndex:arc4random()%4];
//        DLog(@"randArray = %@",randArray);
    }
    //Button にrandomに選択肢を表示。正解の選択肢のタグを保存。
    for (int i = 0; i<4; i++) {
        int rand = [randArray[i] intValue];
        answerButton *btn = (answerButton *)[self.testView viewWithTag:i+1];
        [btn setTitle:_testWordsDic[@"choicesArray"][testIndex][rand-1] forState:UIControlStateNormal];
        btn.randomTag = rand;
    }
    
    //answerIndexを設定
    answerButtonTag = [_testWordsDic[@"answerIndex"][testIndex] intValue];
    
    //Englishを表示
    self.testView.englishLabel.text = _testWordsDic[@"english"][testIndex];
    
    //次の単語を発音
    [self playSound:_testWordsDic[@"english"][testIndex]];
    
    //indexを次に進める
    testIndex++;
}

#pragma mark Button Action
- (void)answerButtonPushed:(answerButton *)btn{
    choiceIndex = (int)btn.randomTag;
    [_userChoicesArray addObject:[NSNumber numberWithInt:choiceIndex]];
    if (choiceIndex == answerButtonTag) {
        [self playSound:@"sound_correct"];
        [_resultsArray addObject:@1];
    } else {
        [self playSound:@"sound_incorrect"];
        [_resultsArray addObject:@0];
    }
    
    if (testIndex < 10){
        [self performSelector:@selector(showAndPlayNextWord) withObject:nil afterDelay:0.3];
        return;
    }
    _testResultsDic = [NSDictionary dictionaryWithObjects:@[_resultsArray,_userChoicesArray] forKeys:@[@"result",@"userChoice"]];
    DLog(@"finish!\nresult = %@",_testResultsDic);
}


#pragma mark Temporary methods
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
//    NSMutableArray *japaneseArray = [[NSMutableArray alloc] init];
    NSMutableArray *choicesArrayArray = [[NSMutableArray alloc] init];
    NSMutableArray *answerIndexArray = [[NSMutableArray alloc] init];
    NSIndexSet *categoryIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
    NSIndexSet *choicesIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 4)];
    
    //csvから読み込み、各Arrayに一旦格納
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
        NSArray *array = [line componentsSeparatedByString:@","];
        NSArray *choiceArray = [NSArray arrayWithArray:[array objectsAtIndexes:choicesIndexSet]];
        [wordIdArray addObject:array[0]];
        [englishArray addObject:array[1]];
//        [japaneseArray addObject:array[2]];
        [choicesArrayArray addObject:choiceArray];
        [answerIndexArray addObject:[NSNumber numberWithInt:[array[6] intValue]]];
        
        [scanner scanCharactersFromSet:chSet intoString:NULL];
    }
    //Dictionaryに各Arrayを格納。
    return [[NSDictionary alloc] initWithObjects:@[[wordIdArray objectsAtIndexes:categoryIndexSet],[englishArray objectsAtIndexes:categoryIndexSet],[choicesArrayArray objectsAtIndexes:categoryIndexSet],[answerIndexArray objectsAtIndexes:categoryIndexSet]] forKeys:@[@"wordId",@"english",@"choicesArray",@"answerIndex"]];
    
}

-(void)playSound:(NSString *)fileName
{
//    NSLog(@"playSound \"%@\"", fileName);
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3",fileName] ofType:nil];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) NSLog(@"error. could not pronounce %@", fileName);
        [_audio play];
    } else {
//        NSLog(@"path is nil. Could not pronounce %@", fileName);
    }
}
@end
