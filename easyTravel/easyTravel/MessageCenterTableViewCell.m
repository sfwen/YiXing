//
//  MessageCenterTableViewCell.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MessageCenterTableViewCell.h"
#import "CommonUtil.h"

@implementation MessageCenterTableViewCell

@synthesize title;
@synthesize content;
@synthesize date;
@synthesize time;
@synthesize cellDraw;
@synthesize cellData;
@synthesize icon;

- (void)awakeFromNib {
    // Initialization code
    //NSLog(@"cell size is %@", NSStringFromCGSize(self.contentView.bounds.size));
    title.textColor = [CommonUtil getColor:@"333333"];
    content.textColor = [CommonUtil getColor:@"bababa"];
    date.textColor = [CommonUtil getColor:@"bdbdbd"];
    time.textColor = [CommonUtil getColor:@"bdbdbd"];
    
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled = NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];
}

-(void)setData:(Msg*)data{
    self.cellData = data;
    
    NSDate *createDate = [[NSDate alloc] initWithTimeIntervalSince1970:[self.cellData.create_time integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    date.text = [formatter stringFromDate:createDate];
    
    NSDateFormatter * formatterTime = [[NSDateFormatter alloc]init];
    [formatterTime setDateFormat:@"hh:mm"];
    time.text = [formatterTime stringFromDate:createDate];
    
    content.text = self.cellData.content;
    title.text = self.cellData.title;
    
    if(self.cellData.is_read==1){
        icon.image = [UIImage imageNamed:@"oldMessage.png"];
    }else{
        icon.image = [UIImage imageNamed:@"newMessage.png"];
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
