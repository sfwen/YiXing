//
//  OrderNeedPayCell.h
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@protocol VipOrderCellDelegate <NSObject>
- (void)deleteOrder:(UIButton *)button;
- (void)payOrder:(UIButton *)button;
- (void)toComment:(UIButton *)button;
- (void)applyForMoneyBack:(UIButton *)button;
- (void)confirmUse:(UIButton *)button;
- (void)deleteOver:(UIButton *)button;
@end

@interface OrderNeedPayCell : UITableViewCell


@property (assign, nonatomic) id<VipOrderCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmb;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyForMoneyBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmUseBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)deleteOrder:(UIButton*)sender;

- (IBAction)payOrder:(UIButton*)sender;
- (IBAction)toComment:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *deleteOverBtn;

- (IBAction)deleteOver:(id)sender;


@property(strong,nonatomic) NSDictionary *cellData;
@property(strong,nonatomic)CellDraw *cellDraw;

-(void)setData:(NSDictionary*)data:(int)tag;

- (IBAction)confirmUseClick:(id)sender;
- (IBAction)applyForMoneyBackClick:(id)sender;
@end
