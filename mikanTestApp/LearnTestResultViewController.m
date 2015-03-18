//
//  LearnTestResultViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/18.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnTestResultViewController.h"
#import "CustomTableViewCell.h"
#import "DBHandler.h"

@interface LearnTestResultViewController (){
    NSDictionary *testedWordsDic;
    NSDictionary *hasRememberedDic;
    NSArray *resultImageNameArray;
}

@end

@implementation LearnTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    testedWordsDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"testWordsDic"];
    hasRememberedDic = [DBHandler getHasRememberedDicWithWordIdArray:testedWordsDic[@"wordId"]];
    resultImageNameArray = @[@"bad.png",@"good.png",@"great.png",@"excellent.png"];
    DLog(@"%@",hasRememberedDic);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"%@",self.tableView);
    DLog(@"%@",hasRememberedDic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    DLog(@"%@",hasRememberedDic);
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    int answerIndex = [testedWordsDic[@"answerIndex"][indexPath.row] intValue];
    int testResultIndex = [hasRememberedDic[@"testResult"][indexPath.row] intValue];
    BOOL hasRemembered = [hasRememberedDic[@"hasRemembered"][indexPath.row] boolValue];
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor ];
    cell.englishLabel.text = testedWordsDic[@"english"][indexPath.row];
    cell.japaneseLabel.text = testedWordsDic[@"choicesArray"][indexPath.row][answerIndex-1];
    
    
    
    cell.evaluationImageView.image = [UIImage imageNamed:resultImageNameArray[testResultIndex]];
    cell.evaluationImageView.contentMode = UIViewContentModeScaleAspectFit;

    if(hasRemembered) {
        cell.archiveImageView.image = [UIImage imageNamed:@"checkOn.png"];
        cell.hasChecked = YES;
    } else {
        cell.archiveImageView.image = [UIImage imageNamed:@"checkOff.png"];
        cell.hasChecked = NO;
    }
    cell.archiveImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(testResultIndex < 1) {
//        [cell.archiveButton setImage:nil forState:UIControlStateDisabled];
        cell.archiveImageView.image = nil;
        cell.hasChecked = NO;
        cell.archiveButton.enabled = NO;
    }
    
    UIColor *color = [UIColor blackColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
    cell.archiveButton.backgroundColor =alphaColor;

    return cell;
}
#pragma mark Button Actions
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *hasrememberedArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<10; i++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            CustomTableViewCell *cell = (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
            [hasrememberedArray addObject:[NSNumber numberWithBool:cell.hasChecked]];
        }
        [DBHandler setHasRememberedWithArray:testedWordsDic[@"wordId"] hasRememberedArray:hasrememberedArray];
    }];
}
@end