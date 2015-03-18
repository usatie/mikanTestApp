//
//  TestView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/17.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "TestView.h"

@implementation TestView
#pragma mark Initialization
//initialized in Codes by using this method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"TestView" bundle:[NSBundle mainBundle]];
        NSArray *array = [nib instantiateWithOwner:self options:nil];
        self = [array objectAtIndex:0];
        self.frame = frame;
        _answerButton1.tag = 1;
        _answerButton2.tag = 2;
        _answerButton3.tag = 3;
        _answerButton4.tag = 4;
    }
    return self;
}

- (void)enableAllButtons{
    _answerButton1.enabled = YES;
    _answerButton2.enabled = YES;
    _answerButton3.enabled = YES;
    _answerButton4.enabled = YES;
}
- (void)disableAllButtons{
    _answerButton1.enabled = NO;
    _answerButton2.enabled = NO;
    _answerButton3.enabled = NO;
    _answerButton4.enabled = NO;
}

- (void)showWordWithIndex:(int)index
{
    //[1...4]をランダムに並び替える
    NSMutableArray *randArray = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4]];
    for (int i = 0; i<4; i++) {
        [randArray exchangeObjectAtIndex:arc4random()%4 withObjectAtIndex:arc4random()%4];
    }
    //Button にrandomに選択肢を表示。正解の選択肢のタグを保存。
    for (int i = 0; i<4; i++) {
        int rand = [randArray[i] intValue];
        answerButton *btn = (answerButton *)[self viewWithTag:i+1];
        [btn setTitle:_testWordsDic[@"choicesArray"][index][rand-1] forState:UIControlStateNormal];
        btn.choiceNumTag = rand;
    }
    
    //answerIndexを設定
    self.answerButtonTag = [_testWordsDic[@"answerIndex"][index] intValue];
    
    //Englishを表示
    self.englishLabel.text = _testWordsDic[@"english"][index];
}
- (IBAction)answerButtonPushed:(id)sender {
    answerButton *btn = (answerButton *)sender;
    BOOL result = _answerButtonTag==btn.choiceNumTag ? 1:0;
    if ([_delegate respondsToSelector:@selector(answerButtonPushedDelegate:choice:)]) {
        [_delegate answerButtonPushedDelegate:result choice:btn.choiceNumTag];
    }
}
@end
