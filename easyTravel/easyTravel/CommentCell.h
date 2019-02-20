//
//  CommentCell.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property(strong,nonatomic) NSDictionary *cellData;

@property(strong,nonatomic)CellDraw *cellDraw;

//@property(strong,nonatomic)NSLayoutConstraint *heightConstraint;

-(void)setData:(NSDictionary *)data;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@end
