//
//  RHFloatImageViewControl.m
//  RHFloatImageView
//
//  Created by Ratha Hin on 2/17/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHFloatImageViewControl.h"
#import "UIView+Genie.h"


// will expose to be property
const CGFloat MAX_DISTANCE = 250;
const CGFloat MAX_PERCENTAGE = 0.75;

@interface RHFloatImageViewControl ()

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *floatImageView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIWindow *overlayWindow;
@property (strong, nonatomic) UIView *floatOverlayView;
@property (assign, nonatomic) CGRect startRect;

@end

@implementation RHFloatImageViewControl

- (id)initWithImage:(UIImage *)image {
  self = [super init];
  
  if (self) {
    _image = image;
    _floatImageView = [[UIImageView alloc] initWithImage:_image];
    [self commonsetup];
  }
  
  return self;
}

- (void)commonsetup {
  [self.floatImageView addGestureRecognizer:self.panGesture];
  self.floatImageView.userInteractionEnabled = YES;
}

- (UIWindow *)overlayWindow {
  if(!_overlayWindow) {
    _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _overlayWindow.backgroundColor = [UIColor clearColor];
    _overlayWindow.userInteractionEnabled = YES;
    _overlayWindow.windowLevel = UIWindowLevelNormal;
  }
  return _overlayWindow;
}

- (UIView *)floatOverlayView {
  if (!_floatOverlayView) {
    _floatOverlayView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _floatOverlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
  }
  
  return _floatOverlayView;
}

- (void)floatImageViewFromRect:(CGRect)startRect {
  self.startRect = startRect;
  [self.floatOverlayView addSubview:self.floatImageView];
  self.floatImageView.center= CGPointMake(CGRectGetMidX(self.floatOverlayView.bounds), CGRectGetMidY(self.floatOverlayView.bounds));
  [self.overlayWindow addSubview:self.floatOverlayView];
  [self.overlayWindow setHidden:NO];
  [self.floatImageView genieOutTransitionWithDuration:0.25
                             startRect:startRect
                             startEdge:BCRectEdgeBottom
                            completion:nil];
}

- (UIPanGestureRecognizer *)panGesture {
  
  if (!_panGesture) {
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
  }
  
  return _panGesture;
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture {
  static CGRect frameBeforeChange;
  
  if (panGesture.state == UIGestureRecognizerStateBegan) {
    frameBeforeChange = self.floatImageView.frame;
  } else if (panGesture.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [panGesture translationInView:self.floatImageView];
    CGFloat x = frameBeforeChange.origin.x + translation.x;
    CGFloat y = frameBeforeChange.origin.y + translation.y;
    [self moveView:self.floatImageView withPoint:CGPointMake(x, y)];
    [self handleByDistance:[self distanceOfPoint:CGPointMake(x, y) toPoint:frameBeforeChange.origin]];
  } else if (panGesture.state == UIGestureRecognizerStateEnded) {
    [self handlePanGestureEnd:panGesture];
  }
  
}

- (void)moveView:(UIView *)view withPoint:(CGPoint)point {
  CGRect frame = view.frame;
  frame.origin = point;
  view.frame = frame;
}

- (void)handleByDistance:(CGFloat)distance {
  CGFloat percentage = distance / MAX_DISTANCE;
  if (percentage > MAX_PERCENTAGE) percentage = MAX_PERCENTAGE;
  
  self.floatOverlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:(1.0 - percentage)];
}

- (void)handlePanGestureEnd:(UIPanGestureRecognizer *)panGesture {
  CGPoint velocity = [panGesture velocityInView:self.floatImageView];
  CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
  CGFloat slideMult = magnitude / 200;
  float slideFactor = 0.1 * slideMult;
  CGFloat finalDistination = fabsf(velocity.y * slideFactor);
  
  if ([self shouldCloseWithDistance:finalDistination]) {
    [self floatOut];
  } else {
    [self floatBack];
  }
}

- (void)floatOut {

  
  [self.floatImageView genieInTransitionWithDuration:0.25
                      destinationRect:self.startRect
                      destinationEdge:BCRectEdgeBottom
                           completion:^{
                             [self.floatOverlayView removeFromSuperview];
                             self.overlayWindow = nil;
                           }];
}

- (void)floatBack {
  
  [UIView animateWithDuration:0.25 animations:^{
      self.floatImageView.center= CGPointMake(CGRectGetMidX(self.floatOverlayView.bounds), CGRectGetMidY(self.floatOverlayView.bounds));
    self.floatOverlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
  }];
  
}

- (BOOL)shouldCloseWithDistance:(CGFloat)distance {
  return distance > MAX_DISTANCE * 0.75;
}

#pragma mark - util
- (CGFloat)distanceOfPoint:(CGPoint)p1 toPoint:(CGPoint)p2 {
  CGFloat xDist = (p2.x - p1.x); //[2]
  CGFloat yDist = (p2.y - p1.y); //[3]
  return fabsf(sqrt((xDist * xDist) + (yDist * yDist)));
}

@end
