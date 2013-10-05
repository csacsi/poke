//
//  UIColor+Utils.h
//  AnyToDo.UIProto
//
//  Created by Toth Csaba on 4/18/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

+(UIColor*)colorWithHex:(unsigned int)hex;
+(unsigned int)hexFromColor:(UIColor*)color;

+ (UIColor *)darkerColorForColor:(UIColor *)c;
+ (UIColor *)lighterColorForColor:(UIColor *)c;
+ (UIColor *)interpolateColorFrom:(UIColor*)color1 to:(UIColor*)color2 lerp:(double)lerp;

-(UIColor*) inverseColor;
-(UIColor*)colorForText;
-(double) getLuminance;
@end
