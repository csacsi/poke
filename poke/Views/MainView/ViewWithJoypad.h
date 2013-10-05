//
//  ViewWithJoypad.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewWithJoypad;

@protocol ViewWithJoypadDelegate <NSObject>

-(void)viewWithJoypadBackPressed:(UIView*)childView;

@end

@interface ViewWithJoypad : UIView<UIGestureRecognizerDelegate>
{
    UIImageView*leftButton;
    UIImageView*rightButton;
    UIImageView*topButton;
    UIImageView*bottomButton;
    
    UIImageView* joystick;
    
    UIPanGestureRecognizer*pan;
    
    UIView*grabbedBtn;
    CGPoint startPoint;
    
    UIView*topView;
    UIView*bottomView;
    UIView*leftView;
    UIView*rightView;
    
    UIImageView * dummyView;
    UIImageView* viewDummy;
    CGRect originalRect;

}
-(void)switchBackToMainViewWithView:(UIView*)view;
-(void)initView:(UIView*)view forButton:(UIImageView*)button;
@end
