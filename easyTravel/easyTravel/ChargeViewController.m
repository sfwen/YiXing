//
//  ChargeViewController.m
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ChargeViewController.h"
#import "CommonUtil.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "APAuthV2Info.h"
#import "Common.h"
#import "AppLogic.h"
#import "Toast+UIView.h"
#import "DataVerifier.h"
#import "ChargeFromBankViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface ChargeViewController ()

@end

@implementation ChargeViewController

@synthesize checkbox1;
@synthesize checkbox2;
@synthesize chekbox3;
@synthesize line;
@synthesize line1;
@synthesize confirmBtn;
@synthesize chargeLabel;
@synthesize chargeText;
@synthesize tipLabel;


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
    // Do any additional setup after loading the view from its nib.
    self.title = [CommonUtil getStrByKey:@"chargetViewTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line1.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    checkbox1.selected = YES;
    checkbox2.selected = NO;
    chekbox3.selected = NO;
    [checkbox1 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [checkbox2 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [chekbox3 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [chekbox3 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    
    
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 3.0f;
    
    
    tipLabel.textColor = [CommonUtil getColor:@"dcdcdc"];
    chargeText.returnKeyType = UIReturnKeyDone;
    chargeText.delegate = self;
    chargeText.keyboardType = UIKeyboardTypeDecimalPad;
    [chargeText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkBoxClick1:(UIButton*)btn {
    btn.selected=!btn.selected;
    if(btn.selected){
        checkbox2.selected = NO;
        chekbox3.selected = NO;
    }
}
- (IBAction)checkBoxClick2:(UIButton*)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        checkbox1.selected = NO;
        chekbox3.selected = NO;
    }
}
- (IBAction)checkBoxClick3:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected ) {
        checkbox1.selected = NO;
        checkbox2.selected = NO;
    }
}
- (IBAction)confirm:(id)sender {
    if(checkbox1.selected){
        
        
        if([chargeText.text length]<=0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"chargeMountEmpty"]];
            return;
        }
        
        if(![CommonUtil checkMoney:chargeText.text]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"chargeError"]];
            return;
        }
        
        if([chargeText.text doubleValue]<=0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"chargeAmountError"]];
            return;
        }
        
        
        
        
        NSDictionary *attributes = @{
                               @"ucode":[AppLogic sharedInstance].ucode,
                               //@"r_money":chargeText.text,
                               @"r_money":[NSNumber numberWithDouble:0.01f],
                               @"pay_type":[NSNumber numberWithInt:10],
                               };
        [[AppLogic sharedInstance] inCharge:attributes success:^(NSDictionary *chargeData) {
            //产生订单号码!
            Order *order = [[Order alloc] init];
            order.partner = pId;
            order.seller = sId;
            order.tradeNO = [chargeData valueForKeyPath:@"r_number"]; //订单ID（由商家自行制定）
            order.productName = [CommonUtil getStrByKey:@"chargetTitle"]; //商品标题
            order.productDescription = [NSString stringWithFormat:[CommonUtil getStrByKey:@"chargeContent"],chargeText.text]; //商品描述
            order.amount = [NSString stringWithFormat:@"%.2f",[chargeText.text doubleValue]]; //商品价格
            //order.notifyURL =  @"http://www.xxx.com"; //回调URL
            order.notifyURL =  [NSString stringWithFormat:@"%@%@",HOST,CHARGE_CALL_BACK];
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
                            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliChargeSuccess"]];
                            [AppLogic sharedInstance].myMoney += [chargeText.text doubleValue];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMyMoney" object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliChargeFail"]];
                        }
                    }else{
                        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"aliChargeFail"]];
                    }
                }];
            }
            
            
            
            
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
        
        
        
        
        
        
    } else if (checkbox2.selected) {
        //NSLog(@"银联卡充值");
        NSDictionary *attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"r_money":[NSString stringWithFormat:@"%.2f",[chargeText.text doubleValue]],
                                     };
        [[AppLogic sharedInstance] inChargeFromBank:attributes success:^(NSDictionary *chargeData){
            ChargeFromBankViewController *chargeFromBankViewController = [[ChargeFromBankViewController alloc] initWithNibName:@"ChargeFromBankViewController" bundle:nil];
            chargeFromBankViewController.tn = [chargeData valueForKey:@"orderId"];
            [self.navigationController pushViewController:chargeFromBankViewController animated:NO];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
        
    } else {
        
        if([chargeText.text length]<=0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"chargeMountEmpty"]];
            return;
        }
        
        if(![CommonUtil checkMoney:chargeText.text]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"chargeError"]];
            return;
        }
        
        if([chargeText.text doubleValue]<=0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"chargeAmountError"]];
            return;
        }
        
        NSDictionary *attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"r_money":[NSString stringWithFormat:@"%.2f",[chargeText.text doubleValue]],
                                     };
        [[AppLogic sharedInstance] weChatInCharge:attributes success:^(NSDictionary *chargeData) {
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [chargeData valueForKeyPath:@"partnerid"];
            request.prepayId = [chargeData valueForKeyPath:@"prepayid"];
            request.package = [chargeData valueForKeyPath:@"package"];
            request.timeStamp = [[chargeData valueForKeyPath:@"timestamp"] intValue];
            request.sign = [chargeData valueForKeyPath:@"sign"];
            request.nonceStr = [chargeData valueForKeyPath:@"noncestr"];
            [WXApi sendReq:request];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }
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

@end
