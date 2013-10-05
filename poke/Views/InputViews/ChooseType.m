//
//  ChooseType.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "ChooseType.h"

@implementation ChooseType

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
        
        chooseTime = [[ChooseTime alloc]initWithFrame:CGRectZero];
        [chooseTime setDelegate:self];
        
        [topButton setBackgroundImage:[UIImage imageNamed:@"money"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"book"]forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"clothes"]forState:UIControlStateNormal];
        [bottomButton setBackgroundImage:[UIImage imageNamed:@"other"]forState:UIControlStateNormal];
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
    NSLog(@"vava");
    [self initBtnImages];
//    [btn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [UIView beginAnimations:@"" context:nil];
        [btn setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    [UIView commitAnimations];
//    [btn setBackgroundColor:[UIColor greenColor]];
    if (isInteractionTypeSelected && amount > 0)  {
        [super initView:chooseTime forButton:btn];
        [super switchToView:chooseTime fromBtn:btn];
    }else{
    
        if ([btn isEqual:topButton]) {
            selectedInteractionType = lendCategoryCash;
            [self showAlertWithMessage:@"Now you have to choose how many cash you want to lend for Csomak"];
            
        }else if([btn isEqual:leftButton]){
            selectedInteractionType = lendCategoryBook;
            [self showAlertWithMessage:@"Now you have to choose how many books you want to lend for Csomak"];
        }else if([btn isEqual:rightButton]){
            selectedInteractionType = lendCategoryClothes;
            [self showAlertWithMessage:@"Now you have to choose how many clothes you want to lend for Csomak"];
        }else if([btn isEqual:bottomButton]){
            //Other
            [self initBtnImages];
            return;
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


-(void)joypadPressed{
    amount++;
    [joystick setTitle:[NSString stringWithFormat:@"%d",amount] forState:UIControlStateNormal];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    amount =  [alertView textFieldAtIndex:0].text.intValue;
    UIButton * btn;
    switch (selectedInteractionType) {
        case lendCategoryCash:
            btn = topButton;
            break;
        case lendCategoryClothes:
            btn = rightButton;
            break;
        case lendCategoryBook:
            btn = leftButton;
            break;
        case lendCategoryOther:
            btn = bottomButton;
            break;
        default:
            break;
    }
    [super initView:chooseTime forButton:btn];
    [super switchToView:chooseTime fromBtn:btn];
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
