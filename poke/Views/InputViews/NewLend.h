//
//  NewLend.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAndSearchFriendsViewController.h"
#import "ItemsView.h"


@interface NewLend :UIView
{
    UIButton*backBtn;
    
    UIView*leftButton;
    UIView*rightButton;
    UIView*topButton;
    UIView*bottomButton;
    
    UIView* joystick;
    
    UIPanGestureRecognizer*pan;
    
    UIView*grabbedBtn;
    CGPoint startPoint;
    
    AddAndSearchFriendsViewController *bottomViewController;
    UIView*leftView;
    ItemsView*rightView;
    
    UIImageView * dummyView;
    CGRect originalRect;

    
}

@end
