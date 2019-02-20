//
//  OrderNeedPayCell.m
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OrderNeedPayCell.h"
#import "CommonUtil.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"

@implementation OrderNeedPayCell

@synthesize payBtn;
@synthesize deleteBtn;
@synthesize rmbLabel;
@synthesize dateLabel;
@synthesize rmb;
@synthesize date;
@synthesize image;
@synthesize title;
@synthesize commentBtn;
@synthesize applyForMoneyBackBtn;
@synthesize confirmUseBtn;
@synthesize statusLabel;
@synthesize delegate;
@synthesize cellData;
@synthesize cellDraw;
@synthesize deleteOverBtn;

-(void)setData:(NSDictionary*)data:(int)tag{//pay_status 支付状态：   1： 未支付  2： 付款中 3： 已支付
    
    deleteBtn.hidden = YES;
    payBtn.hidden = YES;
    commentBtn.hidden = YES;
    applyForMoneyBackBtn.hidden = YES;
    confirmUseBtn.hidden = YES;
    statusLabel.hidden = YES;
    deleteOverBtn.hidden = YES;
    
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,[data valueForKeyPath:@"goods_image"]]] placeholderImage:[UIImage imageNamed:@"image.jpg"]];
    
    
    deleteBtn.tag = tag;
    payBtn.tag = tag;
    commentBtn.tag = tag;
    applyForMoneyBackBtn.tag = tag;
    confirmUseBtn.tag = tag;
    deleteOverBtn.tag = tag;
    self.cellData = data;
    title.text = [self.cellData valueForKeyPath:@"goods_name"];
    rmb.text = [self.cellData valueForKeyPath:@"buy_price"];//buy_price  goods_price
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateString = [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:[[self.cellData valueForKeyPath:@"use_time"] doubleValue]]];
    date.text=dateString;
    
    
    if([[self.cellData valueForKeyPath:@"apply_status"] intValue]==1){// 1:无申请状态  2：申请退款   3:退款成功  4：退款失败
        if([[self.cellData valueForKeyPath:@"pay_status"] intValue]==1){//支付状态：   1： 未支付  2： 付款中 3： 已支付
            deleteBtn.hidden=NO;
            payBtn.hidden=NO;
            commentBtn.hidden = YES;
            statusLabel.hidden = YES;
        }else if([[self.cellData valueForKeyPath:@"pay_status"] intValue]==3){
            payBtn.hidden=YES;
            if([[self.cellData valueForKeyPath:@"is_over"] intValue]==1){//1:完成  2:未完成
                confirmUseBtn.hidden = YES;
                statusLabel.hidden = NO;
                statusLabel.text = @"已完成";
                deleteOverBtn.hidden = NO;
            }else{
                if([[self.cellData valueForKeyPath:@"hav_status"] intValue]==1){// 1: 未发货  2：发货中   3：已收货
                    applyForMoneyBackBtn.hidden=NO;
                    confirmUseBtn.hidden = NO;
                    statusLabel.hidden = YES;
                }else{
                    confirmUseBtn.hidden = YES;
                }
                if([[self.cellData valueForKeyPath:@"is_contents"] intValue]==1){//1： 评论 2：未评论
                    commentBtn.hidden=YES;
                }else{
                    commentBtn.hidden=NO;
                }
                if(!confirmUseBtn.hidden){//如果是待确认，那么就不能评价
                    commentBtn.hidden=YES;
                }
            }
        }
    }else if([[self.cellData valueForKeyPath:@"apply_status"] intValue]==2){
        statusLabel.hidden = NO;
        statusLabel.text = @"退款审核中";
    }else if([[self.cellData valueForKeyPath:@"apply_status"] intValue]==3){
        if([[self.cellData valueForKeyPath:@"is_over"] intValue]==1){//1:完成  2:未完成
            statusLabel.hidden = NO;
            statusLabel.text = @"退款成功";
            deleteOverBtn.hidden = NO;
        }
    }else if([[self.cellData valueForKeyPath:@"apply_status"] intValue]==4){
        if([[self.cellData valueForKeyPath:@"is_over"] intValue]==1){//1:完成  2:未完成
            statusLabel.hidden = NO;
            statusLabel.text = @"退款失败";
            deleteOverBtn.hidden = NO;
        }
    }
}

