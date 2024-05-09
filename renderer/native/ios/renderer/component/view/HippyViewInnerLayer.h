//
//  QVNInnerLayer.h
//  VNComponent
//
//  Created by Norcy on 2018/4/17.
//  Copyright © 2018年 Norcy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HippyViewInnerLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat mShadowOffsetX;
@property (nonatomic, assign) CGFloat mShadowOffsetY;
@property (nonatomic, assign) CGFloat mShadowBlur;
@property (nonatomic, assign) CGFloat mShadowSpread;
@property (nonatomic, strong) UIColor *mShadowColor;

@property (nonatomic, assign) CGFloat boxShadowOpacity;

@property (nonatomic, assign) CGPoint mInnerTopStart;
@property (nonatomic, assign) CGPoint mInnerTopEnd;
@property (nonatomic, assign) CGPoint mInnerLeftStart;
@property (nonatomic, assign) CGPoint mInnerLeftEnd;
@property (nonatomic, assign) CGPoint mInnerBottomStart;
@property (nonatomic, assign) CGPoint mInnerBottomEnd;
@property (nonatomic, assign) CGPoint mInnerRightStart;
@property (nonatomic, assign) CGPoint mInnerRightEnd;

@property (nonatomic, strong) UIBezierPath *outerBorderPath;
@end


