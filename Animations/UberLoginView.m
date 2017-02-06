//
//  UberLoginView.m
//  Animations
//
//  Created by Liu Kai on 2017/1/17.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "UberLoginView.h"
#import "Constants.h"
static CGFloat const kCycleRadius = 37.5f;
static CGFloat const kSquareLayerLength = 21.f;
@interface UberLoginView()
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (nonatomic, strong) CAShapeLayer *squareLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign) NSTimeInterval startTimeOffset;
@property (nonatomic, strong) CAMediaTimingFunction *strokeEndTimingFunction;
@property (nonatomic, strong) CAMediaTimingFunction *squareLayerTimingFunction;
@property (nonatomic, strong) CAMediaTimingFunction *circleLayerTimingFunction;
@property (nonatomic, strong) CAMediaTimingFunction *fadeInSquareTimingFunction;
@end

@implementation UberLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.startTimeOffset = 0.7 * kAnimationDuration;
        self.strokeEndTimingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0.35 :1];
        self.squareLayerTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0 :0.2 :1];
        self.circleLayerTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.65 :0 :0.4 :1];
        self.fadeInSquareTimingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15 :0 :0.85 :1];
    }
    return self;
}

- (void)startAnimating{
    self.beginTime = CACurrentMediaTime();
    self.layer.anchorPoint = CGPointZero;
    [self animateMaskLayer];
    [self animateCircleLayer];
    [self animateLineLayer];
    [self animateSquareLayer];
}

- (void)animateCircleLayer{
    CAKeyframeAnimation *stokeEndAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    stokeEndAnimation.timingFunction = _strokeEndTimingFunction;
    stokeEndAnimation.duration = kAnimationDuration - kAnimationDurationDelay;
    stokeEndAnimation.values = @[@0, @1];
    stokeEndAnimation.keyTimes = @[@0, @1];
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunction = _strokeEndTimingFunction;
    transformAnimation.duration = kAnimationDuration - kAnimationDurationDelay;
    
    CATransform3D transform = CATransform3DMakeRotation(-M_PI_4, 0, 0, 1);
    transform = CATransform3DScale(transform, 0.25, 0.25, 1);
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:transform];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[stokeEndAnimation, transformAnimation];
    animations.repeatCount = INFINITY;
    animations.duration = kAnimationDuration;
    animations.beginTime = self.beginTime;
    animations.timeOffset = self.startTimeOffset;
    [self.circleLayer addAnimation:animations forKey:@"looping"];
}

- (void)animateLineLayer{
    // lineWidth
    CAKeyframeAnimation *lineWidthAnimation = [CAKeyframeAnimation animationWithKeyPath:@"lineWidth"];
    lineWidthAnimation.values = @[@0.0, @5.0, @0.0];
    lineWidthAnimation.timingFunctions = @[_strokeEndTimingFunction, _circleLayerTimingFunction];
    lineWidthAnimation.duration = kAnimationDuration;
    lineWidthAnimation.keyTimes = @[@0,
                                   [NSNumber numberWithDouble:(1.0 - kAnimationDurationDelay/kAnimationDuration)],
                                    @1];
    
    // transform
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    transformAnimation.timingFunctions = @[_strokeEndTimingFunction, _circleLayerTimingFunction];
    transformAnimation.duration = kAnimationDuration;
    transformAnimation.keyTimes = @[@0.0,
                                   [NSNumber numberWithDouble:1.0 - kAnimationDurationDelay/kAnimationDuration],
                                    @1.0];
    
    CATransform3D transform = CATransform3DMakeRotation(-M_PI_4, 0, 0, 1);
    transform = CATransform3DScale(transform, 0.25, 0.25, 1.0);
    transformAnimation.values = @[[NSValue valueWithCATransform3D:transform],
                                 [NSValue valueWithCATransform3D:CATransform3DIdentity],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.15, 0.15, 1.0)]];
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.beginTime = _beginTime;
    groupAnimation.animations = @[lineWidthAnimation, transformAnimation];
    groupAnimation.timeOffset = self.startTimeOffset;
    
    // add animation group
    [self.lineLayer addAnimation:groupAnimation forKey:@"looping"];

}

