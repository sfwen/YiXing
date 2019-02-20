//
//  HotelOrderDetailViewController.h
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HotelOrderDetailViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIView *bottomArea;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)btnClick:(id)sender;


@property(nonatomic,strong)NSDictionary *detailInfo;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *startAndEndDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zaocangLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;





@property(nonatomic,assign)int currentTab;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)diaPhone:(id)sender;
@end
