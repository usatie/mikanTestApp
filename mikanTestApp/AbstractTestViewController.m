//
//  AbstractTestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "AbstractTestViewController.h"
#import "answerButton.h"

@interface AbstractTestViewController (){
//    int testIndex;
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
    _resultsArray = [[NSMutableArray alloc] init];
    _userChoicesArray = [[NSMutableArray alloc] init];
    _answerDurationArray = [[NSMutableArray alloc] init];
    
    _testWordsDic = [self getTestWords];
    
    //Testすべき単語が無かったらすぐに終了
    if ([_testWordsDic[@"wordId"] count]==0) {
        [self cancelButtonPushed];
        return;
    }
    [self initTestView];
    [self initAlertView];
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

- (void)initAlertView{
    _cancelAlertView = [[UIAlertView alloc] initWithTitle:@"再開" message:@"学習をつづけますか？" delegate:self cancelButtonTitle:@"中断する" otherButtonTitles:@"はい", nil];
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

#pragma mark show next word methods
- (void)showAndPlayNextWord
{
    //次の単語を表示
    [self.testView showWordWithIndex:_testIndex];
    //次の単語を発音
    [self playSound:_testWordsDic[@"english"][_testIndex]];
    //indexを次に進める
    _testIndex++;
    //ボタンをenable
    [self.testView enableAllButtons];
    //dateをリセット
    date = [NSDate date];
    [self startTimer];
}

#pragma mark Button Action
- (void)answerButtonPushedDelegate:(BOOL)result choice:(int)choice{
    //Timerをstop
    [self stopTimer];
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
    
    if (_testIndex < [_testWordsDic[@"wordId"] count]){
        [self performSelector:@selector(showAndPlayNextWord) withObject:nil afterDelay:0.3];
        return;
    }
    DLog(@"finish!");
    //timer, AVAudioPlayerをストップ
    [self.audio stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopTimer];
    
    //子クラスで定義されるfinishTest
    [self finishTest];
}

- (void)cancelButtonPushedDelegate{
    //timer, AVAudioPlayerをストップ
    [self.audio stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopTimer];
    
    if (_resultsArray.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        //show AlertView
        [_cancelAlertView show];
    }
}

#pragma mark AlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _cancelAlertView) {
        switch (buttonIndex) {
            case 0:
                [self cancelButtonPushed];
                break;
            default:
                _testIndex--;
                [self showAndPlayNextWord];
                break;
        }
    }
}


#pragma mark Override method
- (void)finishTest
{
    // 継承したクラスで実装する
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)cancelButtonPushed
{
    // 継承したクラスで実装する
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

#pragma mark Timer Override(optional)
- (void)startTimer {
    DLog(@"if you want to add timer, please override this method");
}
- (void)stopTimer {
    DLog(@"if you want to add timer, please override this method");
}
- (void)timerAction {
    DLog(@"if you want to add timer, please override this method");
}

#pragma mark sound (Deprecate)
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
