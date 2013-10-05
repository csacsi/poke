//
//  ItemsView.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIButton* backBtn;
    UITableView*tbl;
    NSMutableArray*list;
    NSMutableArray*friends;
}

@end
