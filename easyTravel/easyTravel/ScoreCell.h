//
//  ScoreCell.h
//  easyTravel
//
//  Created by apple on 15/8/30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@interface ScoreCell : UITableViewCell






@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

-(void)setData:(NSDictionary *)data;
@property(strong,nonatomic)CellDraw *cellDraw;

@end
