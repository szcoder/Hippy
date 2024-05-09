//
//  UIBezierPath+VN.h
//  VideoNativeiPhone
//
//  Created by Norcy on 2018/4/13.
//  Copyright © 2018年 Norcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Shadow)

+ (instancetype)shadow_bezierPathWithRoundedRect:(CGRect)rect
                                         topLeft:(CGFloat)topLeftRadius
                                        topRight:(CGFloat)topRightRadius
                                      bottomLeft:(CGFloat)bottomLeftRadius
                                     bottomRight:(CGFloat)bottomRightRadius;
@end
