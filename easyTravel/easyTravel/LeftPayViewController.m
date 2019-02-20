//
//  LeftPayViewController.m
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LeftPayViewController.h"
#import "CommonUtil.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "VipOrderViewController.h"
#import "VipViewController.h"
#import "VipOrderViewController.h"
#import "LevelUpViewController.h"

@interface LeftPayViewController (){
    NSTimer *timer;
}

@end

@implementation LeftPayViewController

@synthesize confirmBtn;
@synthesize text1;
@synthesize text2;
@synthesize payPrice;
@synthesize payType;
@synthesize vipType;


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
    self.title=[CommonUtil getStrByKey:@"leftPayTitle"];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 3.0f;
    
    text1.enabled = NO;
    text2.enabled = NO;
    text1.text = [NSString stringWithFormat:@"%.2f元",[AppLogic sharedInstance].myMoney];
    text2.text = [NSString stringWithFormat:@"%.2f元",payPrice];
    
}

- (void)getMoneyTimer:(NSTimer*)theTimer{
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 };
    [[AppLogic sharedInstance] getMoney:attributes success:^{
        text1.text = [NSString stringWithFormat:@"%.2f元",[AppLogic sharedInstance].myMoney];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)confirm:(id)sender {
    if(payPrice>[AppLogic sharedInstance].myMoney){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notEnoughLeftMoney"]];
        return;
    }
    
    
    if(payType==PAY_TYPE_NORMAL){
        NSDictionary *attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"order_number":[AppLogic sharedInstance].order_number,
                                     };
        [[AppLogic sharedInstance] leftPay:attributes success:^{
            [AppLogic sharedInstance].myMoney-= payPrice;
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"leftPaySuccess"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[VipOrderViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[VipViewController class]]) {
                    [self.navigationController popToViewController:temp animated:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                }
            }
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }else if(payType==PAY_TYPE_VIP){
        NSDictionary *attributes = @{
                                     @"vo_type":[NSNumber numberWithInt:vipType],
                                     @"ucode":[AppLogic sharedInstance].ucode
                                     };
        
        [[AppLogic sharedInstance] buyVipWithLeftMoney:attributes success:^(NSDictionary *data) {
            //NSLog(@"%@",data);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[LevelUpViewController class]]) {
                    [self.navigationController popToViewController:temp animated:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                }
            }
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }
    
    
    
}
@end
