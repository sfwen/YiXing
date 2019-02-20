//
//  LoginViewController.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "RigisterViewController.h"
#import "CommonUtil.h"
#import "FogetPasswordViewController.h"
#import "AppLogic.h"
#import "Toast+UIView.h"
#import "CommonUtil.h"
#import "MeDetailViewController.h"
#import "MyAccountViewController.h"
#import "ModifyPwdController.h"
#import "VipOrderViewController.h"
#import "MessageCenterViewController.h"
#import "ReserveViewController.h"
#import "VipViewController.h"
#import "MainViewController.h"
#import "HotelSelectViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize rigisterBtn;
@synthesize loginBtn;
@synthesize fogetPwdBtn;
@synthesize autoLoginBtn;
@synthesize checkbox;
@synthesize changeCodeBtn;
@synthesize line1;
@synthesize line2;
@synthesize line3;
@synthesize tipLabel;
@synthesize accountLabel;
@synthesize pwdLabel;
@synthesize codeLabel;
@synthesize pinCode;
@synthesize phone;
@synthesize password;
@synthesize code;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed=YES;
        // 下一个界面的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
        backButton.frame = CGRectMake(0.0, 0.0, 40.0, 27.0);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
    }
    return self;
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    phone.keyboardType = UIKeyboardTypeNumberPad;
    password.keyboardType = UIKeyboardTypeAlphabet;
    password.secureTextEntry = YES;
    code.keyboardType = UIKeyboardTypeAlphabet;
    phone.delegate = self;
    password.delegate = self;
    code.delegate = self;
    phone.returnKeyType = UIReturnKeyNext;
    password.returnKeyType = UIReturnKeyNext;
    code.returnKeyType = UIReturnKeyDone;
    self.title=[CommonUtil getStrByKey:@"loginTitle"];
    rigisterBtn = [[UIBarButtonItem alloc] initWithTitle:[CommonUtil getStrByKey:@"register"] style:UIBarButtonItemStyleDone target:self action:@selector(doRigister:)];
    rigisterBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rigisterBtn;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]){
        checkbox.selected = YES;
    }else{
        checkbox.selected = NO;
    }
    [checkbox setImage:[UIImage imageNamed:@"autoLoginNo.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"autoLoginYes.png"] forState:UIControlStateSelected];
    
    loginBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    loginBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.cornerRadius = 3.0f;
    
    
    autoLoginBtn.tintColor = [CommonUtil getColor:@"dcdcdc"];
    changeCodeBtn.tintColor = [CommonUtil getColor:@"00ff00"];
    fogetPwdBtn.tintColor = [CommonUtil getColor:@"dcdcdc"];
    
    line1.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line2.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line3.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    tipLabel.textColor = [CommonUtil getColor:@"666666"];
    changeCodeBtn.tintColor = [CommonUtil getColor:@"09a23e"];
    
    accountLabel.textColor = [CommonUtil getColor:@"969696"];
    pwdLabel.textColor = [CommonUtil getColor:@"969696"];
    codeLabel.textColor = [CommonUtil getColor:@"969696"];
    autoLoginBtn.tintColor = [CommonUtil getColor:@"808080"];
    fogetPwdBtn.tintColor = [CommonUtil getColor:@"808080"];
    
    [phone becomeFirstResponder];
    
    phone.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phone"];
    password.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)doRigister:(id)sender{
    [self.navigationController pushViewController:[[RigisterViewController alloc] initWithNibName:@"RigisterViewController" bundle:nil] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)fogetPassword:(id)sender {
    [self.navigationController pushViewController:[[FogetPasswordViewController alloc] initWithNibName:@"FogetPasswordViewController" bundle:nil] animated:YES];
}
- (IBAction)autoLogin:(UIButton*)button {
    checkbox.selected=!checkbox.selected;
}
- (IBAction)checkboxDoClick:(UIButton*)button {
    button.selected=!button.selected;
}
- (IBAction)changeCode:(id)sender {
    [pinCode change];
    [pinCode setNeedsDisplay];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(phone.isFirstResponder){
        [password becomeFirstResponder];
    }else if(password.isFirstResponder){
        [code becomeFirstResponder];
    }else if(code.isFirstResponder){
        [code resignFirstResponder];
    }
    return YES;
}

- (IBAction)login:(id)sender {
    
    //if(![CommonUtil isMobileNumber:phone.text]){
    if(phone.text.length<=0||[phone.text isEqualToString:@""]||(phone.text==nil)){
        [self.view makeToast:[CommonUtil getStrByKey:@"accountEmpty"] duration:1.5f position:@"center"];
        return;
    }
    if(![CommonUtil checkPassword:password.text]){
        [self.view makeToast:[CommonUtil getStrByKey:@"passwordError"] duration:1.0f position:@"center"];
        return;
    }
    if(![[[pinCode getContent] uppercaseString] isEqualToString:[code.text uppercaseString]]){
        [self.view makeToast:[CommonUtil getStrByKey:@"pCodeError"] duration:1.0f position:@"center"];
        return;
    }
    NSDictionary *attributes = @{
                                 @"phone":phone.text,
                                 @"password":password.text
                                 };
    [[AppLogic sharedInstance] login:attributes success:^{
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"loginSuccess"]];
        if(true){
            //return;
        }
        if(checkbox.selected){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:phone.text forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:password.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setDouble:[[[NSDate alloc] init] timeIntervalSince1970] forKey:@"loginTime"];
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
        }
        
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"] isEqualToString:phone.text]){
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"phone"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        }
        
        //[AppLogic sharedInstance].loginSucessPhone = phone.text;
        //[AppLogic sharedInstance].loginSuccessPassword = password.text;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        switch ([AppLogic sharedInstance].loginSuccessWillGoViewTag) {
            case 0:
                [self.navigationController pushViewController:[[MeDetailViewController alloc] initWithNibName:@"MeDetailViewController" bundle:nil] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil] animated:YES];
                break;
            case 3:
                [self.navigationController pushViewController:[[ModifyPwdController alloc] initWithNibName:@"ModifyPwdController" bundle:nil] animated:YES];
                break;
            case 4:
                [self.navigationController pushViewController:[[VipOrderViewController alloc] initWithNibName:@"VipOrderViewController" bundle:nil] animated:YES];
                break;
            case 5:
                [self.navigationController pushViewController:[[MessageCenterViewController alloc] initWithNibName:@"MessageCenterViewController" bundle:nil] animated:YES];
                break;
            case 6:
                [self.navigationController popToRootViewControllerAnimated:YES];
                break;
            case 7:
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[VipViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
                break;
            case 999:
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[MainViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
                break;
            case 8:
                [self.navigationController pushViewController:[[HotelSelectViewController alloc] initWithNibName:@"HotelSelectViewController" bundle:nil] animated:YES];
                break;
            default:
                break;
        }
        //[self.navigationController popToRootViewControllerAnimated:YES];
    } fail:^(NSString *message) {
        [self.view makeToast:message duration:1.5f position:@"center"];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    [super viewWillDisappear:animated];
}
@end
