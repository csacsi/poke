//
//  MainView.m
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "ViewWithJoypad.h"

#define defaultBtnSize 80
#define defaultJoySize 100
@implementation ViewWithJoypad

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        topButton = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-defaultBtnSize/2, self.height/2-defaultBtnSize/2-120, defaultBtnSize,defaultBtnSize)];
        [topButton setBackgroundColor:[UIColor blueColor]];
        
        bottomButton = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-defaultBtnSize/2, self.height/2-defaultBtnSize/2+120, defaultBtnSize,defaultBtnSize)];
        [bottomButton setBackgroundColor:[UIColor blueColor]];
        
        leftButton = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-defaultBtnSize/2-120, self.height/2-defaultBtnSize/2, defaultBtnSize,defaultBtnSize)];
        [leftButton setBackgroundColor:[UIColor blueColor]];
        
        rightButton = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-defaultBtnSize/2+120, self.height/2-defaultBtnSize/2, defaultBtnSize,defaultBtnSize)];
        [rightButton setBackgroundColor:[UIColor blueColor]];
        
        joystick = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-defaultJoySize/2, self.height/2-defaultJoySize/2, defaultJoySize, defaultJoySize)];
        [joystick setBackgroundColor:[UIColor redColor]];
        [joystick setUserInteractionEnabled:NO];
        
        [self addSubview:topButton];
        [self addSubview:bottomButton];
        [self addSubview:leftButton];
        [self addSubview:rightButton];
        [self addSubview:joystick];
        
        
        topView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self initView:topView forButton:topButton];
        [self initView:rightView forButton:rightButton];
        [self initView:leftView forButton:leftButton];
        [self initView:bottomView forButton:bottomButton];
        
        
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(uiPanned:)];
        [pan setDelegate:self];
        [self addGestureRecognizer:pan];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uiTapped:)];
        [tap setDelegate:self];
        [tap setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:tap];
       
    }
    return self;
}

-(void)initView:(UIView*)view forButton:(UIImageView*)button
{
    view.layer.anchorPoint = CGPointMake(button.frame.origin.x/self.frame.size.width, button.frame.origin.y/self.frame.size.height);
    if (self.height == 0) {
        [view setFrame:CGRectMake(0, 0, 1, 1)];
    }else{
        [view setFrame:CGRectMake(button.center.x-defaultBtnSize/3.5, button.frame.origin.y, self.width/(self.height/defaultBtnSize) ,self.height/(self.height/defaultBtnSize))];
    }
    
    [view setAlpha:0];
    [self addSubview:view];

}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self reArrange];
}
-(void)reArrange
{
    double btnSize = defaultBtnSize* (self.width/screenWidth);
    double joysize = defaultJoySize* (self.width/screenWidth);
    
    [topButton setFrame:CGRectMake(self.width/2-btnSize/2, self.height/2-btnSize/2-100* (self.width/screenWidth), btnSize,btnSize)];
    [bottomButton setFrame:CGRectMake(self.width/2-btnSize/2, self.height/2-btnSize/2+100* (self.width/screenWidth), btnSize,btnSize)];
    [leftButton setFrame:CGRectMake(self.width/2-btnSize/2-100* (self.width/screenWidth), self.height/2-btnSize/2, btnSize,btnSize)];
    [rightButton setFrame:CGRectMake(self.width/2-btnSize/2+100* (self.width/screenWidth), self.height/2-btnSize/2, btnSize,btnSize)];
    [joystick setFrame:CGRectMake(self.width/2-joysize/2, self.height/2-joysize/2, joysize, joysize)];
    
    [self initView:topView forButton:topButton];
    [self initView:bottomView forButton:bottomButton];
    [self initView:leftView forButton:leftButton];
    [self initView:rightView forButton:rightButton];
}
-(void)uiTapped:(UITapGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self];
    if ([gesture state] == UIGestureRecognizerStateEnded)
    {
            if (CGRectContainsPoint(topButton.frame, location))
            {
                [self switchToView:topView fromBtn:topButton];
            }
            else if (CGRectContainsPoint(bottomButton.frame, location))
            {
                [self switchToView:bottomView fromBtn:bottomButton];
            }
            else if (CGRectContainsPoint(leftButton.frame, location))
            {
                [self switchToView:leftView fromBtn:leftButton];
            }
            else if (CGRectContainsPoint(rightButton.frame, location))
            {
                [self switchToView:rightView fromBtn:rightButton];
            }
            else if(CGRectContainsPoint(joystick.frame, location)){
                [self joypadPressed];
            }
    }
}

-(void)uiPanned:(UIPanGestureRecognizer*)gesture
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
                [self switchToView:bottomView fromBtn:bottomButton];
            }
            else if (CGRectContainsPoint(leftButton.frame, location))
            {
                [self switchToView:leftView fromBtn:leftButton];
            }
            else if (CGRectContainsPoint(rightButton.frame, location))
            {
                [self switchToView:rightView fromBtn:rightButton];
            }
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

-(void)switchToView:(UIView*)view fromBtn:(UIImageView*)btn
{
    [self bringSubviewToFront:view];
    
    [grabbedBtn setAlpha:0];
    [joystick setAlpha:0];
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
        [view setFrame:CGRectMake(0, 0, self.width, self.height)];
        
    }completion:^(BOOL finished) {
        [dummyView removeFromSuperview];
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
-(void)joypadPressed
{
    NSLog(@"joypadPressed");
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
