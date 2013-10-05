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
        
        topView = [[NewLend alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
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
                [self switchToView:topView fromBtn:topButton];
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

-(void) setShowBtns:(BOOL)show
{
    [topButton setAlpha:show];
    [bottomButton setAlpha:show];
    [leftButton setAlpha:show];
    [rightButton setAlpha:show];
}
-(void)switchToView:(UIView*)view fromBtn:(UIView*)btn
{
    [grabbedBtn setAlpha:0];
    btn.alpha = 0;
    originalRect= view.frame;
    dummyView = [[UIImageView alloc]initWithImage:[self screenshot]];
    [self addSubview:dummyView];
    [self setShowBtns:NO];
    
    [dummyView.layer setAnchorPoint:CGPointMake(btn.center.x / self.frame.size.width, btn.center.y / self.frame.size.height)];
    [dummyView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    [view setAlpha:1];
    
    [UIView animateWithDuration:0.5 animations:^{
        dummyView.transform = CGAffineTransformMakeScale(4, 4);
        [view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
    }completion:^(BOOL finished) {
        [dummyView removeFromSuperview];
        [NSTimer scheduledTimerWithTimeInterval:0.5 block:^{
//            [self switchBackToMainViewWithView:view];
        } repeats:NO];
    }];
}

-(void)switchBackToMainViewWithView:(UIView*)view
{
    [self addSubview:dummyView];
    [UIView animateWithDuration:0.5 animations:^{
        
        [view setFrame:originalRect];
        dummyView.transform = CGAffineTransformMakeScale(1, 1);
        
    }completion:^(BOOL finished)
     {
         [dummyView removeFromSuperview];
         [self setShowBtns:YES];
         [topView setAlpha:0];
         [grabbedBtn setAlpha:1];
         [joystick setAlpha:1];
     }];

}

-(UIImage*)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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