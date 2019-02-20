//
//  VipLobbyCell.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VipLobbyCell.h"
#import "CommonUtil.h"
#import "Common.h"
#import "UIImageView+AFNetworking.h"

@implementation VipLobbyCell

@synthesize title;
@synthesize rmbLabel;
@synthesize image;
@synthesize cellData;
@synthesize cellDraw;

- (void)awakeFromNib {
    // Initialization code
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 3.0;
    image.layer.borderWidth = 0.5;
    image.layer.borderColor = [UIColor clearColor].CGColor;
    rmbLabel.textColor = [CommonUtil getColor:@"fd682b"];
    //self.backgroundColor=[UIColor redColor];
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


-(void)setData:(NSDictionary *)data{
    self.cellData = data;
    title.text = [self.cellData valueForKeyPath:@"goods_name"];
    rmbLabel.text = [NSString stringWithFormat:@"￥%@起",[self.cellData valueForKeyPath:@"goods_price"]];
    
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,[self.cellData valueForKeyPath:@"goods_image"]]] placeholderImage:[UIImage imageNamed:@"image.jpg"]];
}


@end
