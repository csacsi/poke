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
        // Initialization code
        name = [[UITextField alloc]initWithFrame:CGRectMake(0, 40, 200, 30)];
        [name setPlaceholder:@"Name"];
        [self addSubview:name];
    }
    return self;
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
