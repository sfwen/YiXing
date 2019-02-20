//
//  VipLobbyCell.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@interface VipLobbyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property(strong,nonatomic)NSDictionary *cellData;
@property(strong,nonatomic)CellDraw *cellDraw;

-(void)setData:(NSDictionary *)data;
@end
