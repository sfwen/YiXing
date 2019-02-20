//
//  MoneyBackListCell.h
//  easyTravel
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyBackListCellDraw.h"

@interface MoneyBackListCell : UITableViewCell



@property(strong,nonatomic)MoneyBackListCellDraw *draw;


- (void)setLabelText:(NSString*)text1:(NSString*)text2:(NSString*)text3;

@end
