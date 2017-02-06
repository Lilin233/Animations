//
//  TwitterModalNormalAnimationViewController.m
//  Animations
//
//  Created by Liu Kai on 2017/1/16.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "TwitterModalNormalAnimationViewController.h"

@interface TwitterModalNormalAnimationViewController ()

@end

@implementation TwitterModalNormalAnimationViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.view.layer.cornerRadius = 4;
    self.view.layer.masksToBounds = YES;
}


#pragma mark - Action
- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
