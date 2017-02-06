//
//  TileView.h
//  Animations
//
//  Created by Liu Kai on 2017/1/16.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TileView : UIView

@property (nonatomic, assign) BOOL shouldEnableRipple;

- (instancetype)initWithTileFileName:(NSString *)tileFileName;

- (void)startAnimatingWithDuration:(NSTimeInterval)duration beginTime:(NSTimeInterval)beginTime rippleDelay:(NSTimeInterval)rippleDelay rippleOffset:(CGPoint)rippleOffset;

- (void)stopAnimating;

@end
