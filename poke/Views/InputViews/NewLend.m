
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
        [self setBackgroundColor:[UIColor clearColor]];
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 35, 35)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        [self initBtnImages];
        
        typeSelector = [[ChooseType alloc]initWithFrame:CGRectZero];
        [typeSelector setDelegate:self];
        [super initView:typeSelector forButton:joystick];
        [self addSubview:typeSelector];
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
    
    [backBtn setFrame:CGRectMake(10*scale, 30*scale, 35*scale, 35*scale)];
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
//    [btn setBackgroundColor:[UIColor yellowColor]];
    if ([btn isEqual:topButton]) {

        [joystick setImage:topButton.imageView.image forState:UIControlStateNormal];
        [joystick setBackgroundColor:[UIColor clearColor]];
        [self personSelected:[DataManager getInstance].myFriends[0]];
        
    }else if([btn isEqual:leftButton]){

        [joystick setImage:leftButton.imageView.image forState:UIControlStateNormal];
        [joystick setBackgroundColor:[UIColor clearColor]];
        [self personSelected:[DataManager getInstance].myFriends[1]];
    }else if([btn isEqual:rightButton]){
        [joystick setImage:rightButton.imageView.image forState:UIControlStateNormal];
        [joystick setBackgroundColor:[UIColor clearColor]];
        [self personSelected:[DataManager getInstance].myFriends[2]];
    }else if([btn isEqual:bottomButton]){
        friendsController = [[AddAndSearchFriendsViewController alloc] initWithNibName:@"AddAndSearchFriendsViewController" bundle:[NSBundle mainBundle]];
        [friendsController setPersonDelegate:self];
        [friendsController setAllowDismiss:YES];
        [ApplicationDelegate.rootViewController presentViewController:friendsController animated:YES completion:nil];

    }
}

-(void)initBtnImages
{
    
    [topButton setImage:[UIImage imageNamed:@"user01.png"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"user02.png"]forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"user03.png"]forState:UIControlStateNormal];
    [bottomButton setImage:[UIImage imageNamed:@"user00.png"]forState:UIControlStateNormal];
    [topButton setBackgroundColor:[UIColor clearColor]];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [bottomButton setBackgroundColor:[UIColor clearColor]];
}

-(void)joypadPressed{
    
}

-(void)personSelected:(Friend *)person
{
    borrower = person;
    [joystick setImage:borrower.picture forState:UIControlStateNormal];
//    joystick.layer.cornerRadius = joystick.imageView.image.size.height / 2-6;
//    
//    joystick.layer.masksToBounds = YES;
//    
//    joystick.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    joystick.layer.borderWidth = 3.0;
    [super initView:typeSelector forButton:joystick];
    [super switchToView:typeSelector fromBtn:joystick];
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
