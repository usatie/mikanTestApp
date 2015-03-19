//
//  AbstractTestViewController.m
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
    
    _testWordsDic = [self getTestWords];
    DLog(@"test = %@",_testWordsDic);
    if ([_testWordsDic[@"wordId"] count]==0) {
        if ([_delegate respondsToSelector:@selector(finishDelegate)]) {
            [_delegate finishDelegate];
        } else {
            DLog(@"no responds to finishDelegate");
        }
        return;
    }
    [self initTestView];
    [self showAndPlayNextWord];
    //これやると速くなるはずなんだけどなあ・・・
    [_audio prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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

- (NSDictionary *)getTestWords
{
    // 継承したクラスで実装する
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return @{};
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
    //DBHandlerに入れるためのもの
    [_userChoicesArray addObject:[NSNumber numberWithInt:choice]];
    [_resultsArray addObject:[NSNumber numberWithBool:result]];
    [_answerDurationArray addObject:[NSNumber numberWithDouble:-[date timeIntervalSinceNow]]];
    
    if (result) {
        [self playSound:@"sound_correct"];
    } else {
        [self playSound:@"sound_incorrect"];
    }
    
    if (testIndex < [_testWordsDic[@"wordId"] count]){
        [self performSelector:@selector(showAndPlayNextWord) withObject:nil afterDelay:0.3];
        return;
    }
    DLog(@"finish!");
    if ([_delegate respondsToSelector:@selector(finishDelegate)]) {
        [_delegate finishDelegate];
    } else {
        DLog(@"no responds to finishDelegate");
    }
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
