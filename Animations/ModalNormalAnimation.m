//
//  ModalNormalAnimation.m
//  Animations
//
//  Created by Liu Kai on 2017/1/16.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "ModalNormalAnimation.h"
#import "UIViewExt.h"
@implementation ModalNormalAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0;
    
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
   
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        toVC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        fromVC.view.transform = CGAffineTransformMakeScale(0.9, 0.9);

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
