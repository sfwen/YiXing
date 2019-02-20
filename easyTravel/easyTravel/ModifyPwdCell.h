//
//  ModifyPwdCell.h
//  easyTravel
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@protocol ModifyPwdCellDelegate <NSObject>
-(void)modifyCellTouch:(int)tag;
@end

@interface ModifyPwdCell : UITableViewCell

@property(assign,nonatomic) id<ModifyPwdCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UITextField *cellTextField;

@property(strong,nonatomic)CellDraw *drawLine;
@end
