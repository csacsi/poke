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
        itemsView = [[ItemsView alloc]initWithFrame:CGRectZero];
        [itemsView setDelegate:self];
        [super initView:itemsView forButton:rightButton];
        rightView = itemsView;
        [rightButton setImage:[UIImage imageNamed:@"view"] forState:UIControlStateNormal];
        
        lendView = [[NewLend alloc]initWithFrame:CGRectZero];
        [lendView setDelegate:self];
        [super initView:lendView forButton:topButton];
        [topButton setImage:[UIImage imageNamed:@"lend"]forState:UIControlStateNormal];
        topView = lendView;
        
        addfriendsView = [[AddAndSearchFriendsViewController alloc]initWithNibName:@"AddAndSearchFriendsViewController" bundle:[NSBundle mainBundle]];
        [addfriendsView setDelegate:self];
        [super initView:addfriendsView.view forButton:leftButton];
        [leftButton setImage:[UIImage imageNamed:@"friends"]forState:UIControlStateNormal];
        leftView = addfriendsView.view;
        
        [bottomButton removeFromSuperview];
        bottomButton = nil;
    }
    
    return self;
}

-(void)viewWithJoypadBackPressed:(UIView *)childView
{
    [super switchBackToMainViewWithView:childView];
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
