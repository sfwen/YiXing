//
//  LevelUpViewController.m
//  easyTravel
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LevelUpViewController.h"
#import "CommonUtil.h"
#import "PayViewController.h"
#import "AppLogic.h"
#import "Common.h"
#import "LevelUpOrderListViewController.h"

@interface LevelUpViewController (){
    double vip_diamond_money;
    double vip_money;
}
@end

@implementation LevelUpViewController

@synthesize leftGroupText1;
@synthesize leftGroupText2;
@synthesize leftGroupText3;
@synthesize leftGroupText4;
@synthesize leftGroupText5;
@synthesize leftGroupText6;
@synthesize rightGroupText1;
@synthesize rightGroupText2;
@synthesize rightGroupText3;
@synthesize rightGroupText4;
@synthesize rightGroupText5;
@synthesize rightGroupText6;
@synthesize hTopLine;
@synthesize hBottomLine;
@synthesize vLine;
@synthesize btn1;
@synthesize btn2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CommonUtil getStrByKey:@"leveUpTitle"];
    // Do any additional setup after loading the view from its nib.
    [leftGroupText1 setSequence:1 :[[CommonUtil getArrayByKey:@"level1UpTitleArray"] objectAtIndex:0]:@"57c47f"];
    [leftGroupText2 setSequence:2 :[[CommonUtil getArrayByKey:@"level1UpTitleArray"] objectAtIndex:1]:@"57c47f"];
    [leftGroupText3 setSequence:3 :[[CommonUtil getArrayByKey:@"level1UpTitleArray"] objectAtIndex:2]:@"57c47f"];
    [leftGroupText4 setSequence:4 :[[CommonUtil getArrayByKey:@"level1UpTitleArray"] objectAtIndex:3]:@"57c47f"];
    [leftGroupText5 setSequence:5 :[[CommonUtil getArrayByKey:@"level1UpTitleArray"] objectAtIndex:4]:@"57c47f"];
    [leftGroupText6 setSequence:6 :[[CommonUtil getArrayByKey:@"level1UpTitleArray"] objectAtIndex:5]:@"57c47f"];
    
    [rightGroupText1 setSequence:1 :[[CommonUtil getArrayByKey:@"level2UpTitleArray"] objectAtIndex:0]:@"ff8c8f"];
    [rightGroupText2 setSequence:2 :[[CommonUtil getArrayByKey:@"level2UpTitleArray"] objectAtIndex:1]:@"ff8c8f"];
    [rightGroupText3 setSequence:3 :[[CommonUtil getArrayByKey:@"level2UpTitleArray"] objectAtIndex:2]:@"ff8c8f"];
    [rightGroupText4 setSequence:4 :[[CommonUtil getArrayByKey:@"level2UpTitleArray"] objectAtIndex:3]:@"ff8c8f"];
    [rightGroupText5 setSequence:5 :[[CommonUtil getArrayByKey:@"level2UpTitleArray"] objectAtIndex:4]:@"ff8c8f"];
    [rightGroupText6 setSequence:6 :[[CommonUtil getArrayByKey:@"level2UpTitleArray"] objectAtIndex:5]:@"ff8c8f"];
    
    hTopLine.backgroundColor = [CommonUtil getColor:@"a3dae7"];
    hBottomLine.backgroundColor = [CommonUtil getColor:@"a3dae7"];
    vLine.backgroundColor = [CommonUtil getColor:@"a3dae7"];
    
    btn1.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    btn1.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    btn1.layer.borderWidth = 1.0f;
    btn1.layer.cornerRadius = 3.0f;
    
    btn2.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    btn2.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    btn2.layer.borderWidth = 1.0f;
    btn2.layer.cornerRadius = 3.0f;
    
    NSDictionary *attributes = @{
                                 };
    [[AppLogic sharedInstance] getVipMoney:attributes success:^(NSDictionary *data) {
        NSLog(@"%@",data);
        vip_money = [[data valueForKeyPath:@"vip_money"] doubleValue];
        vip_diamond_money = [[data valueForKeyPath:@"vip_diamond_money"] doubleValue];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
    
}

-(void)paySuccess:(NSNotification*) notification{
    LevelUpOrderListViewController *levelUpOrderListViewController = [[LevelUpOrderListViewController alloc] initWithNibName:@"LevelUpOrderListViewController" bundle:nil];
    [self.navigationController pushViewController:levelUpOrderListViewController animated:NO];
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

- (IBAction)level1Up:(id)sender {
    
    
    NSDictionary *attributes = @{
                                 @"phone":[AppLogic sharedInstance].loginSucessPhone,
                                 @"password":[AppLogic sharedInstance].loginSuccessPassword
                                 };
    
    [[AppLogic sharedInstance] login:attributes success:^(){
       
        
        if([AppLogic sharedInstance].vipFlag==1){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"hasBuyVIp"]];
            return;
        }
        if([AppLogic sharedInstance].vipFlag==3){//钻石会员
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isMostVip"]];
            return;
        }
        PayViewController *payViewController = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        payViewController.payType = PAY_TYPE_VIP;
        payViewController.vipType = VIP_TYPE_NORMAL;
        payViewController.goods_name = [CommonUtil getStrByKey:@"aliPayBuyVipName"];
        payViewController.payPrice = vip_money;
        [self.navigationController pushViewController:payViewController animated:YES];
        
    } fail:^(NSString *message) {
       
    }];
    
    
    
    
}

- (IBAction)level2Up:(id)sender {
    NSDictionary *attributes = @{
                                 @"phone":[AppLogic sharedInstance].loginSucessPhone,
                                 @"password":[AppLogic sharedInstance].loginSuccessPassword
                                 };
    [[AppLogic sharedInstance] login:attributes success:^(){
        if([AppLogic sharedInstance].vipFlag==3){//砖石会员
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isMostVip"]];
            return;
        }
        PayViewController *payViewController = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        payViewController.payType = PAY_TYPE_VIP;
        payViewController.vipType = VIP_TYPE_DIAMOND;
        payViewController.goods_name = [CommonUtil getStrByKey:@"aliPayBuyMostVipName"];
        payViewController.payPrice = vip_diamond_money;
        [self.navigationController pushViewController:payViewController animated:YES];
    } fail:^(NSString *message) {
        
    }];
    
    
}
@end
