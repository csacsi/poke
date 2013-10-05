//
//  ChooseNotification.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "ChooseNotification.h"
#import "AppDelegate.h"
@implementation ChooseNotification
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
        
    
        
        [topButton setBackgroundImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"notification"] forState:UIControlStateNormal];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"sms"] forState:UIControlStateNormal];
        [bottomButton setBackgroundImage:[UIImage imageNamed:@"reminder"] forState:UIControlStateNormal];
        
    }
    return self;
}

-(void)switchToView:(UIView *)view fromBtn:(UIImageView *)btn{
    NSLog(@"vava");
    [self initBtnImages];
    [UIView beginAnimations:@"" context:nil];
        [btn setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    [UIView commitAnimations];
    
        if ([btn isEqual:topButton]) {
            isEmail = !isEmail;
        }else if([btn isEqual:leftButton]){
            isSMS = !isSMS;
            
        }else if([btn isEqual:rightButton]){
            isNotification = !isNotification;
        }else if([btn isEqual:bottomButton]){
            isReminder = !isReminder;
        }
    [self initBtnImages];
    [joystick setBackgroundImage:[UIImage imageNamed:@"check"] forState: UIControlStateNormal];

//        [self showAlertWithMessage:@"If selected all of notifications what you want, just tap on ok."];
}

-(void)initBtnImages{
    [UIView beginAnimations:@"" context:nil];
    if (isEmail) {
        [topButton setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }else{
        [topButton setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }
    
    if (isSMS) {
        [topButton setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }else{
        [leftButton setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }
    
    if (isNotification) {
        [rightButton setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }else{
        [rightButton setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }
    
    if (isReminder) {
        [bottomButton setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    }else{
        [bottomButton setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }
    [UIView commitAnimations];
    
    
}

-(void)reArrange
{
    [super reArrange];
    double scale = self.width/screenWidth;
    
    [backBtn setFrame:CGRectMake(10*scale, 30*scale, 35*scale, 35*scale)];
}

-(void)backBtn:(UIButton*)sender
{
    if (self.delegate) {
        [self.delegate viewWithJoypadBackPressed:self];
    }
}


-(void)joypadPressed{
    
    PFObject *msgObject = [PFObject objectWithClassName:@"Message"];
    [msgObject setObject: @"derjugoBaszod" forKey:@"text"];
    [msgObject setObject:[NSNumber numberWithBool:NO] forKey:@"cancelled"];
    [msgObject setObject:[NSNumber numberWithBool:NO] forKey:@"sent"];
    [msgObject setObject:[NSNumber numberWithBool:NO] forKey:@"isSMS"];
    [msgObject setObject: @"csomakk@gmail.com" forKey:@"to"];
    [msgObject setObject: [NSDate date] forKey:@"date"];
    [msgObject saveInBackground];
    
    [[[UIAlertView alloc]initWithTitle:@"Heyy Csomakk will be notified!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
    
    RootViewController * root = ApplicationDelegate.rootViewController;
    [root goBackToMainView];
}
-(void)viewWithJoypadBackPressed:(UIView *)childView
{
    [super switchBackToMainViewWithView:childView];
}



@end
