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

#define NUMBER_OF_WORDS_PER_LEAARNING 5
#define NUMBER_OF_WORDS_PER_CATEGORY 100

#pragma mark ViewController Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _audio = [[AVAudioPlayer alloc] init];
    _learnWordsDic = [self getTestWordsDictionaryWithFileName:@"sample_test"];
    
    [self generateCardView];
    
    //Remove comment out when sound files are loaded
    //[self pronounceNextWord];
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
    
    //csvから読み込み、各Arrayに一旦格納
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
        NSArray *array = [line componentsSeparatedByString:@","];
        [wordIdArray addObject:array[0]];
        [englishArray addObject:array[1]];
        [japaneseArray addObject:array[2]];
        [scanner scanCharactersFromSet:chSet intoString:NULL];
    }
    //Dictionaryに各Arrayを格納。
    return [[NSDictionary alloc] initWithObjects:@[[wordIdArray objectsAtIndexes:categoryIndexSet],[englishArray objectsAtIndexes:categoryIndexSet],[japaneseArray objectsAtIndexes:categoryIndexSet]] forKeys:@[@"wordId",@"english",@"japanese"]];

}

#pragma mark ButtonAction
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextWordsButtonPushed:(id)sender {
    [self generateCardView];
    [self pronounceNextWord];
    self.nextWordsButton.hidden = YES;
}


#pragma mark GGDraggableView Delegate Method
- (void)displayNextCardDelegate:(BOOL)hasRememberd sender:(GGDraggableView *)sender{
    [self playSound:@"sound_correct"];
    NSLog(@"displayNextCardDelegate tag = %d",(int)sender.tag);
    if (hasRememberd) {
        [sender removeFromSuperview];
    } else {
        [self.view sendSubviewToBack:sender];
    }
    if (self.view.subviews.count == 4) {
        learnWordsIndex += NUMBER_OF_WORDS_PER_LEAARNING;
        [self.nextWordsButton setTitle:[NSString stringWithFormat:@"残り%d単語",NUMBER_OF_WORDS_PER_CATEGORY-learnWordsIndex] forState:UIControlStateNormal];
        self.nextWordsButton.hidden = NO;
    } else {
        //Remove comment out when sound files are loaded
        //[self pronounceNextWord];
    }
}

#pragma mark Word Related Method
- (void)generateCardView
{
    for (int i=learnWordsIndex; i < learnWordsIndex+NUMBER_OF_WORDS_PER_LEAARNING; i++) {
        GGDraggableView *cardView;
        cardView = [[GGDraggableView alloc]initWithFrame:CGRectMake(15, 88, 290, 340)];
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
- (void)pronounceNextWord{
    GGDraggableView *nextCardView = (GGDraggableView *)[self.view.subviews objectAtIndex:self.view.subviews.count-5];
    [self playSound:nextCardView.englishLabel.text];
}

-(void)playSound:(NSString *)fileName
{
    NSLog(@"playSound \"%@\"", fileName);
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.mp3",fileName] ofType:nil];
    if (path) {
        NSURL *url = [NSURL fileURLWithPath:path];
        NSError *error;
        _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (error) NSLog(@"error. could not pronounce %@", fileName);
        [_audio play];
    } else {
        NSLog(@"path is nil. Could not pronounce %@", fileName);
    }
}

@end