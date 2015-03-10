//
//  DraggableCardOverlayView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/10.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CardOverlayViewMode) {
    CardOverlayViewModeLeft,
    CardOverlayViewModeRight
};

@interface DraggableCardOverlayView : UIView

@property (nonatomic) CardOverlayViewMode mode;
@property int i;

@end