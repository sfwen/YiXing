//
//  PayViewController.m
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PayViewController.h"
#import "LeftPayViewController.h"
#import "CommonUtil.h"
#import "AppLogic.h"
#import "Toast+UIView.h"
#import "VipOrderViewController.h"
#import "VipViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "APAuthV2Info.h"
#import "DataVerifier.h"
#import "UPPayViewController.h"
#import "LevelUpViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface PayViewController ()

@end

@implementation PayViewController

@synthesize checkbox1;
@synthesize checkbox2;
@synthesize checkbox3;
@synthesize line;
@synthesize line1;
@synthesize confirmBtn;
@synthesize moneyContent;
@synthesize moneyTitle;
@synthesize tip1;
@synthesize tip2;
@synthesize tip3;
@synthesize leftPayBtn;
@synthesize payPrice;
@synthesize goods_name;
@synthesize payType;
@synthesize vipType;
@synthesize payTypeContainer;



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
    self.title=[CommonUtil getStrByKey:@"payTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line1.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    moneyTitle.textColor = [CommonUtil getColor:@"4a4a4a"];
    moneyContent.textColor = [CommonUtil getColor:@"fd682b"];
    checkbox1.selected = YES;
    checkbox2.selected = NO;
    checkbox3.selected = NO;
    [checkbox1 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [checkbox2 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [checkbox3 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox3 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 3.0f;
    
    tip1.textColor = [CommonUtil getColor:@"dcdcdc"];
    tip2.textColor = [CommonUtil getColor:@"dcdcdc"];
    tip3.textColor = [CommonUtil getColor:@"dcdcdc"];
    
    leftPayBtn.tintColor = [CommonUtil getColor:@"dcdcdc"];
    moneyContent.text = [NSString stringWithFormat:@"￥%.2f",payPrice];
    // Do any additional setup after loading the view from its nib.
    
    
    if(payPrice<=0){
        payTypeContainer.hidden = YES;
        confirmBtn.hidden = YES;
    }
    
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

- (IBAction)checkBoxClick1:(UIButton*)btn {
    btn.selected=!btn.selected;
    if(btn.selected){
        checkbox2.selected = NO;
        checkbox3.selected = NO;
    }
}
- (IBAction)checkBoxClick2:(UIButton*)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        checkbox1.selected = NO;
        checkbox3.selected = NO;
    }
}
- (IBAction)checkBoxClick3:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        checkbox1.selected = NO;
        checkbox2.selected = NO;
    }
}
- (IBAction)confirm:(id)sender {
    if(checkbox1.selected){
        
        
        if(payType==PAY_TYPE_NORMAL){
            Order *order = [[Order alloc] init];
            order.partner = pId;
            order.seller = sId;
            //order.tradeNO = @"115"; //订单ID（由商家自行制定）
            order.tradeNO = [AppLogic sharedInstance].order_number;
            order.productName =goods_name; //商品标题
            order.productDescription = goods_name; //商品描述
            order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
            //order.notifyURL =  @"http://www.xxx.com"; //回调URL
            order.notifyURL =  [NSString stringWithFormat:@"%@%@",HOST,ALI_PAY_CALLBACK];
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"easyTravel";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            //NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(pKey);
            NSString *signedString = [signer signString:orderSpec];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    if([[resultDic valueForKeyPath:@"resultStatus"] intValue]==9000){
                        NSString *resultString = [resultDic valueForKeyPath:@"result"];
                        NSRange range = [resultString rangeOfString:@"success=\"true\""];
                        if(range.length>0){
                            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliPaySuccess"]];
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
                            
                            
                        }else{
                            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliPayFail"]];
                        }
                    }else{
                        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliPayFail"]];
                    }
                }];
            }
        }else if(payType==PAY_TYPE_VIP){
            /*
            if(vipType==VIP_TYPE_NORMAL){
                [[AppLogic sharedInstance] makeToast:@"普通VIP"];
            }else if(vipType==VIP_TYPE_DIAMOND){
                [[AppLogic sharedInstance] makeToast:@"砖石VIP"];
            }*/
            NSDictionary *attributes = @{
                                         @"vo_type":[NSNumber numberWithInt:vipType],
                                         @"ucode":[AppLogic sharedInstance].ucode
                                         };
            [[AppLogic sharedInstance] buyVipWithAlipay:attributes success:^(NSDictionary *data) {
                //NSLog(@"%@",data);
                NSString *vo_number = [data valueForKeyPath:@"vo_number"];
                NSString *vo_money = [data valueForKeyPath:@"vo_money"];
                
                Order *order = [[Order alloc] init];
                order.partner = pId;
                order.seller = sId;
                //order.tradeNO = @"115"; //订单ID（由商家自行制定）
                order.tradeNO = vo_number;
                order.productName =goods_name; //商品标题
                order.productDescription = goods_name; //商品描述
                order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
                //order.amount = vo_money;
                //order.notifyURL =  @"http://www.xxx.com"; //回调URL
                order.notifyURL =  [NSString stringWithFormat:@"%@%@",HOST,BUY_VIP_ALIPAY_CALLBACK];
                order.service = @"mobile.securitypay.pay";
                order.paymentType = @"1";
                order.inputCharset = @"utf-8";
                order.itBPay = @"30m";
                order.showUrl = @"m.alipay.com";
                
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                NSString *appScheme = @"easyTravel";
                
                //将商品信息拼接成字符串
                NSString *orderSpec = [order description];
                //NSLog(@"orderSpec = %@",orderSpec);
                
                //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                id<DataSigner> signer = CreateRSADataSigner(pKey);
                NSString *signedString = [signer signString:orderSpec];
                
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = nil;
                if (signedString != nil) {
                    orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                   orderSpec, signedString, @"RSA"];
                    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                        NSLog(@"reslut = %@",resultDic);
                        if([[resultDic valueForKeyPath:@"resultStatus"] intValue]==9000){
                            NSString *resultString = [resultDic valueForKeyPath:@"result"];
                            NSRange range = [resultString rangeOfString:@"success=\"true\""];
                            if(range.length>0){
                                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliPaySuccess"]];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                                
                                for (UIViewController *temp in self.navigationController.viewControllers) {
                                    if ([temp isKindOfClass:[LevelUpViewController class]]) {
                                        
                                        
                                        [self.navigationController popToViewController:temp animated:NO];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                                    }
                                }
                                
                                
                            }else{
                                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliPayFail"]];
                            }
                        }else{
                            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliPayFail"]];
                        }
                    }];
                }
            } fail:^(NSString *message) {
                [[AppLogic sharedInstance] makeToast:message];
            }];
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }else if (checkbox2.selected) {
        //NSLog(@"银联卡支付");
        
        
        
        if(payType==PAY_TYPE_NORMAL){
            NSDictionary *attributes = @{
                                         @"ucode":[AppLogic sharedInstance].ucode,
                                         @"order_no":[AppLogic sharedInstance].order_number,
                                         };
            [[AppLogic sharedInstance] getBankPayTN:attributes success:^(NSString* tn){
                //[[AppLogic sharedInstance] makeToast:tn];
                UPPayViewController *upPayViewController = [[UPPayViewController alloc] initWithNibName:@"UPPayViewController" bundle:nil];
                upPayViewController.tn = tn;
                [self.navigationController pushViewController:upPayViewController animated:NO];
            } fail:^(NSString *message) {
                [[AppLogic sharedInstance] makeToast:message];
            }];
        }else if(payType==PAY_TYPE_VIP){
            NSDictionary *attributes = @{
                                         @"vo_type":[NSNumber numberWithInt:vipType],
                                         @"ucode":[AppLogic sharedInstance].ucode
                                         };
            
            [[AppLogic sharedInstance] buyVipWithBank:attributes success:^(NSDictionary *data) {
                //NSLog(@"%@data",data);
                NSString *orderId = [data valueForKeyPath:@"orderId"];
                UPPayViewController *upPayViewController = [[UPPayViewController alloc] initWithNibName:@"UPPayViewController" bundle:nil];
                upPayViewController.tn = orderId;
                [self.navigationController pushViewController:upPayViewController animated:NO];
            } fail:^(NSString *message) {
                [[AppLogic sharedInstance] makeToast:message];
            }];
        }
    } else {
        if (payType == PAY_TYPE_NORMAL) {
            NSDictionary *attributes = @{
                                         @"ucode":[AppLogic sharedInstance].ucode,
                                         @"order_no":[AppLogic sharedInstance].order_number,
                                         };
            [[AppLogic sharedInstance] weChatNormalPay:attributes success:^(NSDictionary *data) {
//                NSLog(@"heh");
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = [data valueForKeyPath:@"partnerid"];
                request.prepayId = [data valueForKeyPath:@"prepayid"];
                request.package = [data valueForKeyPath:@"package"];
                request.timeStamp = [[data valueForKeyPath:@"timestamp"] intValue];
                request.sign = [data valueForKeyPath:@"sign"];
                request.nonceStr = [data valueForKeyPath:@"noncestr"];
                [WXApi sendReq:request];
            } fail:^(NSString *message) {
                [[AppLogic sharedInstance] makeToast:message];
            }];
        } else if (payType == PAY_TYPE_VIP) {
            NSDictionary *attributes = @{
                                         @"ucode":[AppLogic sharedInstance].ucode,
                                         @"order_no":[AppLogic sharedInstance].order_number,
                                         };
            [[AppLogic sharedInstance] wechatVipPay:attributes success:^(NSDictionary *data) {
//                NSLog(@"hhe");
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = [data valueForKeyPath:@"partnerid"];
                request.prepayId = [data valueForKeyPath:@"prepayid"];
                request.package = [data valueForKeyPath:@"package"];
                request.timeStamp = [[data valueForKeyPath:@"timestamp"] intValue];
                request.sign = [data valueForKeyPath:@"sign"];
                request.nonceStr = [data valueForKeyPath:@"noncestr"];
                [WXApi sendReq:request];

            } fail:^(NSString *message) {
                [[AppLogic sharedInstance] makeToast:message];
            }];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                [[AppLogic sharedInstance] makeToast:@"支付成功"];
                break;
            case WXErrCodeUserCancel:
                [[AppLogic sharedInstance] makeToast:@"用户取消"];
                break;
            default:
                [[AppLogic sharedInstance] makeToast:@"支付失败"];
                break;
        }
    }
}



#pragma mark UPPayPluginResult

- (IBAction)leftPay1:(id)sender {
    LeftPayViewController *leftPayViewController = [[LeftPayViewController alloc] initWithNibName:@"LeftPayViewController" bundle:nil];
    leftPayViewController.payPrice = payPrice;
    leftPayViewController.payType = payType;
    leftPayViewController.vipType = vipType;
    [self.navigationController pushViewController:leftPayViewController animated:YES];
}
- (IBAction)leftPay2:(id)sender{
    LeftPayViewController *leftPayViewController = [[LeftPayViewController alloc] initWithNibName:@"LeftPayViewController" bundle:nil];
    leftPayViewController.payPrice = payPrice;
    leftPayViewController.payType = payType;
    leftPayViewController.vipType = vipType;
    [self.navigationController pushViewController:leftPayViewController animated:YES];
}

@end
