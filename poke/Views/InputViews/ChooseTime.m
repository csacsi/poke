//
//  ChooseTime.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "ChooseTime.h"

@implementation ChooseTime

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 35, 35)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        amount = 0;
        isInteractionTypeSelected = NO;
        
        [bottomButton removeFromSuperview];
        bottomButton = nil;
        
        chooseNotif = [[ChooseNotification alloc]initWithFrame:CGRectZero];
        [chooseNotif setDelegate:self];
        
        [topButton setBackgroundImage:[UIImage imageNamed:@"day"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"month"] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"week"] forState:UIControlStateNormal];
    }
    return self;
}
-(void)reArrange
{
    [super reArrange];
    double scale = self.width/screenWidth;
    
    [backBtn setFrame:CGRectMake(10*scale, 30*scale, 35*scale, 35*scale)];
}
-(void)switchToView:(UIView *)view fromBtn:(UIButton *)btn{
    [self initBtnImages];
    [UIView beginAnimations:@"" context:nil];
        [btn setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    [UIView commitAnimations];

    if (isInteractionTypeSelected && amount > 0)  {
        [super initView:chooseNotif forButton:btn];
        [super switchToView:chooseNotif fromBtn:btn];
    }else{
        
        if ([btn isEqual:topButton]) {
            selectedTimeType = lendTimeCategorieDay;
            [self showAlertWithMessage:@"How many days you want to lend your money?"];
            
        }else if([btn isEqual:leftButton]){
            selectedTimeType = lendTimeCategorieMonth;
            [self showAlertWithMessage:@"How many months you want to lend your money?"];
        }else if([btn isEqual:rightButton]){
            selectedTimeType = lendTimeCategorieWeek;
            [self showAlertWithMessage:@"How many weeks you want to lend your money?"];
        }else if([btn isEqual:bottomButton]){
            //Other
        }
        isInteractionTypeSelected = YES;
        
    }
    
}



-(void)backBtn:(UIButton*)sender
{
    if (self.delegate) {
        [self.delegate viewWithJoypadBackPressed:self];
    }
}

-(void)viewWithJoypadBackPressed:(UIView *)childView
{
    [super switchBackToMainViewWithView:childView];
}


-(void)joypadPressed{
    amount++;
    [joystick setTitle:[NSString stringWithFormat:@"%d",amount] forState:UIControlStateNormal];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    amount =  [alertView textFieldAtIndex:0].text.intValue;
    UIButton * btn;
    switch (selectedTimeType) {
        case lendTimeCategorieDay:
            btn = topButton;
            break;
        case lendTimeCategorieMonth:
            btn = rightButton;
            break;
        case lendTimeCategorieWeek:
            btn = leftButton;
            break;
        default:
            break;
    }
    [super initView:chooseNotif forButton:btn];
    [super switchToView:chooseNotif fromBtn:btn];
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
