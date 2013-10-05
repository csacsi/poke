//
//  UIView+Categories.m
//  AnyToDo.UIProto
//
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import "UIView+Categories.h"

@implementation UIView (Categories)

- (UIImage*)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // hack, helps w/ our colors when blurring
    //NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
    // image = [UIImage imageWithData:imageData];
    
    
    return image;
}

-(double) contentHeight
{
    double maxH  = 0;
    for (UIView* vv in self.subviews)
    {
        if(vv.subviews.count == 0)
        {
            return self.maxY;
        }
        else if(vv.contentHeight > maxH)
        {
            maxH = vv.maxY;
        }
    }
    
    return maxH;
}


-(double) contentWidth
{
    double max  = 0;
    for (UIView* vv in self.subviews)
    {
        if(vv.subviews.count == 0)
        {
            return self.maxX;
        }
        else if(vv.contentHeight > max)
        {
            max = vv.maxX;
        }
    }
    
    return max;
}

-(double) x
{
    return self.frame.origin.x;
}

-(void) setX:(double)x
{
    [self setFrame:CGRectMake(x, self.y, self.width, self.height)];
}

-(double) y
{
    return self.frame.origin.y;
}

-(void) setY:(double)y
{
    [self setFrame:CGRectMake(self.x, y, self.width, self.height)];

}

-(double) width
{
    return self.frame.size.width;
}

-(void) setWidth:(double)width
{
      CGAffineTransform t= self.transform;
      self.transform = CGAffineTransformIdentity;
    [self setFrame:CGRectMake(self.x, self.y, width, self.height)];
      self.transform = t;

}

-(double) height
{
    return self.frame.size.height;
}

-(void) setHeight:(double)height
{
    CGAffineTransform t= self.transform;
    self.transform = CGAffineTransformIdentity;
     [self setFrame:CGRectMake(self.x, self.y, self.width, height)];
    self.transform = t;
}

-(double) maxY
{
    return self.y + self.height;
}

-(double) maxX
{
    return self.x + self.width;
}



@end
