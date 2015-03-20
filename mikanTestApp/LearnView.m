//
//  LearnView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/20.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "LearnView.h"

@implementation LearnView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"LearnView" bundle:[NSBundle mainBundle]];
        NSArray *array = [nib instantiateWithOwner:self options:nil];
        self = [array objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

- (IBAction)cancelButtonPushed:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelButtonPushedDelegate)]) {
        [_delegate cancelButtonPushedDelegate];
    }
}
@end
