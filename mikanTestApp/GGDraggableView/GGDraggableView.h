//
//  GGDraggableView.h
//  TinderLikeAnimations2
//
//  Created by Shun Usami on 2014/05/21.
//  Copyright (c) 2014年 ShunUsami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGOverlayView.h"

@protocol GGDraggableViewDelegate;

@interface GGDraggableView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) id<GGDraggableViewDelegate> delegate;//delegate用
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) CGPoint originalPoint;
@property (nonatomic, strong) GGOverlayView *overlayView;
@property int i;
@property int wordIndex;
@property int viewIndex;
@property (nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic) IBOutlet UILabel *japaneseLabel;
@property (nonatomic) IBOutlet UILabel *englishLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *swipeImageView;


- (void)setParameter:(NSString*)english
            japanese:(NSString*)japanese
              number:(NSString*)number
  japaneseHiddenFlug:(BOOL)japaneseHiddenFlug
           wordIndex:(int)wordIndex;
- (void)showView;
- (void)setNumber:(NSString*)number;
- (void)resetViewPositionAndTransformations;


@end

@protocol GGDraggableViewDelegate <NSObject>
@optional
- (void)displayNextCardDelegate:(BOOL)hasRememberd sender:(GGDraggableView *)sender;
@end

