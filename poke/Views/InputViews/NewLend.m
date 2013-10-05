
//
//  NewLend.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "NewLend.h"

#define defaultBtnSize 80

@implementation NewLend

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [backBtn setTitle:@"<" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
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
        

        
        bottomViewController = [[AddAndSearchFriendsViewController alloc]initWithNibName:@"AddAndSearchFriendsViewController" bundle:[NSBundle mainBundle]];
        bottomViewController.view.layer.anchorPoint = CGPointMake(bottomButton.frame.origin.x/self.frame.size.width, bottomButton.frame.origin.y/self.frame.size.height);
        [bottomViewController.view setFrame:CGRectMake(bottomButton.center.x-defaultBtnSize/3.5, bottomButton.frame.origin.y, screenWidth/(screenHeight/defaultBtnSize), screenHeight/(screenHeight/defaultBtnSize))];
        [bottomViewController.view setAlpha:0];
        [self addSubview:bottomViewController.view];
        
        
        
        rightView = [[ItemsView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [rightView setBackgroundColor:[UIColor purpleColor]];
        rightView.layer.anchorPoint = CGPointMake(rightButton.frame.origin.x/self.frame.size.width, rightButton.frame.origin.y/self.frame.size.height);
        [rightView setFrame:CGRectMake(rightButton.center.x-defaultBtnSize/3.5, rightButton.frame.origin.y,screenWidth/(screenHeight/defaultBtnSize) ,screenHeight/(screenHeight/defaultBtnSize))];
        
        [rightView setAlpha:0];
        [self addSubview:rightView];
        
        
        leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        
        
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(uiTapped:)];
        [pan setDelegate:self];
        
        [self addGestureRecognizer:pan];
        
        [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(switchBackToMainViewWithViewWitNotification:) name:eventMainViewBackToNormal object:nil];
    }
    return self;
}

-(void)goBack{
    [[NSNotificationCenter defaultCenter]postNotificationName:eventMainViewBackToNormal object:self];
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
//                [self switchToView:topView fromBtn:topButton];
            }
            else if (CGRectContainsPoint(bottomButton.frame, location))
            {
                NSLog(@"Bottom function");
                [self switchToView:bottomViewController.view fromBtn:bottomButton];
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
                [self switchToView:rightView fromBtn:rightButton];
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
    [self bringSubviewToFront:view];
    [grabbedBtn setAlpha:0];
    btn.alpha = 0;
    originalRect= view.frame;
    dummyView = [[UIImageView alloc]initWithImage:[self screenshot]];
    [self insertSubview:dummyView belowSubview:view];
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
-(void)switchBackToMainViewWithViewWitNotification:(NSNotification*)not
{
    [self switchBackToMainViewWithView:not.object];
}

-(void)switchBackToMainViewWithView:(UIView*)view
{
    [self insertSubview:dummyView belowSubview:view];
    [UIView animateWithDuration:0.5 animations:^{
        
        [view setFrame:originalRect];
        dummyView.transform = CGAffineTransformMakeScale(1, 1);
        
    }completion:^(BOOL finished)
     {
         [dummyView removeFromSuperview];
         [self setShowBtns:YES];
         [view setAlpha:0];
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
