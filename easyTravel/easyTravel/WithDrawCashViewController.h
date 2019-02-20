//
//  WithDrawCashViewController.h
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrawCashViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *moneyTitle;
@property (weak, nonatomic) IBOutlet UILabel *moneyContent;

@property (weak, nonatomic) IBOutlet UIButton *checkbox1;
- (IBAction)checkBoxClick1:(UIButton*)btn;
@property (weak, nonatomic) IBOutlet UIButton *checkbox2;
- (IBAction)checkBoxClick2:(UIButton*)btn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *line;

@end
