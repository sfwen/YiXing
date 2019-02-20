//
//  WithDrawCashToAliPayController.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WithDrawCashToBankViewController.h"
#import "CommonUtil.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "MyAccountViewController.h"

@interface WithDrawCashToBankViewController (){
    NSTimer *timer;
}
@end

@implementation WithDrawCashToBankViewController

@synthesize line1;
@synthesize line2;
@synthesize line3;
@synthesize moneyContent;
@synthesize moneyTitle;
@synthesize confirmBtn;

@synthesize moneyLabel;
@synthesize moneyText;
@synthesize bankLabel;
@synthesize bankText;
@synthesize accountLabel;
@synthesize accountText;
@synthesize nameLabel;
@synthesize nameText;


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
    
    moneyLabel.textColor = [CommonUtil getColor:@"4a4a4a"];
    bankLabel.textColor = [CommonUtil getColor:@"4a4a4a"];
    accountLabel.textColor = [CommonUtil getColor:@"4a4a4a"];
    nameLabel.textColor = [CommonUtil getColor:@"4a4a4a"];
    moneyText.textColor = [CommonUtil getColor:@"888888"];
    bankText.textColor = [CommonUtil getColor:@"888888"];
    accountText.textColor = [CommonUtil getColor:@"888888"];
    
    
    moneyText.keyboardType = UIKeyboardTypeDecimalPad;
    bankText.keyboardType = UIKeyboardTypeDefault;
    accountText.keyboardType = UIKeyboardTypeNumberPad;
    nameText.keyboardType = UIKeyboardTypeDefault;
    
    moneyText.delegate = self;
    bankText.delegate = self;
    accountText.delegate = self;
    nameText.delegate = self;
    
    moneyText.returnKeyType = UIReturnKeyNext;
    bankText.returnKeyType = UIReturnKeyNext;
    accountText.returnKeyType = UIReturnKeyNext;
    nameText.returnKeyType = UIReturnKeyDone;
    
    
    self.title=[CommonUtil getStrByKey:@"withDrawBankTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    line1.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line2.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line3.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    moneyTitle.textColor = [CommonUtil getColor:@"4a4a4a"];
    moneyContent.textColor = [CommonUtil getColor:@"fd682b"];
    
    
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 3.0f;
    // Do any additional setup after loading the view from its nib.
    
    moneyContent.text = [NSString stringWithFormat:@"%.2f元",[AppLogic sharedInstance].myMoney];
}

- (void)getMoneyTimer:(NSTimer*)theTimer{
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 };
    [[AppLogic sharedInstance] getMoney:attributes success:^{
        moneyContent.text = [NSString stringWithFormat:@"%.2f元",[AppLogic sharedInstance].myMoney];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getMoneyTimer:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(moneyText.isFirstResponder){
        [bankText becomeFirstResponder];
    }else if(bankText.isFirstResponder){
        [accountText becomeFirstResponder];
    }else if(accountText.isFirstResponder){
        [nameText becomeFirstResponder];
    }else if(nameText.isFirstResponder){
       [nameText resignFirstResponder];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (IBAction)confirm:(id)sender {
    
    if(![CommonUtil checkMoney:moneyText.text]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawCashError"]];
        return;
    }
    if([moneyText.text doubleValue]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawLessThanZero"]];
        return;
    }
    
    if([moneyText.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawEmpty"]];
        return;
    }
    if([bankText.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawBankNameEmpty"]];
        return;
    }
    if([accountText.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawBankAccountEmpty"]];
        return;
    }
    
    if(![CommonUtil checkBankAccount:accountText.text]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawBankAccountError"]];
        return;
    }
    if([nameText.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"nameEmpty"]];
        return;
    }
    
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"uw_type":[NSNumber numberWithInt:2],
                                 @"money":moneyText.text,
                                 @"uw_bank":bankText.text,
                                 @"uw_bank_card":accountText.text,
                                 @"uw_name":nameText.text,
                                 };
    
    [[AppLogic sharedInstance] withDrawCash:attributes success:^{
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"withDrawSuccess"]];
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[MyAccountViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
    
}


@end
