//
//  MessageCenterTableViewCell.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"
#import "Msg.h"

@interface MessageCenterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property(strong,nonatomic)CellDraw *cellDraw;

@property(strong,nonatomic)Msg *cellData;

-(void)setData:(Msg*)data;

@end
