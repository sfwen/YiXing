//
//  MoneyBackListCell.m
//  easyTravel
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoneyBackListCell.h"
#import "Common.h"
#import "CommonUtil.h"

@implementation MoneyBackListCell

@synthesize draw;


- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    draw = [[MoneyBackListCellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*2):@"":@"":@""];
    draw.backgroundColor = [UIColor clearColor];
    [self addSubview:draw];
}

- (void)setLabelText:(NSString*)text1:(NSString*)text2:(NSString*)text3{
    draw.text1 = text1;
    draw.text2 = text2;
    draw.text3 = text3;
    [draw setNeedsDisplay];
}

@end
