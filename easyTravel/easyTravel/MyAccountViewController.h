//
//  MyAccountViewController.h
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTable.h";

@interface MyAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet CustomTable *customTable;
@property (weak, nonatomic) IBOutlet UILabel *accountMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountMoneyText;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *withDrawCashBtn;
- (IBAction)inCharge:(id)sender;

- (IBAction)getCash:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *grayLine;
@property (weak, nonatomic) IBOutlet UIView *redLine;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableWidth;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
