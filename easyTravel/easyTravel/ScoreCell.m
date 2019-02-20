//
//  ScoreCell.m
//  easyTravel
//
//  Created by apple on 15/8/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ScoreCell.h"
#import "CommonUtil.h"

@implementation ScoreCell

@synthesize title;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize scoreLabel;
@synthesize cellDraw;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    scoreLabel.textColor = [CommonUtil getColor:@"f9662a"];
    title.textColor = [CommonUtil getColor:@"333433"];
    dateLabel.textColor = [CommonUtil getColor:@"666666"];
    timeLabel.textColor = [CommonUtil getColor:@"666666"];
    // Configure the view for the selected state
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}



-(void)setData:(NSDictionary *)data{//ui_title //ui_integral
    NSDate *create_time = [[NSDate alloc] initWithTimeIntervalSince1970:[[data valueForKeyPath:@"create_time"] integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateLabel.text = [formatter stringFromDate:create_time];
    [formatter setDateFormat:@"hh:mm"];
    timeLabel.text = [formatter stringFromDate:create_time];
    title.text = [NSString stringWithFormat:@"%@",[data valueForKeyPath:@"ui_title"]];
    scoreLabel.text = [NSString stringWithFormat:@"+%@",[data valueForKeyPath:@"ui_integral"]];
    /*
    date.text = [formatter stringFromDate:payTime];
    
    
    orderNo.text = [data valueForKeyPath:@"vo_number"];
    orderTip.text = [data valueForKeyPath:@"vo_describe"];
    payPrice.text = [NSString stringWithFormat:@"￥%d",[[data valueForKeyPath:@"vo_money"] intValue]];*/
    
}

@end
