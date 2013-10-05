
//
//  NewLend.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "NewLend.h"
#import "AppDelegate.h"
@implementation NewLend

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor greenColor]];
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 40, 40, 40)];
        [backBtn setTitle:@"<" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        [self initBtnImages];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reArrange];
}
-(void)reArrange
{
    [super reArrange];
    double scale = self.width/screenWidth;
    
    [backBtn setFrame:CGRectMake(40*scale, 40*scale, 40*scale, 40*scale)];
}
-(void)backBtn:(UIButton*)sender
{
    if (self.delegate) {
        [self.delegate viewWithJoypadBackPressed:self];
    }
}

-(void)switchToView:(UIView *)view fromBtn:(UIImageView *)btn{
    NSLog(@"vava");
    [self initBtnImages];
    [btn setBackgroundColor:[UIColor yellowColor]];
}

-(void)initBtnImages
{
    [topButton setBackgroundColor:[UIColor colorWithRed:255 green:100 blue:100 alpha:1]];
    [leftButton setBackgroundColor:[UIColor colorWithRed:100 green:255 blue:100 alpha:1]];
    [rightButton setBackgroundColor:[UIColor colorWithRed:100 green:100 blue:255 alpha:1]];
    [bottomButton setBackgroundColor:[UIColor colorWithRed:150 green:110 blue:29 alpha:1]];
}

-(void)joypadPressed{
    friendsController = [[AddAndSearchFriendsViewController alloc] initWithNibName:@"AddAndSearchFriendsViewController" bundle:[NSBundle mainBundle]];
    [friendsController setPersonDelegate:self];
    [friendsController setAllowDismiss:YES];
    [ApplicationDelegate.rootViewController presentViewController:friendsController animated:YES completion:nil];
}

-(void)personSelected:(Friend *)person
{
    borrower = person;
    [joystick setImage:borrower.picture];
    joystick.layer.cornerRadius = joystick.image.size.height / 2-6;
    joystick.layer.masksToBounds = YES;
    
    joystick.layer.borderColor = [UIColor lightGrayColor].CGColor;
    joystick.layer.borderWidth = 3.0;
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
