//
//  ViewController.m
//  Animations
//
//  Created by Liu Kai on 2017/1/16.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "ViewController.h"
#import "ModalNormalAnimation.h"
#import "ModelDismissAnimation.h"
@interface ViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *controller = segue.destinationViewController;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self;
}

#pragma mark - UIViewControllerTransitioiningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [ModalNormalAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{

    return [ModelDismissAnimation new];
}

@end
