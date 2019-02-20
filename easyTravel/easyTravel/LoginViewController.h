//
//  LoginViewController.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinCode.h"
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>


@property (strong, nonatomic) UIBarButtonItem *rigisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fogetPwdBtn;
- (IBAction)fogetPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *autoLoginBtn;
- (IBAction)autoLogin:(UIButton*)button;
@property (weak, nonatomic) IBOutlet UIButton *checkbox;
- (IBAction)checkboxDoClick:(UIButton*)button;
@property (weak, nonatomic) IBOutlet UIButton *changeCodeBtn;
- (IBAction)changeCode:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *line3;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (weak, nonatomic) IBOutlet PinCode *pinCode;


@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *code;


@end
