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

@interface ViewWithJoypad : UIView<UIGestureRecognizerDelegate, ViewWithJoypadDelegate,UIAlertViewDelegate>
{
    UIButton*leftButton;
    UIButton*rightButton;
    UIButton*topButton;
    UIButton*bottomButton;
    
    UIButton* joystick;
    
    UIPanGestureRecognizer*pan;
    UITapGestureRecognizer*tap;
    
    UIView*grabbedBtn;
    CGPoint startPoint;
    
    UIView*topView;
    UIView*bottomView;
    UIView*leftView;
    UIView*rightView;
    
    UIImageView * dummyView;
    UIImageView* viewDummy;
    CGRect originalRect;
    
    UILabel* tf;
    NSTimer*alertTimer;

}
@property (nonatomic,strong)id<ViewWithJoypadDelegate>delegate;
-(void)reArrange;
-(void)switchBackToMainViewWithView:(UIView*)view;
-(void)switchToView:(UIView*)view fromBtn:(UIButton*)btn;
-(void)initView:(UIView*)view forButton:(UIButton*)button;

-(void)joypadPressed;
-(void)showAlertWithMessage:(NSString*)msg;
-(void)initBtnImages;
@end
