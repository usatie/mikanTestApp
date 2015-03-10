//
//  DraggableCardView.h
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/10.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableCardOverlayView.h"

@protocol DraggableCardViewDelegate;

@interface DraggableCardView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<DraggableCardViewDelegate> delegate;//delegate用
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGPoint originalPoint;
@property (nonatomic, strong) DraggableCardOverlayView *overlayView;
@property int i;
@property int wordIndex;
@property int viewIndex;
@property (nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic) IBOutlet UILabel *japaneseLabel;
@property (nonatomic) IBOutlet UILabel *englishLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;


- (void)setParameter:(NSString*)english
            japanese:(NSString*)japanese
              number:(NSString*)number
  japaneseHiddenFlug:(BOOL)japaneseHiddenFlug
           wordIndex:(int)wordIndex;
- (void)resetViewPositionAndTransformations;


@end

@protocol DraggableCardViewDelegate <NSObject>
@optional
- (void)displayNextCardDelegate:(BOOL)hasRememberd sender:(DraggableCardView *)sender;
@end