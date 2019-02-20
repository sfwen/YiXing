//
//  VipOrderViewController.h
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderNeedPayCell.h"
#import "RedNumberView.h"
#import "Common.h"

@interface VipOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,VipOrderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)tab1Click:(id)sender;
- (IBAction)tab1BtnClick:(id)sender;
- (IBAction)tab2Click:(id)sender;
- (IBAction)tab2BtnClick:(id)sender;
- (IBAction)tab3Click:(id)sender;
- (IBAction)tab3BtnClick:(id)sender;
- (IBAction)tab4Click:(id)sender;
- (IBAction)tab4BtnClick:(id)sender;


@property (weak, nonatomic) IBOutlet RedNumberView *numView4;

@property (weak, nonatomic) IBOutlet RedNumberView *numView3;

@property (weak, nonatomic) IBOutlet RedNumberView *numView2;

@property (weak, nonatomic) IBOutlet RedNumberView *numView1;

-(void)setMode:(enum ORDER_MODE)mode;

@property (weak, nonatomic) IBOutlet UIView *indicatorLine1;
@property (weak, nonatomic) IBOutlet UIView *indicatorLine2;
@property (weak, nonatomic) IBOutlet UIView *indicatorLine3;
@property (weak, nonatomic) IBOutlet UIView *indicatorLine4;

@property (weak, nonatomic) IBOutlet UIButton *tab1;
@property (weak, nonatomic) IBOutlet UIButton *tab2;
@property (weak, nonatomic) IBOutlet UIButton *tab3;
@property (weak, nonatomic) IBOutlet UIButton *tab4;
@end
