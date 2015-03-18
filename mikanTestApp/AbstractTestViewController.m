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
    BOOL shouldPlaySound;
    
    NSDate *date;
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
    //これやると速くなるはずなんだけどなあ・・・
    [_audio prepareToPlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark initialization
- (void)initTestView{
    self.testView = [[TestView alloc] initWithFrame:self.view.frame];
    self.testView.delegate = self;
    self.testView.testWordsDic = _testWordsDic;
    [self.view addSubview:self.testView];
}

- (void)loadUserDefaults
{
    shouldPlaySound = YES;
}

#pragma mark show methods
- (void)showAndPlayNextWord
{
    //次の単語を表示
    [self.testView showWordWithIndex:testIndex];
    //次の単語を発音
    [self playSound:_testWordsDic[@"english"][testIndex]];
    //indexを次に進める
    testIndex++;
    //ボタンをenable
    [self.testView enableAllButtons];
    //dateをリセット
    date = [NSDate date];
}

#pragma mark Button Action
- (void)answerButtonPushedDelegate:(BOOL)result choice:(int)choice{
    //次の単語が表示されるまではボタンをdisable
    [self.testView disableAllButtons];
    //
    [_userChoicesArray addObject:[NSNumber numberWithInt:choice]];
    [_resultsArray addObject:[NSNumber numberWithBool:result]];
    [_answerDurationArray addObject:[NSNumber numberWithDouble:-[date timeIntervalSinceNow]]];
    
    if (result) {
        [self playSound:@"sound_correct"];
    } else {
        [self playSound:@"sound_incorrect"];
    }
    
    if (testIndex < 10){
        [self performSelector:@selector(showAndPlayNextWord) withObject:nil afterDelay:0.3];
        return;
    }
    DLog(@"finish!");
    if ([_delegate respondsToSelector:@selector(finishDelegateWithBlock:)]) {
        [_delegate finishDelegateWithBlock:^{
            [DBHandler insertTestResult:_testWordsDic[@"wordId"] resultArray:_resultsArray userChoiceArray:_userChoicesArray answeringTimeArray:_answerDurationArray testType:0 relearnFlag:0];
        }];
    }
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
