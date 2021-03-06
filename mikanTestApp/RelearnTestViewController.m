//
//  RelearnTestViewController.m
//  
//
//  Created by Shun Usami on 2015/03/17.
//
//

#import "RelearnTestViewController.h"
#import "RelearnTestResultViewController.h"

@interface RelearnTestViewController () 

@end

@implementation RelearnTestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Test Override Methods 
- (void)initAlertView{
    self.cancelAlertView = [[UIAlertView alloc] initWithTitle:@"再開" message:@"学習をつづけますか？" delegate:self cancelButtonTitle:@"終了して結果を表示" otherButtonTitles:@"つづける", nil];
}

- (void)finishTest {
    [DBHandler insertTestResultWithArray:self.testWordsDic[@"wordId"] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:1];
    [self performSegueWithIdentifier:@"segueToResult" sender:self];
}

- (void)cancelButtonPushed {
    DLog(@"test was cancelled");
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.resultsArray count])];
    [DBHandler insertTestResultWithArray:[self.testWordsDic[@"wordId"] objectsAtIndexes:indexSet] resultArray:self.resultsArray userChoiceArray:self.userChoicesArray answeringTimeArray:self.answerDurationArray testType:0 relearnFlag:1];
    [self performSegueWithIdentifier:@"segueToResult" sender:self];
}


#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TestResultViewController にtestWordsDicを引き渡し
    if ([segue.identifier isEqualToString:@"segueToResult"]) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.resultsArray count])];
        RelearnTestResultViewController *vc = segue.destinationViewController;
        vc.testedWordsDic = [self getSmallDictionary:self.testWordsDic indexSet:indexSet];
    }
}

#pragma mark Temporary methods
- (NSDictionary *)getTestWords
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    if ([ud boolForKey:@"totalRelearnMode"]) {
        return [DBHandler getRelearnWords:category limit:250 remembered:YES hasTested:YES];
    } else{
        return [DBHandler getRelearnWords:category limit:10 remembered:YES hasTested:YES];
    }
}

- (NSDictionary *)getSmallDictionary:(NSDictionary *)dic indexSet:(NSIndexSet *)indexSet
{
    NSMutableDictionary *smallDic = [[NSMutableDictionary alloc] init];
    
    for (id key in dic) {
        [smallDic setObject:[[dic objectForKey:key] objectsAtIndexes:indexSet] forKey:key];
    }
    
    return smallDic;
}
@end
