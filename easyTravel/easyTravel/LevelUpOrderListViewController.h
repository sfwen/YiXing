//
//  LevelUpOrderListViewController.h
//  easyTravel
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelUpOrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
