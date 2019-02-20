//
//  ChargeViewController.h
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChargeViewController : BaseViewController<UITextFieldDelegate>{
}
@property (weak, nonatomic) IBOutlet UIButton *checkbox1;
- (IBAction)checkBoxClick1:(UIButton*)btn;
@property (weak, nonatomic) IBOutlet UIButton *checkbox2;
- (IBAction)checkBoxClick2:(UIButton*)btn;
@property (weak, nonatomic) IBOutlet UIButton *chekbox3;
- (IBAction)checkBoxClick3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIView *line1;

@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UITextField *chargeText;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
