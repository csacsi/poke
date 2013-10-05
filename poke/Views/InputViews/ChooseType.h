//
//  ChooseType.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWithJoypad.h"
#import "LendInteraction.h"
#import "ChooseTime.h"
@interface ChooseType : ViewWithJoypad{
    UIButton*backBtn;
    int amount;
    lendInteractionCateoryType selectedInteractionType;
    BOOL isInteractionTypeSelected;
    ChooseTime * chooseTime;
}

@end
