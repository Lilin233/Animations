//
//  TwitterLaunchAnimationViewController.m
//  Animations
//
//  Created by Liu Kai on 2017/2/6.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "TwitterLaunchAnimationViewController.h"

@interface TwitterLaunchAnimationViewController ()
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TwitterLaunchAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupMaskLayerAnimation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupMaskLayerAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    animation.keyTimes = @[@0, @0.5, @1];
    animation.beginTime = CACurrentMediaTime() + 1;
    animation.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)], [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 38)], [NSValue valueWithCGRect:CGRectMake(0, 0,3000, 3000)]];
    animation.removedOnCompletion = false;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.4;
    [self.maskLayer addAnimation:animation forKey:@"boundsAnimation"];

    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [_maskLayer removeFromSuperlayer];
        _maskLayer = nil;
    }];

    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyframe.duration = 0.5;
    keyframe.removedOnCompletion = NO;
    keyframe.keyTimes = @[@0.0, @0.45, @1.0];
    keyframe.values = @[@1, @1.05, @1.0];
    keyframe.beginTime = CACurrentMediaTime() + 1.45;
    [self.view.layer addAnimation:keyframe forKey:@"keyframe"];
    
}

#pragma mark - Custom Accessors
- (CALayer *)maskLayer{
    if (_maskLayer == nil) {
        _maskLayer = [CALayer new];
        _maskLayer.position = self.view.center;
        _maskLayer.bounds = CGRectMake(0, 0, 50, 38);
        _maskLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"Twitter_Logo"].CGImage);
        [self.view.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}
@end
