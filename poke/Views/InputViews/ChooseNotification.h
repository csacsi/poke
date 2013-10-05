//
//  ChooseNotification.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "ViewWithJoypad.h"

@interface ChooseNotification : ViewWithJoypad<ViewWithJoypadDelegate>{
    UIButton*backBtn;
    
    BOOL isEmail,isSMS,isNotification,isReminder;

}

@end
