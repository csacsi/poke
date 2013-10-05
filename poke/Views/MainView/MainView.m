//
//  MainView.m
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "MainView.h"
#define defaultBtnSize 80
@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        topButton = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-defaultBtnSize/2, screenHeight/2-defaultBtnSize/2-80, defaultBtnSize,defaultBtnSize)];
        [topButton setBackgroundColor:[UIColor blueColor]];
        
        bottomButton = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-defaultBtnSize/2, screenHeight/2-defaultBtnSize/2+80, defaultBtnSize,defaultBtnSize)];
        [bottomButton setBackgroundColor:[UIColor blueColor]];
        
        leftButton = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-defaultBtnSize/2-80, screenHeight/2-defaultBtnSize/2, defaultBtnSize,defaultBtnSize)];
        [leftButton setBackgroundColor:[UIColor blueColor]];
        
         rightButton = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2-defaultBtnSize/2+80, screenHeight/2-defaultBtnSize/2, defaultBtnSize,defaultBtnSize)];
        [rightButton setBackgroundColor:[UIColor blueColor]];
        
        joystick = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2-defaultBtnSize/2, screenHeight/2-defaultBtnSize/2, defaultBtnSize, defaultBtnSize)];
        [joystick setBackgroundColor:[UIColor redColor]];
        
        [self addSubview:topButton];
        [self addSubview:bottomButton];
        [self addSubview:leftButton];
        [self addSubview:rightButton];
        [self addSubview:joystick];
        
        topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [topView setBackgroundColor:[UIColor greenColor]];
        topView.layer.anchorPoint = CGPointMake(topButton.frame.origin.x/self.frame.size.width, topButton.frame.origin.y/self.frame.size.height);
        [topView setFrame:CGRectMake(topButton.center.x-defaultBtnSize/3.5, topButton.frame.origin.y,screenWidth/(screenHeight/defaultBtnSize) ,screenHeight/(screenHeight/defaultBtnSize))];

        NSLog(@"%@",NSStringFromCGRect(topView.frame));
        [topView setAlpha:0];
        [self addSubview:topView];
        
        
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
        
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(uiTapped:)];
        [pan setDelegate:self];
        
        [self addGestureRecognizer:pan];
    }
    return self;
}

-(void)uiTapped:(UITapGestureRecognizer*)gesture
{
    NSLog(@"tapped");
    CGPoint location = [gesture locationInView:self];
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Began");
        if (CGRectContainsPoint(joystick.frame, location))
        {
            grabbedBtn = joystick;
            startPoint = joystick.center;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            grabbedBtn.center = location;
        }];
    }
    
    if ([gesture state] == UIGestureRecognizerStateChanged)
    {
        NSLog(@"changed");
        [UIView beginAnimations:@"" context:nil];
            [grabbedBtn setCenter:location];
        [UIView commitAnimations];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded)
    {
        NSLog(@"ended");
        if (grabbedBtn) {
            if (CGRectContainsPoint(topButton.frame, location))
            {
                NSLog(@"Top function");
                [grabbedBtn setAlpha:0];
                topButton.alpha = 0;
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
                [self.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [grabbedBtn setAlpha:0];
                // hack, helps w/ our colors when blurring
                //NSData *imageData = UIImageJPEGRepresentation(image, 1); // convert to jpeg
                // image = [UIImage imageWithData:imageData];
                
                
                __block UIImageView * dummyView = [[UIImageView alloc]initWithImage:image];
                [self addSubview:dummyView];
                [topButton setAlpha:0];
                [bottomButton setAlpha:0];
                [leftButton setAlpha:0];
                [rightButton setAlpha:0];
                
                [dummyView.layer setAnchorPoint:CGPointMake(topButton.center.x / self.frame.size.width, topButton.center.y / self.frame.size.height)];
                [dummyView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                [topButton setBackgroundColor:[UIColor redColor]];
                [topView setAlpha:1];

                [UIView animateWithDuration:0.5 animations:^{
                    dummyView.transform = CGAffineTransformMakeScale(4, 4);
                    [topView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
                    
                }completion:^(BOOL finished) {
                    [dummyView removeFromSuperview];
                    [NSTimer scheduledTimerWithTimeInterval:0.5 block:^{
                        [self addSubview:dummyView];
                        [UIView animateWithDuration:0.5 animations:^{
                            [topView setFrame:CGRectMake(topButton.center.x-defaultBtnSize/3.5, topButton.frame.origin.y,screenWidth/(screenHeight/defaultBtnSize) ,screenHeight/(screenHeight/defaultBtnSize))];
                            dummyView.transform = CGAffineTransformMakeScale(1, 1);
                        }completion:^(BOOL finished) {
                            [dummyView removeFromSuperview];
                            [topButton setAlpha:1];
                            [bottomButton setAlpha:1];
                            [leftButton setAlpha:1];
                            [rightButton setAlpha:1];
                            [topView setAlpha:0];
                        }];
                    } repeats:NO];
                }];
                
                
                
                
                
            }
            else if (CGRectContainsPoint(bottomButton.frame, location))
            {
                NSLog(@"Bottom function");
                [bottomButton setBackgroundColor:[UIColor redColor]];
            }
            else if (CGRectContainsPoint(leftButton.frame, location))
            {
                NSLog(@"Left function");
                [leftButton setBackgroundColor:[UIColor redColor]];
            }
            else if (CGRectContainsPoint(rightButton.frame, location))
            {
                NSLog(@"Right function");
                [rightButton setBackgroundColor:[UIColor redColor]];
            }
            [UIView animateWithDuration:0.5 animations:^{
                [rightButton setBackgroundColor:[UIColor blueColor]];
                [leftButton setBackgroundColor:[UIColor blueColor]];
                [topButton setBackgroundColor:[UIColor blueColor]];
                [bottomButton setBackgroundColor:[UIColor blueColor]];
            }];
            [UIView beginAnimations:@"" context:nil];
            grabbedBtn.center = startPoint;
            grabbedBtn = nil;
            [UIView commitAnimations];
        }
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
