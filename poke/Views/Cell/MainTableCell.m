//
//  MainTableCell.m
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "MainTableCell.h"
#import "UIColor+Utils.h"

@implementation MainTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor greenColor]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LendInteraction *)model
{
    _model = model;
    [self.textLabel setText:_model.name];
    [self setBackgroundColor:[UIColor interpolateColorFrom:[UIColor redColor] to:[UIColor greenColor] lerp:255.0*_model.status/100.0]];
    
}
@end
