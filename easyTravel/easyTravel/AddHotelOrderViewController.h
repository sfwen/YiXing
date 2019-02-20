//
//  TestViewController.h
//  easyTravel
//
//  Created by cg on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseNumView.h"
#import "SelectDateViewController.h"

@interface AddHotelOrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ChooseNumDelegate,SetDateDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) ChooseNumView *chooseNumView;








@property(nonatomic,copy)NSString* ArrivalDate;
@property(nonatomic,copy)NSString* DepartureDate;

@property(nonatomic,assign)int days;
@property(nonatomic,copy)NSString* starDateStr;//简写开始时间只包含月和日
@property(nonatomic,copy)NSString* endDateStr;//简写结束时间只包含月和日
@property (nonatomic , copy)NSString *dayDateStr;
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期
@property(nonatomic,copy)NSString *hName;//酒店名字
@property(nonatomic,copy)NSString *ratePlanName;
@property(nonatomic,copy)NSString *bedType;

@property(nonatomic,assign)float singleMoney;




@property(nonatomic,copy)NSString *HotelId;
@property(nonatomic,copy)NSString *RoomTypeId;
@property(nonatomic,copy)NSString *RatePlanId;
@property(nonatomic,copy)NSString *CustomerType;
@property(nonatomic,copy)NSString *PaymentType;
@property(nonatomic,copy)NSString *CurrencyCode;

@property(nonatomic,copy)NSString *roomType;//房型


@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *address;



@end
