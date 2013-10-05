//
//  UIColor+Utils.m
//  AnyToDo.UIProto
//
//  Created by Toth Csaba on 4/18/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+(UIColor*)colorWithHex:(unsigned int)hex{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0  green:((float)((hex & 0xFF00) >> 8))/255.0  blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+(unsigned int)hexFromColor:(UIColor*)color{
    CGFloat r, g, b, a;
    if (![color getRed: &r green: &g blue: &b alpha: &a])
        return 0.0f;
    
    r = MIN(MAX(r, 0.0f), 1.0f);
    g = MIN(MAX(g, 0.0f), 1.0f);
    b = MIN(MAX(b, 0.0f), 1.0f);
    
    return (((int)roundf(r * 0xFF)) << 16) | (((int)roundf(g * 0xFF)) << 8) | (((int)roundf(b * 0xFF)));
}



+ (UIColor *)lighterColorForColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c
{
    float r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

+ (UIColor*)interpolateColorFrom:(UIColor*)color1 to:(UIColor*)color2 lerp:(double)lerp
{
    unsigned int color1Hex = [self hexFromColor:color1];
    unsigned int color2Hex = [self hexFromColor:color2];
    
    unsigned int MASK1 = 0xff00ff;
    unsigned int MASK2 = 0x00ff00;
    
    unsigned int f2 = 256 * lerp;
    unsigned int f1 = 256 - f2;
    
    unsigned int newColor =  ((((( color1Hex & MASK1 ) * f1 ) + ( ( color2Hex & MASK1 ) * f2 )) >> 8 ) & MASK1 )
    | ((((( color1Hex & MASK2 ) * f1 ) + ( ( color2Hex & MASK2 ) * f2 )) >> 8 ) & MASK2 );
    
    return [self colorWithHex:newColor];
}

-(UIColor*) inverseColor
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

-(double) getLuminance
{
    CGFloat r,g,b,a;
    
    [self getRed:&r green:&g blue:&b alpha:&a];
    //From: http://www.scantips.com/lumin.html
    return 0.3*r + 0.59*g + 0.11*b;
}

-(UIColor*)colorForText
{
    if([self getLuminance]<0.5)
    {
        return [UIColor blackColor];
    }
    else
    {
        return [UIColor whiteColor];
    }
}

@end
