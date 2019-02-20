//
//  ModifyPwdController.h
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ModifyPwdCell.h"

@interface ModifyPwdController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ModifyPwdCellDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submit:(id)sender;
@end
