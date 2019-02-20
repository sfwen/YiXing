//
//  ReserveViewController.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "SelectDateViewController.h"
#import "BaseViewController.h"

@interface ReserveViewController : BaseViewController<SetDateDelegate,UITextFieldDelegate>

@property(strong,nonatomic) NSString *goods_normal_price;
@property(strong,nonatomic) NSString *goods_vip_price;


@property (weak, nonatomic) IBOutlet UIButton *goToPayBtn;
- (IBAction)goToPay:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPrice;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
- (IBAction)minus:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *personNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
- (IBAction)plus:(id)sender;
- (IBAction)chooseDateBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet CustomTextField *date;
@property (weak, nonatomic) IBOutlet CustomTextField *name;
@property (weak, nonatomic) IBOutlet CustomTextField *telephone;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UIView *selectDateView;

@end
