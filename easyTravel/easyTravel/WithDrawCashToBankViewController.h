//
//  WithDrawCashToBankViewController.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WithDrawCashToBankViewController : BaseViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *moneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *moneyContent;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;

@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirm:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyText;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UITextField *bankText;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountText;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameText;

@property (weak, nonatomic) IBOutlet UIView *line3;

@end
