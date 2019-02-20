//
//  HotelOrderListViewController.h
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HotelOrderListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

- (IBAction)btn1Click:(id)sender;
- (IBAction)btn2Click:(id)sender;
- (IBAction)btn3Click:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *redLine1;
@property (weak, nonatomic) IBOutlet UIView *redLine2;
@property (weak, nonatomic) IBOutlet UIView *redLine3;
@property (weak, nonatomic) IBOutlet UIButton *title2;
@property (weak, nonatomic) IBOutlet UIButton *title1;
@property (weak, nonatomic) IBOutlet UIButton *title3;
@property (weak, nonatomic) IBOutlet UIView *topBottomLine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
