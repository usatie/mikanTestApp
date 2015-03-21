//
//  TestViewController.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/07.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnViewController_deprecated.h"
#import "TestViewController.h"
@interface LearnViewController_deprecated (){
    int learnWordsIndex;
    int cardCount;
    
    BOOL shouldLearnAgain;
    BOOL isTimerValid;
    NSTimer *timer;
}

@end

@implementation LearnViewController_deprecated
#pragma mark Definition

#define NUMBER_OF_WORDS_PER_LEARNING 5
#define NUMBER_OF_WORDS_PER_CATEGORY 100

#pragma mark ViewController Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *category = [ud objectForKey:@"category"];
    BOOL learnMode = [ud boolForKey:@"learnMode"];
    _learnWordsDic = [DBHandler getRelearnWords:category limit:10 remembered:NO hasTested:learnMode];
    DLog(@"arr %@, learnMode %d learnWordsDic = %@",category,learnMode,_learnWordsDic);
    _audio = [[AVAudioPlayer alloc] init];
    if([_learnWordsDic[@"wordId"] count] > NUMBER_OF_WORDS_PER_LEARNING){
        cardCount = NUMBER_OF_WORDS_PER_LEARNING;
        shouldLearnAgain = YES;
    } else if ([_learnWordsDic[@"wordId"] count] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    } else {
        cardCount = (int)[_learnWordsDic[@"wordId"] count];
    }
    [self generateCardView];
    [self pronounceNextWord];
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"learnToTest"]) {
        TestViewController *vc = segue.destinationViewController;
        vc.tmpDic = _learnWordsDic;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Timer Method
- (void)startTimer
{
    if (isTimerValid) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:(float)3
                                              target:self
                                            selector:@selector(timerAction)
                                            userInfo:nil
                                             repeats:NO];
    isTimerValid = YES;
}

- (void)stopTimer
{
    if (isTimerValid) {
        [timer invalidate];
    }
    isTimerValid = NO;
}

- (void)timerAction
{
    DraggableCardView *cardView = (DraggableCardView *)[self.cardsBaseView.subviews objectAtIndex:self.cardsBaseView.subviews.count-1];
    cardView.japaneseLabel.hidden = NO;
    [self sendCardViewToBack:cardView];
}

- (void)removeCardView:(DraggableCardView *)cardView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         cardView.center = CGPointMake(cardView.originalPoint.x + 250 , cardView.originalPoint.y + 100);
                         cardView.transform = CGAffineTransformMakeRotation(0);}
                     completion:^(BOOL finished){
                         cardView.panGestureRecognizer.enabled = YES;
                         [self startTimer];
                         [self displayNextCardDelegate:YES sender:cardView];
                     }
     ];
    
}

- (void)sendCardViewToBack:(DraggableCardView *)cardView
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         cardView.center = CGPointMake(cardView.originalPoint.x - 250 , cardView.originalPoint.y + 100);
                         cardView.transform = CGAffineTransformMakeRotation(0);}
                     completion:^(BOOL finished){
                         cardView.panGestureRecognizer.enabled = YES;
                         [self startTimer];
                         [self displayNextCardDelegate:NO sender:cardView];
                         [cardView resetViewPositionAndTransformations];
                     }
     ];
}

#pragma mark ButtonAction
- (IBAction)backButtonPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self stopTimer];
    }];
}

- (IBAction)nextWordsButtonPushed:(id)sender {
//    [self generateCardView];
//    [self pronounceNextWord];
//    [self startTimer];
//    self.nextWordsButton.hidden = YES;
    
    //Testにsegueするならこれ
    [self performSegueWithIdentifier:@"learnToTest" sender:self];
}



#pragma mark DraggableView Delegate Method
- (void)displayNextCardDelegate:(BOOL)hasRememberd sender:(DraggableCardView *)sender{
    NSLog(@"displayNextCardDelegate tag = %d",(int)sender.tag);

    //知ってたらremove, 知らなかったらsendSubviewToBack
    if (hasRememberd) {
        learnWordsIndex++;
        [sender removeFromSuperview];
    } else {
        [sender resetViewPositionAndTransformations];
        [self.cardsBaseView sendSubviewToBack:sender];
        
    }
    
    //cardsBaseViewのsubviewsが０だったらfinish
    if (self.cardsBaseView.subviews.count == 0) {
        [self stopTimer];
        [self.nextWordsButton setTitle:[NSString stringWithFormat:@"残り%d単語",NUMBER_OF_WORDS_PER_CATEGORY-learnWordsIndex] forState:UIControlStateNormal];
        //button無しで移行するんだったらこれ
        if(shouldLearnAgain){
            shouldLearnAgain = NO;
            cardCount = (int)[_learnWordsDic[@"wordId"] count];
            [self generateCardView];
            [self pronounceNextWord];
            [self startTimer];
            self.nextWordsButton.hidden = YES;
            return;
        }
        //buttonで移行するんだったらこれ
        [self playSound:@"sound_finish"];
        self.nextWordsButton.hidden = NO;

    } else {
        [self startTimer];
        [self pronounceNextWord];
    }
}

#pragma mark Word Related Method
- (void)generateCardView
{
    DLog(@"generate learnwordsIndex = %d, cardCount = %d",learnWordsIndex,cardCount);
    for (int i=learnWordsIndex; i < cardCount; i++) {
        DraggableCardView *cardView;
        cardView = [[DraggableCardView alloc]initWithFrame:CGRectMake(0, 0, 290, 340)];
        cardView.panGestureRecognizer.enabled = YES;
        cardView.tag = i+1;
        cardView.delegate = self;
        [cardView setParameter:_learnWordsDic[@"english"][i]
                      japanese:_learnWordsDic[@"japanese"][i]
                        number:[NSString stringWithFormat:@"%@",_learnWordsDic[@"wordId"][i]]
            japaneseHiddenFlug:YES
                     wordIndex:[_learnWordsDic[@"wordId"][i] intValue]];
        cardView.sectionLabel.text = @"検証テスト";
        cardView.japaneseLabel.hidden = NO;
        [self.cardsBaseView addSubview:cardView];
        [self.cardsBaseView sendSubviewToBack:cardView];
    }
}

#pragma mark Sound Related Method
- (void)pronounceNextWord{
    DLog(@"pronounce");
    if (self.cardsBaseView.subviews.count!=0) {
        DraggableCardView *nextCardView = (DraggableCardView *)[self.cardsBaseView.subviews objectAtIndex:self.cardsBaseView.subviews.count-1];
        [self playSound:nextCardView.englishLabel.text];
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