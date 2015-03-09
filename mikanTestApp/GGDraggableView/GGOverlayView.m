//
//  GGOverlayView.m
//  TinderLikeAnimations2
//
//  Created by Shun Usami on 2014/05/21.
//  Copyright (c) 2014年 ShunUsami. All rights reserved.
//

#import "GGOverlayView.h"


@interface GGOverlayView ()
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation GGOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"?"]];
    [self addSubview:self.imageView];
    
    return self;
}

- (void)setMode:(GGOverlayViewMode)mode
{
    if (_mode == mode) return;
    
    _mode = mode;
    if (mode == GGOverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"?"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"thumbs_up_300x300"];
    }
        
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(45, 30, 200, 200);
}

@end
