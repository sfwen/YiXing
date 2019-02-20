//
//  LevelUpCell.m
//  easyTravel
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LevelUpCell.h"
#import "CommonUtil.h"

@implementation LevelUpCell

@synthesize orderNoTitle;
@synthesize orderNo;
@synthesize date;
@synthesize orderTipTitle;
@synthesize orderTip;
@synthesize payPriceTitle;
@synthesize payPrice;
@synthesize topLine;
@synthesize midLine;
@synthesize bottomLine;

- (void)awakeFromNib {
    //self.backgroundColor = [UIColor whiteColor];
    // Initialization code
    orderNoTitle.textColor = [CommonUtil getColor:@"aaa9aa"];
    orderNo.textColor = [CommonUtil getColor:@"aaa9aa"];
    date.textColor = [CommonUtil getColor:@"aaa9aa"];
    payPriceTitle.backgroundColor = [CommonUtil getColor:@"4ac9e6"];
    payPriceTitle.textColor = [UIColor whiteColor];
    payPrice.textColor = [CommonUtil getColor:@"fc7838"];
    
    orderTipTitle.textColor = [CommonUtil getColor:@"444444"];
    orderTip.textColor = [CommonUtil getColor:@"444444"];
    
    topLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    midLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    bottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data{
    NSDate *payTime = [[NSDate alloc] initWithTimeIntervalSince1970:[[data valueForKeyPath:@"pay_time"] integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    date.text = [formatter stringFromDate:payTime];
    
    
    orderNo.text = [data valueForKeyPath:@"vo_number"];
    orderTip.text = [data valueForKeyPath:@"vo_describe"];
    payPrice.text = [NSString stringWithFormat:@"￥%d",[[data valueForKeyPath:@"vo_money"] intValue]];
    
}

@end
