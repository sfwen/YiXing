//
//  PayViewController.h
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "ViewWithBorder.h"

@interface PayViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *moneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *moneyContent;

@property (weak, nonatomic) IBOutlet UIButton *checkbox1;
- (IBAction)checkBoxClick1:(UIButton*)btn;
@property (weak, nonatomic) IBOutlet UIButton *checkbox2;
- (IBAction)checkBoxClick2:(UIButton*)btn;
@property (weak, nonatomic) IBOutlet UIButton *checkbox3;
- (IBAction)checkBoxClick3:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UILabel *tip1;
@property (weak, nonatomic) IBOutlet UILabel *tip2;
@property (weak, nonatomic) IBOutlet UILabel *tip3;
- (IBAction)leftPay1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *leftPayBtn;
- (IBAction)leftPay2:(id)sender;
@property(assign,nonatomic) double payPrice;

@property(strong,nonatomic) NSString* goods_name;

@property(assign,nonatomic)PAY_TYPE payType;
@property(assign,nonatomic)VIP_TYPE vipType;

@property (weak, nonatomic) IBOutlet ViewWithBorder *payTypeContainer;
@end
