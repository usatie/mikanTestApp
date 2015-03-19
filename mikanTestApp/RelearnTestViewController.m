//
//  RelearnTestViewController.m
//  
//
//  Created by Shun Usami on 2015/03/17.
//
//

#import "RelearnTestViewController.h"

@interface RelearnTestViewController ()

@end

@implementation RelearnTestViewController
- (void)viewDidLoad {
    self.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Test Delegate Methods
- (void)finishDelegate{
    [DBHandler insertTestResult:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:0];
    [[NSUserDefaults standardUserDefaults] setObject:self.testWordsDic forKey:@"testWordsDic"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self performSegueWithIdentifier:@"segueToResult" sender:self];
}

- (void)testCancelDelegate {
    DLog(@"test was cancelled");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    NSString *category = [[NSUserDefaults standardUserDefaults] objectForKey:@"category"];
    return [DBHandler getRelearnWords:category limit:10 remembered:YES hasTested:YES];
}

//- (NSDictionary *)getTestWordsDictionaryWithFileName:(NSString *)fileName
//{
//    NSString *csvFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"csv"];
//    NSData *csvData = [NSData dataWithContentsOfFile:csvFile];
//    NSString *csv = [[NSString alloc] initWithData:csvData encoding:NSUTF8StringEncoding];
//    NSScanner *scanner = [NSScanner scannerWithString:csv];
//    
//    NSCharacterSet *chSet = [NSCharacterSet newlineCharacterSet];
//    NSString *line;
//    NSMutableArray *wordIdArray = [[NSMutableArray alloc] init];
//    NSMutableArray *englishArray = [[NSMutableArray alloc] init];
//    NSMutableArray *choicesArrayArray = [[NSMutableArray alloc] init];
//    NSMutableArray *answerIndexArray = [[NSMutableArray alloc] init];
//    NSIndexSet *categoryIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
//    NSIndexSet *choicesIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 4)];
//    
//    //csvから読み込み、各Arrayに一旦格納
//    while (![scanner isAtEnd]) {
//        [scanner scanUpToCharactersFromSet:chSet intoString:&line];
//        NSArray *array = [line componentsSeparatedByString:@","];
//        NSArray *choiceArray = [NSArray arrayWithArray:[array objectsAtIndexes:choicesIndexSet]];
//        [wordIdArray addObject:array[0]];
//        [englishArray addObject:array[1]];
//        [choicesArrayArray addObject:choiceArray];
//        [answerIndexArray addObject:[NSNumber numberWithInt:[array[6] intValue]]];
//        
//        [scanner scanCharactersFromSet:chSet intoString:NULL];
//    }
//    //Dictionaryに各Arrayを格納。
//    return [[NSDictionary alloc] initWithObjects:@[[wordIdArray objectsAtIndexes:categoryIndexSet],[englishArray objectsAtIndexes:categoryIndexSet],[choicesArrayArray objectsAtIndexes:categoryIndexSet],[answerIndexArray objectsAtIndexes:categoryIndexSet]] forKeys:@[@"wordId",@"english",@"choicesArray",@"answerIndex"]];
//    
//}

@end