- (void)awakeFromNib {
    // Initialization code
    payBtn.layer.borderColor = [CommonUtil getColor:@"fe6569"].CGColor;
    payBtn.backgroundColor = [CommonUtil getColor:@"fe6569"];
    payBtn.layer.borderWidth = 1.0f;
    payBtn.layer.cornerRadius = 3.0f;
    payBtn.tintColor = [UIColor whiteColor];
    
    
    deleteBtn.layer.borderColor = [CommonUtil getColor:@"fa8777"].CGColor;
    deleteBtn.backgroundColor = [CommonUtil getColor:@"ffffff"];
    deleteBtn.layer.borderWidth = 1.0f;
    deleteBtn.layer.cornerRadius = 3.0f;
    deleteBtn.tintColor = [CommonUtil getColor:@"fa8777"];
    
    deleteOverBtn.layer.borderColor = [CommonUtil getColor:@"fa8777"].CGColor;
    deleteOverBtn.backgroundColor = [CommonUtil getColor:@"ffffff"];
    deleteOverBtn.layer.borderWidth = 1.0f;
    deleteOverBtn.layer.cornerRadius = 3.0f;
    deleteOverBtn.tintColor = [CommonUtil getColor:@"fa8777"];
    
    title.textColor = [CommonUtil getColor:@"333433"];
    rmbLabel.textColor = [CommonUtil getColor:@"adadad"];
    rmb.textColor = [CommonUtil getColor:@"adadad"];
    dateLabel.textColor = [CommonUtil getColor:@"adadad"];
    date.textColor = [CommonUtil getColor:@"adadad"];
    
    
    commentBtn.layer.borderColor = [CommonUtil getColor:@"fa8777"].CGColor;
    commentBtn.backgroundColor = [CommonUtil getColor:@"ffffff"];
    commentBtn.layer.borderWidth = 1.0f;
    commentBtn.layer.cornerRadius = 3.0f;
    commentBtn.tintColor = [CommonUtil getColor:@"fa8777"];
    
    applyForMoneyBackBtn.layer.borderColor = [CommonUtil getColor:@"fa8777"].CGColor;
    applyForMoneyBackBtn.backgroundColor = [CommonUtil getColor:@"ffffff"];
    applyForMoneyBackBtn.layer.borderWidth = 1.0f;
    applyForMoneyBackBtn.layer.cornerRadius = 3.0f;
    applyForMoneyBackBtn.tintColor = [CommonUtil getColor:@"fa8777"];
    
    
    confirmUseBtn.layer.borderColor = [CommonUtil getColor:@"fe6569"].CGColor;
    confirmUseBtn.backgroundColor = [CommonUtil getColor:@"fe6569"];
    confirmUseBtn.layer.borderWidth = 1.0f;
    confirmUseBtn.layer.cornerRadius = 3.0f;
    confirmUseBtn.tintColor = [UIColor whiteColor];
    
    statusLabel.textColor = [CommonUtil getColor:@"dcdcdc"];
    
    
    
    deleteBtn.hidden = YES;
    payBtn.hidden = YES;
    commentBtn.hidden = YES;
    applyForMoneyBackBtn.hidden = YES;
    confirmUseBtn.hidden = YES;
    statusLabel.hidden = YES;
    deleteOverBtn.hidden = YES;
    
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];
    
    image.layer.masksToBounds = YES;
    image.layer.cornerRadius = 2.0;
    image.layer.borderWidth = 0.5;
    image.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setNeedsDisplay];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


- (IBAction)deleteOrder:(UIButton*)sender {
    if ([delegate respondsToSelector:@selector(deleteOrder:)]) {
        [delegate deleteOrder:sender];
    }
}

- (IBAction)payOrder:(UIButton*)sender {
    if ([delegate respondsToSelector:@selector(payOrder:)]) {
        [delegate payOrder:sender];
    }
}

- (IBAction)toComment:(id)sender {
    if ([delegate respondsToSelector:@selector(toComment:)]) {
        [delegate toComment:sender];
    }
}


- (IBAction)confirmUseClick:(id)sender {
    if ([delegate respondsToSelector:@selector(confirmUse:)]) {
        [delegate confirmUse:sender];
    }
}

- (IBAction)applyForMoneyBackClick:(id)sender {
    if ([delegate respondsToSelector:@selector(applyForMoneyBack:)]) {
        [delegate applyForMoneyBack:sender];
    }
}
- (IBAction)deleteOver:(id)sender {
    if ([delegate respondsToSelector:@selector(deleteOver:)]) {
        [delegate deleteOver:sender];
    }
}
@end
