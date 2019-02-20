//
//  HotelSelectViewController.h
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityViewController.h"
#import "SelectDateViewController.h"

@interface HotelSelectViewController : UIViewController<CitySelectDelegate,SetDateDelegate>

@property (weak, nonatomic) IBOutlet UIView *seprateLine1;
@property (weak, nonatomic) IBOutlet UIView *seprateLine2;
@property (weak, nonatomic) IBOutlet UIView *seprateLine3;
- (IBAction)query:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)selectDestination:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityCode;

@property(nonatomic,copy)NSString* ArrivalDate;
@property(nonatomic,copy)NSString* DepartureDate;

- (IBAction)selectArrivate:(id)sender;
- (IBAction)selectDepartureDate:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayDateLabel;
@property (strong , nonatomic) NSString * dayStr;
@property (strong , nonatomic) NSString * startStr;
@property (strong , nonatomic) NSString * endStr;
@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;





@property(nonatomic,assign)int days;
@property(nonatomic,copy)NSString* starDateStr;//简写开始时间只包含月和日
@property(nonatomic,copy)NSString* endDateStr;//简写结束时间只包含月和日

@property (weak, nonatomic) IBOutlet UITextField *searcheText;
@end
