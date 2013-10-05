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
        [self setBackgroundColor:[UIColor yellowColor]];
        
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 40, 40, 40)];
        [backBtn setTitle:@"<" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];

        amount = 1;
        [joystick setTitle:[NSString stringWithFormat:@"%d",amount] forState:UIControlStateNormal];
        isInteractionTypeSelected = NO;
    }
    return self;
}

-(void)switchToView:(UIView *)view fromBtn:(UIImageView *)btn{
    NSLog(@"vava");

    [btn setBackgroundColor:[UIColor yellowColor]];
    if (isInteractionTypeSelected)  {
        [super switchToView:view fromBtn:btn];
    }else{
    
        if ([btn isEqual:topButton]) {
            
            selectedInteractionType = lendCategoryCash;
            
        }else if([btn isEqual:leftButton]){
            selectedInteractionType = lendCategoryBook;
            
        }else if([btn isEqual:rightButton]){
            selectedInteractionType = lendCategoryClothes;
            
        }else if([btn isEqual:bottomButton]){
            //Other
        }
        [self showAlert];
    }
    
}

-(void)showAlert{

    __block UITextField* tf = [[UITextField alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 100)];
    
    [tf setBackgroundColor:[UIColor clearColor]];
    [tf setTextColor:[UIColor blackColor]];
    [tf setText:@"Now you have to choose how many you lent to Csomak"];
    [self addSubview:tf];
    [UIView animateWithDuration:0.3 animations:^{
        [tf setTransform:CGAffineTransformMakeTranslation(0, -150)];
    }completion:^(BOOL finished) {
        [NSTimer scheduledTimerWithTimeInterval:5 block:^{
            [tf removeFromSuperview];
        } repeats:NO];
    }];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