- (void)animateSquareLayer{
    
    // bounds
    NSValue *b1 = [NSValue valueWithCGRect:CGRectMake(0, 0, 2.0/3.0 * kSquareLayerLength , 2.0/3.0 * kSquareLayerLength)];
    NSValue *b2 = [NSValue valueWithCGRect:CGRectMake(0, 0, kSquareLayerLength, kSquareLayerLength)];
    NSValue *b3 = [NSValue valueWithCGRect:CGRectZero];
    
    CAKeyframeAnimation *boundsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.values = @[b1, b2, b3];
    boundsAnimation.timingFunctions = @[_fadeInSquareTimingFunction, _squareLayerTimingFunction];
    boundsAnimation.duration = kAnimationDuration;
    boundsAnimation.keyTimes = @[@0,
                                [NSNumber numberWithFloat:1.0 - kAnimationDurationDelay/kAnimationDuration],
                                 @1];
    
    // backgroundColor
    CABasicAnimation *backgroundColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    backgroundColorAnimation.fromValue = (__bridge id _Nullable)([UIColor whiteColor].CGColor);
    backgroundColorAnimation.toValue = (__bridge id _Nullable)([UIColor colorWithRed:0.059 green:0.306 blue:0.396 alpha:1.00].CGColor);
    backgroundColorAnimation.timingFunction = _squareLayerTimingFunction;
    backgroundColorAnimation.fillMode = kCAFillModeBoth;
    backgroundColorAnimation.beginTime = kAnimationDurationDelay * 2.0 / kAnimationDuration;
    backgroundColorAnimation.duration = kAnimationDuration / (kAnimationDuration - kAnimationDurationDelay);
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[boundsAnimation, backgroundColorAnimation];
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.beginTime = self.beginTime;
    groupAnimation.timeOffset = self.startTimeOffset;
    
    // add animation group
    [self.squareLayer addAnimation:groupAnimation forKey:@"looping"];

}

- (void)animateMaskLayer{
    // bounds
    CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kCycleRadius * 2, kCycleRadius * 2)];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 2.0 / 3.0 * kSquareLayerLength, 2.0 / 3.0 * kSquareLayerLength)];
    boundsAnimation.duration = kAnimationDurationDelay;
    boundsAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay;
    boundsAnimation.timingFunction = _circleLayerTimingFunction;
    
    // cornerRadius
    CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadiusAnimation.beginTime = kAnimationDuration - kAnimationDurationDelay;
    cornerRadiusAnimation.duration = kAnimationDurationDelay;
    cornerRadiusAnimation.fromValue = [NSNumber numberWithDouble:kCycleRadius];
    cornerRadiusAnimation.toValue = @2.0;
    cornerRadiusAnimation.timingFunction = _circleLayerTimingFunction;
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeBoth;
    groupAnimation.beginTime = self.beginTime;
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.duration = kAnimationDuration;
    groupAnimation.animations = @[boundsAnimation, cornerRadiusAnimation];
    groupAnimation.timeOffset = self.startTimeOffset;
    
    // add animation group
    [self.maskLayer addAnimation:groupAnimation forKey:@"looping"];
}

#pragma mark - Custom Accessors
- (CAShapeLayer *)circleLayer{
    if (_circleLayer == nil) {
        _circleLayer = [CAShapeLayer layer];
        _circleLayer.lineWidth = kCycleRadius;
        _circleLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:kCycleRadius / 2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES].CGPath;
        _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:_circleLayer];
    }
    return _circleLayer;
}

- (CAShapeLayer *)lineLayer{
    if (_lineLayer == nil) {
        _lineLayer = [CAShapeLayer layer];
        _lineLayer.frame = CGRectZero;
        _lineLayer.position = CGPointZero;
        _lineLayer.allowsGroupOpacity = YES;
        _lineLayer.lineWidth = 5.f;
        _lineLayer.strokeColor = [UIColor colorWithRed:0.059 green:0.306 blue:0.396 alpha:1.00].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(0, -kCycleRadius)];
        _lineLayer.path = path.CGPath;
        [self.layer addSublayer:_lineLayer];
    }
    return _lineLayer;
}

- (CAShapeLayer *)squareLayer{
    if (_squareLayer == nil) {
        _squareLayer = [CAShapeLayer layer];
        _squareLayer.position = CGPointZero;
        _squareLayer.frame = CGRectMake(-kSquareLayerLength / 2, -kSquareLayerLength / 2, kSquareLayerLength, kSquareLayerLength);
        _squareLayer.cornerRadius = 1.5;
        _squareLayer.allowsGroupOpacity = YES;
        _squareLayer.backgroundColor = [UIColor colorWithRed:0.059 green:0.306 blue:0.396 alpha:1.00].CGColor;
        [self.layer addSublayer:_squareLayer];
    }
    return _squareLayer;
}

- (CAShapeLayer *)maskLayer{
    if (_maskLayer == nil) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = CGRectMake(-kCycleRadius, -kCycleRadius, kCycleRadius * 2, kCycleRadius * 2);
        _maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _maskLayer.allowsGroupOpacity = YES;
        self.layer.mask = _maskLayer;
    }
    return _maskLayer;
}

@end
