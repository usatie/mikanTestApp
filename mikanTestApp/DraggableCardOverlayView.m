//
//  DraggableCardOverlayView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/10.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "DraggableCardOverlayView.h"

@interface DraggableCardOverlayView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DraggableCardOverlayView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipe_left_image"]];
    [self addSubview:self.imageView];
    
    return self;
}

- (void)setMode:(CardOverlayViewMode)mode
{
    if (_mode == mode) return;
    
    _mode = mode;
    if (mode == CardOverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"swipe_left_image"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"swipe_right_image"];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(45, 30, 200, 200);
}

@end
