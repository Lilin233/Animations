//
//  TileGridView.m
//  Animations
//
//  Created by Liu Kai on 2017/1/16.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "TileGridView.h"
#import "TileView.h"
#import "UIViewExt.h"
#import "Constants.h"
static NSTimeInterval const kRippleDelayMultiplier = 0.0006666;
@interface TileGridView()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) TileView *modelTileView;
@property (nonatomic, strong) TileView *centerTileView;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) NSInteger numberOfColumns;

@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, copy) NSMutableArray *tileViewRows;
@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign) NSTimeInterval kRippleDelayMultiplier;

@end

@implementation TileGridView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.containerView.center = self.center;
    self.modelTileView.center = self.containerView.center;
    CGPoint center = CGPointMake(self.centerTileView.bounds.size.width / 2 + 31, self.centerTileView.bounds.size.height / 2);
    self.logoLabel.center = center;
}

- (instancetype)initWithTileFileName:(NSString *)name{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.modelTileView = [[TileView alloc] initWithTileFileName:name];
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        
        self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 630, 990)];
        self.containerView.backgroundColor = [UIColor colorWithRed:0.059 green:0.306 blue:0.396 alpha:1.00];
        self.containerView.clipsToBounds = YES;
        self.containerView.layer.masksToBounds = YES;
        [self addSubview:self.containerView];
        
        [self renderTileViews];
        //    self.logoLabel = generateLogoLabel()
        [self.centerTileView addSubview:self.logoLabel];
        [self layoutIfNeeded];
     }
    return self;
}

- (void)startAnimating{
    self.beginTime = CACurrentMediaTime();
    [self startAnimatingWithBeginTime:self.beginTime];
}

- (UILabel *)generateLogoLabel{
    UILabel *label = [UILabel new];
    label.text = @"F         BER";
    label.font = [UIFont systemFontOfSize:50.f];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    label.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    return label;
}

- (void)renderTileViews{
    CGFloat width = self.containerView.width;
    CGFloat height = self.containerView.height;
    
    CGFloat modelImageWidth = self.modelTileView.width;
    CGFloat modelImageHeight = self.modelTileView.height;
    
    self.numberOfColumns = (ceil((width - self.modelTileView.bounds.size.width / 2.0) / self.modelTileView.bounds.size.width));
    self.numberOfRows = (ceil((height - self.modelTileView.bounds.size.height / 2.0) / self.modelTileView.bounds.size.height));
    
    for (NSInteger y = 0; y < self.numberOfRows; y++){
        NSMutableArray *tileRows = [@[] mutableCopy];
        for (NSInteger x = 0; x < self.numberOfColumns; x++) {
            TileView *view = [[TileView alloc]initWithTileFileName:@"Chimes"];
            view.frame = CGRectMake(x * modelImageWidth, y * modelImageHeight, modelImageWidth, modelImageHeight);
            if (view.center.x == self.containerView.center.x && view.center.y == self.containerView.center.y){
                self.centerTileView = view;
            }
            [self.containerView addSubview:view];
            [tileRows addObject:view];
            
            if (y != 0 && y != self.numberOfRows - 1 && x != 0 && x != self.numberOfColumns - 1) {
                view.shouldEnableRipple = YES;
            }

            }
        [self.tileViewRows addObject:tileRows];
        }
    [self.containerView bringSubviewToFront:self.centerTileView];
}

- (void)startAnimatingWithBeginTime:(NSTimeInterval)beginTime{
    
    CAMediaTimingFunction *linearTimingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyframe.timingFunctions = @[linearTimingFunction, [CAMediaTimingFunction functionWithControlPoints:0.6 :0 :0.15 :1], linearTimingFunction];

    keyframe.repeatCount = INFINITY;
    keyframe.duration = kAnimationDuration;
    keyframe.removedOnCompletion = NO;
    keyframe.keyTimes = @[@0.0, @0.45, @0.887, @1.0];
    keyframe.values = @[@0.75, @0.75, @1.0, @1.0];
    keyframe.beginTime = beginTime;
    keyframe.timeOffset = kAnimationTimeOffset;
    
    [self.containerView.layer addAnimation:keyframe forKey:@"scale"];
    
    for (NSArray *tileRows in self.tileViewRows) {
        for (TileView *view in tileRows) {
            CGFloat distance = [self distanceFromCenterViewWithView:view];
            CGPoint vector = [self normalizedVectorFromCenterViewToView:view];
            
            vector = CGPointMake(vector.x * kRippleMagnitudeMultiplier * distance, vector.y * kRippleMagnitudeMultiplier * distance);
            [view startAnimatingWithDuration:kAnimationDuration beginTime:beginTime rippleDelay:kRippleDelayMultiplier * distance rippleOffset:vector];
        }
    }
}
- (CGFloat)distanceFromCenterViewWithView:(UIView *)view {
    if (self.centerTileView == nil) {
        return 0.f;
    }
    CGFloat normalizedX = (view.center.x - self.centerTileView.center.x);
    CGFloat normalizedY = (view.center.y - self.centerTileView.center.y);
    NSLog(@"%f", sqrt(normalizedX * normalizedX + normalizedY * normalizedY));
    return sqrt(normalizedX * normalizedX + normalizedY * normalizedY);
}

- (CGPoint)normalizedVectorFromCenterViewToView:(UIView *)view {
    CGFloat length = [self distanceFromCenterViewWithView: view];
    if (_centerTileView == nil || length == 0) {
        return CGPointZero;
    }
    CGFloat deltaX = view.center.x - self.centerTileView.center.x;
    CGFloat deltaY = view.center.y - self.centerTileView.center.y;
    NSLog(@"%f -- %f", deltaX / length, deltaY / length);

    return CGPointMake(deltaX / length, deltaY / length);
}


#pragma mark - Custom Accestors
- (NSMutableArray *)tileViewRows{
    if(_tileViewRows == nil){
        _tileViewRows = [@[] mutableCopy];
    }
    return _tileViewRows;
}
@end
