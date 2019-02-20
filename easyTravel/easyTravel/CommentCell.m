//
//  CommentCell.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CommentCell.h"
#import "CommonUtil.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Extension.h"
#import "Common.h"

@implementation CommentCell

@synthesize name;
@synthesize date;
@synthesize content;
@synthesize img1;
@synthesize img2;
@synthesize img3;
@synthesize cellData;
@synthesize cellDraw;
//@synthesize heightConstraint;

@synthesize contentBottomMargin;
@synthesize imageHeight;

- (void)awakeFromNib {
    // Initialization code
    name.textColor = [UIColor blackColor];
    date.textColor = [CommonUtil getColor:@"abaaab"];
    content.textColor = [CommonUtil getColor:@"686868"];
    //self.backgroundColor=[UIColor redColor];
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];
    
    /*
    heightConstraint = [NSLayoutConstraint constraintWithItem:img1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:80];
    [img1 addConstraint:heightConstraint];*/
    
    
    if(IS_IPHONE_6P){
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:[self bounds].size.width+40];
        [content addConstraint:widthConstraint];
    }else if(IS_IPHONE_6){
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:[self bounds].size.width+40];
        [content addConstraint:widthConstraint];
    }else if(IS_IPHONE_5){
        if(IS_RETINA){
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:[self bounds].size.width-10];
            [content addConstraint:widthConstraint];
        }else{
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:[self bounds].size.width-10];
            [content addConstraint:widthConstraint];
        }
    }else{
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:content attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:nil multiplier:1 constant:[self bounds].size.width-10];
        [content addConstraint:widthConstraint];
    }
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(NSDictionary *)data{//create_time//goods_image//
    NSDate *createDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[data valueForKeyPath:@"create_time"] integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    date.text = [formatter stringFromDate:createDate];
    self.cellData = data;
    
    //sevaluation_image1 sevaluation_image2 sevaluation_image3
    if([[data valueForKeyPath:@"sevaluation_image1"] length]==0){
        img1.image = [UIImage imageNamed:@"empty.png"];
        imageHeight.constant = 0;
        contentBottomMargin.constant = -5;
        //img1.hidden = YES;
    }else{
        //img1.hidden = NO;
        imageHeight.constant = 80;
        contentBottomMargin.constant = -85;
        NSString *imageUrl = [NSString stringWithFormat:@"http://%@",[data valueForKeyPath:@"sevaluation_image1"]];
        [img1 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
    }
    if([[data valueForKeyPath:@"sevaluation_image2"] length]==0){
        img2.image = [UIImage imageNamed:@"empty.png"];
        //img2.hidden = YES;
    }else{
        //img2.hidden = NO;
        NSString *imageUrl = [NSString stringWithFormat:@"http://%@",[data valueForKeyPath:@"sevaluation_image2"]];
        [img2 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
    }
    if([[data valueForKeyPath:@"sevaluation_image3"] length]==0){
        img3.image = [UIImage imageNamed:@"empty.png"];
        //img3.hidden = YES;
    }else{
        //img3.hidden = NO;
        //NSString *imageUrl = [data valueForKeyPath:@"sevaluation_image3"];
        NSString *imageUrl = [NSString stringWithFormat:@"http://%@",[data valueForKeyPath:@"sevaluation_image3"]];
        [img3 setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"image1.jpg"]];
    }
    //nack_name real_name
    /*
    NSDictionary *userinfo = [self.cellData valueForKeyPath:@"userinfo"];
    if(![[userinfo description] isEqualToString:@""] && userinfo!=nil){
        NSString *realName = [userinfo valueForKeyPath:@"real_name"];
        name.text = realName;
    }*/
    name.text = [self.cellData valueForKeyPath:@"username"];
    //username
    content.text = [NSString decodeFromPercentEscapeString:[self.cellData valueForKeyPath:@"content"]];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
