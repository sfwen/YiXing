//
//  LeftPayViewController.h
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Common.h"

@interface LeftPayViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property(assign,nonatomic) double payPrice;


@property(assign,nonatomic)PAY_TYPE payType;
@property(assign,nonatomic)VIP_TYPE vipType;

@end
