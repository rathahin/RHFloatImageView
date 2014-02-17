//
//  ViewController.m
//  RHFloatImageView
//
//  Created by Ratha Hin on 2/17/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "ViewController.h"
#import "RHFloatImageViewControl.h"

@interface ViewController ()

@property (strong, nonatomic) UIBarButtonItem *rightButton;
@property (strong, nonatomic) RHFloatImageViewControl *floatImageViewControl;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)rightButton {
  if (!_rightButton) {
    _rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Show"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(rightButtonAction)];
    
  }
  
  return _rightButton;
}

- (void)rightButtonAction {
  [self.floatImageViewControl floatImageViewFromRect:CGRectMake(260, 20, 44, 44)];
}

- (RHFloatImageViewControl *)floatImageViewControl {
  if (!_floatImageViewControl) {
    _floatImageViewControl = [[RHFloatImageViewControl alloc] initWithImage:[UIImage imageNamed:@"dummy"]];
  }
  
  return _floatImageViewControl;
}

@end
