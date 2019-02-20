//
//  MeCell.h
//  easyTravel
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@interface MeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *flag;
@property (weak, nonatomic) IBOutlet UILabel *rowTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property(strong,nonatomic)CellDraw *cellDraw;

@end
