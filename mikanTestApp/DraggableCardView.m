//
//  DraggableCardView.m
//  mikanTestApp
//
//  Created by Shun Usami on 2015/03/10.
//  Copyright (c) 2015年 ShunUsami. All rights reserved.
//

#import "DraggableCardView.h"
@interface DraggableCardView (){
    int adjuster;
}
@property (nonatomic) CGPoint centerPoint;
@end

@implementation DraggableCardView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *nibName = NSStringFromClass([self class]);
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        self.frame = frame;
        
        [self initLabel];
    }
    return self;
}

- (void)initLabel
{
    _englishLabel.font = [UIFont fontWithName:@"Times New Roman" size:44];
    _japaneseLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
    _numberLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer.delegate = self;
    
    
    _overlayView = [[DraggableCardOverlayView alloc] initWithFrame:self.bounds];
    _overlayView.alpha = 0;
    [self addSubview:_overlayView];
    _originalPoint = self.center;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _japaneseLabel.hidden = NO;
    if ([_delegate respondsToSelector:@selector(cardViewTouchedDelegate:)]) {
        [_delegate cardViewTouchedDelegate:self];
    }
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            adjuster = [gestureRecognizer locationOfTouch:0 inView:self].y>self.frame.size.height/2? 1:-1;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance/320, 1);
            CGFloat rotationAngle = (CGFloat) (-2*M_PI/32 * rotationStrength * adjuster);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength)/4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaletransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaletransform;
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            
            [self updateOverlay:xDistance];
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if (xDistance > 60) {
                //Write delegate method when swipe to the right
                if ([_delegate respondsToSelector:@selector(cardViewSwipedDelegate:cardView:)]) {
                    [_delegate cardViewSwipedDelegate:YES cardView:self];
                } else {NSLog(@"no responds to remember");}
                
            }
            else if (xDistance < -60){
                //Write delegate method shen swipe to the left
                if ([_delegate respondsToSelector:@selector(cardViewSwipedDelegate:cardView:)]) {
                    [_delegate cardViewSwipedDelegate:NO cardView:self];
                } else {NSLog(@"no responds to onemore");}
            }
            else [self resetViewPositionAndTransformations];
            break;
        }
        default:break;
    }
}

- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = CardOverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode =
        CardOverlayViewModeLeft;
    }
    CGFloat overlayStrength = MAX(fabsf(distance)/500, 0.2);
    self.overlayView.alpha = overlayStrength;
    if (distance > 0) {
        self.overlayView.backgroundColor = [UIColor blueColor];
    } else if (distance <0) {
        self.overlayView.backgroundColor = [UIColor orangeColor];
    } else {
        self.overlayView.backgroundColor = [UIColor whiteColor];
    }
    
    
}

- (void)setParameter:(NSString*)english
            japanese:(NSString*)japanese
              number:(NSString*)number
  japaneseHiddenFlug:(BOOL)japaneseHiddenFlug
{
    _englishLabel.text = english;
    _japaneseLabel.text = japanese;
    _numberLabel.text = number;
    _japaneseLabel.hidden = japaneseHiddenFlug;
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2 animations:^{
        self.center = self.originalPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        self.overlayView.alpha = 0;
    }];
}

- (void)removeCardViewAndTransformations
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.center;
        self.center = CGPointMake(center.x+100, center.y);
    } completion:^(BOOL success){
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}


//とりあえずpangestureが起こるたびに呼ばれる。YESを返しておくとなぜか- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizerが呼ばれないときも呼んでくれる。毎回yesで良いのかは謎。
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
