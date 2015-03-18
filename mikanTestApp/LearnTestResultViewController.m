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

@interface LearnTestResultViewController ()

@end

@implementation LearnTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"%@",self.tableView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor ];
    cell.englishLabel.text = @"japanese";
    cell.japaneseLabel.text = @"english";
    
    
    cell.evaluationImageView.image = [UIImage imageNamed:@"bad.png"];
    cell.evaluationImageView.contentMode = UIViewContentModeScaleAspectFit;

    if(YES) {
        cell.archiveImageView.image = [UIImage imageNamed:@"checkOn.png"];
        cell.hasChecked = 1;
    } else {
        cell.archiveImageView.image = [UIImage imageNamed:@"checkOff.png"];
        cell.hasChecked = 0;
    }
    cell.archiveImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if(NO) {
        [cell.archiveButton setImage:nil forState:UIControlStateDisabled];
        cell.archiveButton.enabled = NO;
    }
    
    UIColor *color = [UIColor blackColor];
    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
    cell.archiveButton.backgroundColor =alphaColor;

    return cell;
}
#pragma mark Button Actions
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end

//
//#define HEIGHT_OF_ALL_CELLS 550
//
//@interface LearnTestResultViewController ()
//{
//    NSArray *testResultArray;
//    NSArray *thinkingTimeResultArray;
//    int numberOfWrongAnswers;
//    NSString* category;
//    int correctCount;
//    int testResultImageHeight;
//}
//
//@end
//
//
//@implementation LearnTestResultViewController
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    category = @"TOEIC";
//    // Do any additional setup after loading the view.
//    DLog(@"rowHeight = %f",self.tableView.rowHeight);
//    testResultImageHeight = 460;
//    if(self.view.frame.size.height > 480) testResultImageHeight = 533;
//    [self loadUserDefaults];
//    _wrongAnswers = [[NSUserDefaults standardUserDefaults] objectForKey:@"testWordsDic"];
//    [self makeNavigationBar];
//    _util = [[UserUtil alloc] init];
//    numberOfWrongAnswers = 10;//(int)_wrongAnswers.count;
//    [self layoutTable];
//    [self layoutLabel];
////    [self setMedal];
////    [self updateCurrentNumber];
//    
//
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    UINib *nib = [UINib nibWithNibName:@"CustomTableViewCell" bundle:nil];
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
//    [self.searchDisplayController.searchResultsTableView registerNib:nib forCellReuseIdentifier:@"Cell"];
//}
//
//-(void)loadUserDefaults
//{
//    int maxRank;
//    if([category  isEqual: @"TOEFL"]){
//        maxRank = 30;
//    }else if([category isEqual:@"GRE"]){
//        maxRank = 15;
//    }else if([category isEqual:@"CENTER"]){
//        maxRank = 5;
//    }else{
//        maxRank = 25;
//    }
//}
//
//-(void)hoge:(UIBarButtonItem*)b{
//    DLog(@"ボタンを押されましたね");
//}
//
//-(void)layoutTable
//{
//    int cellHeight = 55;
//    _tableView.rowHeight = cellHeight;
//    UIImage *Image = [UIImage imageNamed:[NSString stringWithFormat:@"white_bg.png"]];
//    UIImageView *ImageView = [[UIImageView alloc] initWithImage:Image];
//    ImageView.frame = CGRectMake(0,0, 320, 568);
//    [_tableView addSubview:ImageView];
//    [_tableView sendSubviewToBack:ImageView];
//    DLog(@"number = %d, height = %d",numberOfWrongAnswers,cellHeight);
//    
//    
//    _tableView.frame = CGRectMake(0, testResultImageHeight, 320, cellHeight*numberOfWrongAnswers);
//    _scrollView.contentSize = CGSizeMake(320, testResultImageHeight + HEIGHT_OF_ALL_CELLS);
////    UILabel *carrot = [[UILabel alloc] initWithFrame:CGRectMake(100, lineChart.frame.origin.y+120,200, 30)];
////    UILabel *malibu = [[UILabel alloc] initWithFrame:CGRectMake(100, lineChart.frame.origin.y+140, 200, 30)];
////    UILabel *riptide = [[UILabel alloc] initWithFrame:CGRectMake(100, lineChart.frame.origin.y+160, 200, 30)];
////    UILabel *turquoise = [[UILabel alloc] initWithFrame:CGRectMake(100, lineChart.frame.origin.y+180, 200, 30)];
////    carrot.text = @"All";
////    malibu.text = @"Good + Great + Excellent";
////    riptide.text = @"Great + Excellent";
////    turquoise.text = @"Excellent";
////    carrot.textAlignment = NSTextAlignmentCenter;
////    malibu.textAlignment = NSTextAlignmentCenter;
////    riptide.textAlignment = NSTextAlignmentCenter;
////    turquoise.textAlignment = NSTextAlignmentCenter;
////    carrot.textColor = [UIColor carrotColor];
////    malibu.textColor = [UIColor malibuColor];
////    riptide.textColor = [UIColor riptideColor];
////    turquoise.textColor = [UIColor turquoiseColor];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Table Viewの行数を返す
//    DLog(@"numberOfRow in section = %d",numberOfWrongAnswers);
//    return 10;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [CustomTableViewCell rowHeight];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DLog(@"cellForRowAtIndexPath");
//    static NSString *CellIdentifier = @"Cell";
//    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    cell.backgroundColor = [UIColor clearColor ];
//    cell.englishLabel.text = _wrongAnswers[@"english"][indexPath.row];//_wrongAnswers[indexPath.row][@"english"];
//    cell.japaneseLabel.text = _wrongAnswers[@"english"][indexPath.row];
//    
//    
////    cell.evaluationImageView.image = [UIImage imageNamed:_wrongAnswers[indexPath.row][@"testResult"]];
//    cell.evaluationImageView.contentMode = UIViewContentModeScaleAspectFit;
//    
////    int indexNumber = [_wrongAnswers[@"index"][indexPath.row] intValue];
//    NSDictionary *hasRememberedDic = [DBHandler getHasRememberedDic:category];
//    if([[hasRememberedDic objectForKey:@"hasRemembered"][indexPath.row] boolValue]) {//[indexNumber-1] boolValue]) {
//        cell.archiveImageView.image = [UIImage imageNamed:@"checkOn.png"];
//        cell.hasChecked = 1;
//    } else {
//        cell.archiveImageView.image = [UIImage imageNamed:@"checkOff.png"];
//        cell.hasChecked = 0;
//    }
//    cell.archiveImageView.contentMode = UIViewContentModeScaleAspectFit;
//    
//    if([hasRememberedDic[@"testResult"][indexPath.row] intValue] < 8) {//[indexNumber-1] intValue] < 8) {
//        cell.archiveButton.enabled = NO;
//    }
//    
//    UIColor *color = [UIColor blackColor];
//    UIColor *alphaColor = [color colorWithAlphaComponent:0.0];
//    cell.archiveButton.backgroundColor =alphaColor;
//    return cell;
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DLog(@"%d番目の行が選択されたよ",(int)indexPath.row+1);
//    BOOL shouldPlaySound = YES;//[[NSUserDefaults standardUserDefaults] boolForKey:UD_KEY_SOUND];
////    [_util playSound:_wrongAnswers[@"english"][indexPath.row] playSoundFlag:shouldPlaySound];
//}
//
//-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
//    DLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
//}
//
//-(void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
//    DLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
//}
//
//-(void)userClickedOnBarCharIndex:(NSInteger)barIndex{
//}
//
//-(void)layoutLabel
//{
//    if (correctCount == 0){
//        _testResult0ImageView.hidden = NO;
//    } else if (correctCount == 1) {
//        _testResult1ImageView.hidden = NO;
//    } else if (correctCount == 2) {
//        _testResult2ImageView.hidden = NO;
//    } else if (correctCount == 3) {
//        _testResult3ImageView.hidden = NO;
//    } else if (correctCount == 4) {
//        _testResult4ImageView.hidden = NO;
//    } else if (correctCount == 5) {
//        _testResult5ImageView.hidden = NO;
//    } else if (correctCount == 6) {
//        _testResult6ImageView.hidden = NO;
//    } else if (correctCount == 7) {
//        _testResult7ImageView.hidden = NO;
//    } else if (correctCount == 8) {
//        _testResult8ImageView.hidden = NO;
//    } else if (correctCount == 9) {
//        _testResult9ImageView.hidden = NO;
//    } else {
//        _testResult10ImageView.hidden = NO;
//    }
//    
////    NSArray* adviceLabelArray = [AppConsts adviceArray];
////    NSMutableString *adviceText = [NSMutableString stringWithString:[userDefaults stringForKey:UD_KEY_NICKNAME]];
////    [adviceText appendString:adviceLabelArray[correctCount]];
//    _adviceLabel.text = @"天才だな！";//adviceText;
//    
//    _continuousNumberView.layer.borderWidth = 1.0f;
//    _continuousNumberView.layer.borderColor = [[UIColor colorWithRed: (223.0)/255.0 green: (53.0)/255.0 blue: (53.0)/255.0 alpha: 1.0] CGColor];
//    _continuousNumberView.backgroundColor = [UIColor colorWithRed: (249.0)/255.0 green: (249.0)/255.0 blue: (249.0)/255.0 alpha: 1.0];
//    _continuousNumberLabel.text = [NSString stringWithFormat:@"%d問連続正解中！",_continuousCorrectAnswerCount];
//    _continuousNumberLabel.textAlignment = NSTextAlignmentRight;
//    _continuousNumberLabel.textColor = [UIColor colorWithRed: (223.0)/255.0 green: (53.0)/255.0 blue: (53.0)/255.0 alpha: 1.0];
//    _continuousNumberView.layer.cornerRadius = 10.0f;
//}
//
//- (void)segueToHome
//{
//    for (int i = 0; i<10; i++) {
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
//        CustomTableViewCell *cell = (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
//        DLog(@"%@ hasChecked = %d",cell.englishLabel.text,cell.hasChecked);
//        DLog(@"id = %@",_wrongAnswers);
//    }
//    
////    [[SlideNavigationController sharedInstance] popToViewController:[[SlideNavigationController sharedInstance].viewControllers objectAtIndex:0] animated:YES];
//}
//
//-(void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    
//    [self.view layoutIfNeeded];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (IBAction)next:(id)sender {
//    for (int i = 0; i<10; i++) {
//        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
//        CustomTableViewCell *cell = (CustomTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
////        NSNumber *idNumber = [NSNumber numberWithInt:[_wrongAnswers[i][@"id"] intValue]];
////        [DBhandler setHasRemembered:idNumber hasRemembered:cell.hasChecked];
//    }
//    
////    [[SlideNavigationController sharedInstance] popToViewController:[[SlideNavigationController sharedInstance].viewControllers objectAtIndex:0] animated:NO];
//    
//}
//
//- (IBAction)test:(id)sender {
//    [self performSegueWithIdentifier:@"testAgain" sender:self];
//}
//
////-(void)setMedal{
////    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
////    [ud setInteger:0 forKey:@"beginIndex"];
////    int rankSectionNumber = ((int)[ud integerForKey:UD_KEY_RANK]-1)*10 + (int)[ud integerForKey:UD_KEY_SECTION];
////    NSString *sectionString = [NSString stringWithFormat:@"%d",rankSectionNumber];
////    DLog(@"%d",rankSectionNumber);
////    
////    _medalDataDic = [[ud objectForKey:UD_MEDAL_DATA] mutableCopy];
////    if (!_medalDataDic) {
////        _medalDataDic = [[NSMutableDictionary alloc]init];
////    }
////    DLog(@"setCategory = %@",_medalDataDic);
////    
////    NSDictionary *tmpDic = _medalDataDic[category];
////    _medalDataForCategoryDic = [tmpDic mutableCopy];
////    DLog(@"aaa = %@", tmpDic);
////    if (!_medalDataForCategoryDic) {
////        _medalDataForCategoryDic = [[NSMutableDictionary alloc]init];
////    }
////    DLog(@"aaaaaaaaa = %@", _medalDataForCategoryDic);
////    
////    if(correctCount <= TEST_RESULT_ZERO_STAR){
////        [_medalDataForCategoryDic setObject:@"fail" forKey:sectionString];
////    }else if (correctCount <= TEST_RESULT_ONE_STAR){
////        [_medalDataForCategoryDic setObject:@"blonz" forKey:sectionString];
////    }else if (correctCount <= TEST_RESULT_TWO_STARS){
////        [_medalDataForCategoryDic setObject:@"silver" forKey:sectionString];
////    }else {
////        [_medalDataForCategoryDic setObject:@"gold" forKey:sectionString];
////    }
////    
////    DLog(@"_medalDataDic = %@",_medalDataForCategoryDic);
////    
////    [_medalDataDic setObject:_medalDataForCategoryDic forKey:category];
////    [ud setObject:_medalDataDic forKey:UD_MEDAL_DATA];
////    
////}
//
////-(void)updateCurrentNumber
////{
////    int numberOfRanks;
////    if([category  isEqual: @"TOEFL"]){
////        numberOfRanks = 30;
////    }else if([category isEqual:@"GRE"]){
////        numberOfRanks = 15;
////    }else if([category isEqual:@"CENTER"]){
////        numberOfRanks = 5;
////    }else{
////        numberOfRanks = 25;
////    }
////    
////    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
////    
////    if(_currentSectionId == 10 && _currentRankId == numberOfRanks){
////        [ud setBool:YES forKey:UD_KEY_SET_FLAG];
////    }
////}
//
//-(void)makeNavigationBar
//{
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.navigationItem.title = @"テスト結果";
//    
//    // バーボタンに表示するImageViewを作成します。
//    UIImage *anImage = [UIImage imageNamed:@"homeButton@2x.png"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:anImage];
//    imageView.frame = CGRectMake(-10, 0, 44, 44);
//    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    [button addTarget:self action:@selector(segueToHome) forControlEvents:UIControlEventTouchUpInside];
//    [button addSubview:imageView];
//    
//    // ボタンを上記で作成したViewを用いて作成します。
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] init];
//    [leftButton setCustomView:button];
//    // ナビゲーションバーに追加します。
//    self.navigationItem.leftBarButtonItem = leftButton;
//}
//
//@end
