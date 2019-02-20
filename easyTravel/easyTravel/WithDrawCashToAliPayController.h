//
//  WithDrawCashToAliPayController.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WithDrawCashToAliPayController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *account;
- (IBAction)confirm:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *moneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *moneyContent;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UITextField *accountText;

@end
