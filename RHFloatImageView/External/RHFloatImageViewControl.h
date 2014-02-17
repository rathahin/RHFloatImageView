//
//  RHFloatImageViewControl.h
//  RHFloatImageView
//
//  Created by Ratha Hin on 2/17/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHFloatImageViewControl : NSObject

@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGesture;

- (id)initWithImage:(UIImage *)image;
- (void)floatImageViewFromRect:(CGRect)startRect;

@end
