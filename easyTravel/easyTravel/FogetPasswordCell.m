//
//  RegisterCell.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FogetPasswordCell.h"
#import "CommonUtil.h"

@implementation FogetPasswordCell

@synthesize title;
@synthesize text;
@synthesize cellDraw;

- (void)awakeFromNib {
    // Initialization code
    title.textColor = [CommonUtil getColor:@"9d9d9d"];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];
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
