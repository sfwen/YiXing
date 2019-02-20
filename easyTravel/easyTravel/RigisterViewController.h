//
//  RigisterViewController.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RegisterCell.h"

@interface RigisterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SendMessageDelete>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (strong,nonatomic) UIButton *doneInKeyboardButton;

@end
