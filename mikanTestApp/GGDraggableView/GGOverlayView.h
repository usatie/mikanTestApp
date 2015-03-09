//
//  GGOverlayView.h
//  TinderLikeAnimations2
//
//  Created by Shun Usami on 2014/05/21.
//  Copyright (c) 2014年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GGOverlayViewMode) {
    GGOverlayViewModeLeft,
    GGOverlayViewModeRight
};

@interface GGOverlayView : UIView
@property (nonatomic) GGOverlayViewMode mode;
@property int i;
@end
