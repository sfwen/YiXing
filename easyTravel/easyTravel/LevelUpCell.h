//
//  LevelUpCell.h
//  easyTravel
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelUpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *payPriceTitle;
@property (weak, nonatomic) IBOutlet UILabel *payPrice;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *orderNoTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *orderTipTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderTip;
@property (weak, nonatomic) IBOutlet UIView *midLine;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;


-(void)setData:(NSDictionary *)data;

@end
