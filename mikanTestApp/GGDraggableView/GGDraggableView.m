//
//  GGDraggableView.m
//  TinderLikeAnimations2
//
//  Created by Shun Usami on 2014/05/21.
//  Copyright (c) 2014年 ShunUsami. All rights reserved.
//

#import "GGDraggableView.h"


@interface GGDraggableView ()

@property (nonatomic) CGPoint centerPoint;
@end

@implementation GGDraggableView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString *nibName = NSStringFromClass([self class]);
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        self.frame = frame;
        
        
        [self loadImageAndStyle];
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
    
    
    _overlayView = [[GGOverlayView alloc] initWithFrame:self.bounds];
    _overlayView.alpha = 0;
    [self addSubview:_overlayView];
    _originalPoint = self.center;
}

- (void)loadImageAndStyle
{
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _japaneseLabel.hidden = NO;
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance/320, 1);
            CGFloat rotationAngle = (CGFloat) (-2*M_PI/16 * rotationStrength);
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
                if ([_delegate respondsToSelector:@selector(displayNextCardDelegate:sender:)]) {
                    [_delegate displayNextCardDelegate:YES sender:self];
                } else {NSLog(@"no responds to remember");}

            }
            else if (xDistance < -60){
                //Write delegate method shen swipe to the left
                if ([_delegate respondsToSelector:@selector(displayNextCardDelegate:sender:)]) {
                    [_delegate displayNextCardDelegate:NO sender:self];
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
        self.overlayView.mode = GGOverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode =
        GGOverlayViewModeLeft;
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

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2 animations:^{
        self.center = self.originalPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        self.overlayView.alpha = 0;
    }];
}

- (void)setParameter:(NSString*)english
            japanese:(NSString*)japanese
              number:(NSString*)number
  japaneseHiddenFlug:(BOOL)japaneseHiddenFlug
           wordIndex:(int)wordIndex
{
    _englishLabel.text = english;
    _japaneseLabel.text = japanese;
    _numberLabel.text = number;
    _japaneseLabel.hidden = japaneseHiddenFlug;
    _wordIndex = wordIndex;
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
