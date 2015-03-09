//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnViewController.h"

@interface LearnViewController (){
    int learnWordsIndex;
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
    NSLog(@"learnCategoryID = %d",_learnCategoryId);
    _audio = [[AVAudioPlayer alloc] init];
    [self playSound:@"sound_correct"];
    _learnWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
    NSLog(@"learnWordsDic = %@",_learnWordsDic);
    [self generateCardView];
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
    NSIndexSet *categoryIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange((_learnCategoryId-1)*NUMBER_OF_WORDS_PER_CATEGORY, NUMBER_OF_WORDS_PER_CATEGORY)];
    
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

#pragma mark ButtonAction
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextWordsButtonPushed:(id)sender {
    learnWordsIndex += NUMBER_OF_WORDS_PER_LEAARNING;
    [self generateCardView];
    self.nextWordsButton.hidden = YES;
}


#pragma mark GGDraggableView Delegate Method
- (void)displayNextCardDelegate:(BOOL)hasRememberd sender:(GGDraggableView *)sender{
    NSLog(@"displayNextCardDelegate tag = %d",(int)sender.tag);
    if (hasRememberd) {
        [sender removeFromSuperview];
    } else {
        [self.view sendSubviewToBack:sender];
    }
    if (self.view.subviews.count == 4) {
        self.nextWordsButton.hidden = NO;
    }
}

#pragma mark Word Related Method
- (void)generateCardView{
    for (int i=learnWordsIndex; i < learnWordsIndex+NUMBER_OF_WORDS_PER_LEAARNING; i++) {
        GGDraggableView *cardView;
        cardView = [[GGDraggableView alloc]initWithFrame:CGRectMake(15, 88, 290, 340)];
        cardView.numberLabel.text = @"hello";
        cardView.panGestureRecognizer.enabled = YES;
        cardView.tag = i+1;
        cardView.delegate = self;
        [cardView setParameter:_learnWordsDic[@"english"][i]
                      japanese:_learnWordsDic[@"japanese"][i]
                        number:[NSString stringWithFormat:@"%@",_learnWordsDic[@"wordId"][i]]
            japaneseHiddenFlug:YES
                     wordIndex:[_learnWordsDic[@"wordId"][i] intValue]];
        cardView.sectionLabel.text = [NSString stringWithFormat:@"learnCategoryId %d",_learnCategoryId];
        [self.view addSubview:cardView];
        [self.view sendSubviewToBack:cardView];
    }
}

#pragma mark Sound Related Method
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