//
//  ViewController.m
//  RHFloatImageView
//
//  Created by Ratha Hin on 2/17/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIBarButtonItem *rightButton;

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
  NSLog(@"Show");
}

@end
