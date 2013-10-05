
//
//  NewLend.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "NewLend.h"

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
