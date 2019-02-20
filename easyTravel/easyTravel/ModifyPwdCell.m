//
//  ModifyPwdCell.m
//  easyTravel
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ModifyPwdCell.h"
#import "CommonUtil.h"


@implementation ModifyPwdCell

@synthesize cellTextField;
@synthesize cellTitle;
@synthesize drawLine;
@synthesize delegate;


-(id)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

- (void)awakeFromNib {
    // Initialization code
    cellTitle.textColor = [CommonUtil getColor:@"9a9a9a"];
    cellTextField.textColor = [CommonUtil getColor:@"9a9a9a"];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    drawLine = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    drawLine.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:drawLine];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    if([delegate respondsToSelector:@selector(modifyCellTouch:)]){
        [delegate modifyCellTouch:(int)self.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    drawLine.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
