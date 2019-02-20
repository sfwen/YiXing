//
//  HotelSearchViewController.h
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HotelSearchViewController : BaseViewController


@property(nonatomic,copy)NSString* ArrivalDate;
@property(nonatomic,copy)NSString* DepartureDate;
@property(nonatomic,copy)NSString *cityCode;
@property(nonatomic,copy)NSString *cityName;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,assign)int days;
@property(nonatomic,copy)NSString* starDateStr;//简写开始时间只包含月和日
@property(nonatomic,copy)NSString* endDateStr;//简写结束时间只包含月和日
@property(nonatomic,strong)NSString* dayDateStr; //总共多少天
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期

@property(nonatomic,copy)NSString* searchKeyword;

@end
