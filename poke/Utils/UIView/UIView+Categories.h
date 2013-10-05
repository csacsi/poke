//
//  UIView+Categories.h
//  AnyToDo.UIProto
//
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (Categories)

- (UIImage*)screenshot;

@property double x;
@property double y;
@property double width;
@property double height;
@property (readonly) double maxY;
@property (readonly) double maxX;

@property (readonly) double contentHeight;
@property (readonly) double contentWidth;

@end
