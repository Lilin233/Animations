//
//  TileView.m
//  Animations
//
//  Created by Liu Kai on 2017/1/16.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "TileView.h"
#import "UIViewExt.h"
#import "Constants.h"
@interface TileView()

@property (nonatomic, strong) UIImage *chimesSplashImage;
@property (nonatomic, copy) NSArray *rippleAnimationKeyTimes;

@end

@implementation TileView

- (instancetype)initWithTileFileName:(NSString *)tileFileName{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.chimesSplashImage = [UIImage imageNamed:tileFileName];
        self.frame = CGRectMake(0, 0, self.chimesSplashImage.size.width, self.chimesSplashImage.size.height);
        self.layer.contents = (__bridge id _Nullable)(self.chimesSplashImage.CGImage);
        self.layer.shouldRasterize = YES;
    }
    return self;
}

- (void)startAnimatingWithDuration:(NSTimeInterval)duration beginTime:(NSTimeInterval)beginTime rippleDelay:(NSTimeInterval)rippleDelay rippleOffset:(CGPoint)rippleOffset {
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15 :0 :0.2 :1];
    CAMediaTimingFunction *linearFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    CAMediaTimingFunction *easeOutFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    CAMediaTimingFunction *easeInOutTimingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    NSValue *zeroPointValue = [NSValue valueWithCGPoint:CGPointZero];

    NSMutableArray *animations = [@[] mutableCopy];
    if (_shouldEnableRipple) {
        // Transform.scale
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.values = @[@1, @1, @1.05, @1, @1];
        scaleAnimation.keyTimes = self.rippleAnimationKeyTimes;
        scaleAnimation.timingFunctions = @[linearFunction,
                                          timingFunction,
                                          timingFunction,
                                           linearFunction];
        scaleAnimation.beginTime = 0.0;
        scaleAnimation.duration = duration;
        
        [animations addObject:scaleAnimation];
        
        // Position
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = duration;
        positionAnimation.timingFunctions = @[linearFunction,
                                             timingFunction,
                                             timingFunction,
                                              linearFunction];
        positionAnimation.keyTimes = self.rippleAnimationKeyTimes;
        positionAnimation.values = @[zeroPointValue,
                                    zeroPointValue,
                                    [NSValue valueWithCGPoint:rippleOffset],
                                    zeroPointValue,
                                     zeroPointValue];
        positionAnimation.additive = YES;
        
        [animations addObject:positionAnimation];
    }
    
    // Opacity
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.timingFunctions = @[easeInOutTimingFunction,
                                        timingFunction,
                                        timingFunction,
                                        easeOutFunction,
                                         linearFunction];
    opacityAnimation.keyTimes = @[@0.0, @0.61, @0.7, @0.767, @0.95, @1.0];
    opacityAnimation.values = @[@0.0, @1.0, @0.45, @0.6, @0.0, @0.0];
    
    [animations addObject:opacityAnimation];
    
    // Group
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.repeatCount = INFINITY;
    groupAnimation.fillMode = kCAFillModeBackwards;
    groupAnimation.duration = duration;
    groupAnimation.beginTime = beginTime + rippleDelay;
    groupAnimation.removedOnCompletion = YES;
    groupAnimation.animations = animations;
    groupAnimation.timeOffset = kAnimationTimeOffset;
    
    [self.layer addAnimation:groupAnimation forKey:@"ripple"];
}

- (void)stopAnimating {
    [self.layer removeAllAnimations];
}

#pragma mark - Custom Accessors
- (NSArray *)rippleAnimationKeyTimes{
    return @[@0, @0.61, @0.7, @0.887, @1];
}
@end
