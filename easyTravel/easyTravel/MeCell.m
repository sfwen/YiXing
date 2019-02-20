//
//  MeCell.m
//  easyTravel
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MeCell.h"

@implementation MeCell


@synthesize imgIcon;
@synthesize rowTitle;
@synthesize rightArrow;
@synthesize flag;
@synthesize cellDraw;

- (void)awakeFromNib {
    flag.hidden = YES;
    // Initialization code
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
