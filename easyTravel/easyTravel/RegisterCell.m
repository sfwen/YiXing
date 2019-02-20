//
//  RegisterCell.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegisterCell.h"
#import "CommonUtil.h"

@implementation RegisterCell

@synthesize title;
@synthesize text;
@synthesize cellDraw;
@synthesize sendMsgCodeBtn;
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
    title.textColor = [CommonUtil getColor:@"9d9d9d"];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];
    
    sendMsgCodeBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    sendMsgCodeBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    sendMsgCodeBtn.layer.borderWidth = 1.0f;
    sendMsgCodeBtn.layer.cornerRadius = 6.0f;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)sendMessage:(UIButton*)sender {
    if ([delegate respondsToSelector:@selector(senMsg:)]) {
        [delegate senMsg:sender];
    }
}
@end
