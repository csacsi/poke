//
//  MainView.h
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewLend.h"
#import "AddAndSearchFriendsViewController.h"
@class MainView;


@interface MainView : UIView<UIGestureRecognizerDelegate>
{
    UIView*leftButton;
    UIView*rightButton;
    UIView*topButton;
    UIView*bottomButton;
    
    UIView* joystick;
    
    UIPanGestureRecognizer*pan;
    
    UIView*grabbedBtn;
    CGPoint startPoint;
    
    NewLend*topView;
    AddAndSearchFriendsViewController *bottomViewController;
    UIView*leftView;
    UIView*rightView;
    
    UIImageView * dummyView;
    CGRect originalRect;
    
}

@end
