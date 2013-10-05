//
//  ChooseTime.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWithJoypad.h"
#import "LendInteraction.h"
#import "ChooseNotification.h"

typedef enum {
    lendTimeCategorieDay,
    lendTimeCategorieWeek,
    lendTimeCategorieMonth
} lendTimeCategories;


@interface ChooseTime : ViewWithJoypad<ViewWithJoypadDelegate>{
    UIButton*backBtn;
    int amount;
    lendTimeCategories selectedTimeType;
    BOOL isInteractionTypeSelected;
    NSDate*selectedDate;
    ChooseNotification*chooseNotif;
}


@end
