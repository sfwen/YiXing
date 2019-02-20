//
//  HotelSelectViewController.m
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HotelSelectViewController.h"
#import "CommonUtil.h"
#import "HotelSearchViewController.h"
#import "SelectDestinationViewController.h"
#import "CityViewController.h"
#import "HotelDetailViewController.h"
#import "AppLogic.h"
#import "HotelCellModel.h"
#import "LDCalendarView.h"
#import "NSDate+Extend.h"

@interface HotelSelectViewController (){
    NSMutableArray *dataArray;
    int page;
    int selectDateFlag;
    NSNumber *_obj3;
    NSString *_sring;
    CGFloat _a;
    NSTimeInterval  _interval0;
    NSTimeInterval  _interval1;
    UILabel * _labelx ;
}

@property (nonatomic, strong)LDCalendarView    *calendarView;//日历控件
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期

@property (nonatomic, copy)NSString *showStr;

@end

@implementation HotelSelectViewController

- (NSString *)showStr {
    NSMutableString *str = [NSMutableString string];
    
    
    //    NSLog(@"%@",str);
    //从小到大排序
    [self.seletedDays sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        NSLog(@"%@",obj1);
        NSLog(@"%@",obj2);
        //        _obj3 = obj2 - obj1;
        
        return [obj1 compare:obj2];
        
    }];
    
    int i = 0;
//    NSTimeInterval interval0 = 0.0, interval1 = 0.0;
    _interval0 = 0.0;
    _interval1 = 0.0;
    for (NSNumber *interval in self.seletedDays) {
        NSString *partStr = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"yyyy.MM.dd"];
        if (i == 0) {
            _interval0 = interval.doubleValue;
            NSLog(@"1**8%@",partStr);
            [str appendFormat:@"%@",partStr ];
            _starDateStr = partStr;
            _startDateLabel.text = partStr;
            self.startStr = _startDateLabel.text;
            i ++;
            [str appendString:@"\n\r"];
        } else {
            _interval1 = interval.doubleValue;
            NSLog(@"2***8%@",partStr);
            [str appendFormat:@"%@",partStr];
            _endDateStr = partStr;
            _endDateLabel.text = partStr;
            self.endStr = _endDateLabel.text;
            [str appendString:@"\r"];
        }
        
        //        NSLog(@"%@",partStr);
    }
    
    _a = (_interval1 - _interval0) / 24 / 3600 / 1000;
    _labelx.text = [NSString stringWithFormat:@"%.f 晚",_a ];
    self.dayStr = _labelx.text;
    NSLog(@"%@-----",self.dayStr);
    NSLog(@"%.0f", _a);
    NSLog(@"%@ ----%@",_starDateStr,_endDateStr);
    HotelDetailViewController *hvc = [[HotelDetailViewController alloc]init];
    hvc.dayStr = _labelx.text;
    NSLog(@"%@",hvc.dayStr);
    return [str copy];
}

//-(void)viewWillDisappear:(BOOL)animated{
//    HotelDetailViewController *hvc = [[HotelDetailViewController alloc]init];
//    hvc.dayStr = _labelx.text;
//    
//}
-(void)viewWillAppear:(BOOL)animated{
    _labelx.text = @"1 晚";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cityCode = @"0101";
    _cityName = @"北京";
    page = 0;
    selectDateFlag = 1;
    dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.title=@"酒店";
    self.view.backgroundColor = [CommonUtil getColor:@"F3F3F3'"];
    self.seprateLine1.backgroundColor = [CommonUtil getColor:@"EDEDED"];
    self.seprateLine2.backgroundColor = [CommonUtil getColor:@"EDEDED"];
    self.seprateLine3.backgroundColor = [CommonUtil getColor:@"EDEDED"];
    _queryBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    _queryBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    _queryBtn.layer.borderWidth = 1.0f;
    _queryBtn.layer.cornerRadius = 6.0f;
    
    _startDate = [[NSDate alloc] init];
    _endDate = [[NSDate alloc] init];
    
      _labelx= [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3 * 2, 160, 100, 30)];
//    labelx.backgroundColor = [UIColor redColor];
    [self.view addSubview:_labelx];
    
   
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy.MM.dd"];
//    _startDateLabel.text = [formatter stringFromDate:_startDate];

    //明天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    _endDate = newdate;
//    [adcomps setDay:1];
    NSDate *newdate2 = [calendar dateByAddingComponents:adcomps toDate:newdate options:0];
     _startDateLabel.text = [formatter stringFromDate:newdate];
//    _endDateLabel.text = [formatter stringFromDate:newdate];
    _endDateLabel.text = [formatter stringFromDate:newdate2];
    
    _days = (int)[CommonUtil getDaysFrom:newdate To:newdate2];
    
//    _dayDateLabel.text = @"共 1 晚";
    _dayDateLabel.text = [NSString stringWithFormat:@"共 %d 晚",_days];
    
    NSDateFormatter *willConvertFormatter = [[NSDateFormatter alloc] init] ;
    [willConvertFormatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    NSString *_ArrivalDateStr = [willConvertFormatter stringFromDate:newdate];
    NSString *_DepartureDateStr = [willConvertFormatter stringFromDate:newdate2];
    
    
    
    NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
    [innerFormatter setDateFormat:@"yyyy.MM.dd"];
    _starDateStr = [innerFormatter stringFromDate:newdate];
    _endDateStr = [innerFormatter stringFromDate:newdate2];
    
    _days = 1;
    
    //初始化时间
    _ArrivalDate = [self getYiLongDateStrIII:_ArrivalDateStr];
    _DepartureDate = [self getYiLongDateStrIII:_DepartureDateStr];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed=YES;
        // 下一个界面的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
        backButton.frame = CGRectMake(0.0, 0.0, 40.0, 27.0);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
    }
    return self;
}

- (void)back:(id)sender{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table View DataSource And Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *orderListCellIdentifier = @"orderListCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderListCellIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderListCellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        
//        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2.png"]];
//        icon.frame = CGRectMake(10,10,100,80);
//        [cell.contentView addSubview:icon];
//        
//        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 12, 200, 30)];
//        nameLabel.text = @"";
//        nameLabel.tag = 2;
//        nameLabel.textColor=[CommonUtil getColor:@"555555"];
//        nameLabel.font = [UIFont systemFontOfSize:16];
//        [cell.contentView addSubview:nameLabel];
//        
//        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 80, 30)];
//        yLabel.text = @"¥";
//        yLabel.textColor=[CommonUtil getColor:@"999999"];
//        yLabel.font = [UIFont systemFontOfSize:16];
//        [cell.contentView addSubview:yLabel];
//        
//        UILabel *ruzhuXinQi = [[UILabel alloc] initWithFrame:CGRectMake(140, 60, 80, 30)];
//        ruzhuXinQi.text = @"622";
//        ruzhuXinQi.tag = 1;
//        ruzhuXinQi.textColor=[CommonUtil getColor:@"F94E02"];
//        ruzhuXinQi.font = [UIFont systemFontOfSize:17];
//        [cell.contentView addSubview:ruzhuXinQi];
//        
//        UILabel *likaiDate = [[UILabel alloc] initWithFrame:CGRectMake(180, 60, 80, 30)];
//        likaiDate.text = @"起";
//        likaiDate.textColor=[CommonUtil getColor:@"999999"];
//        likaiDate.font = [UIFont systemFontOfSize:16];
//        [cell.contentView addSubview:likaiDate];
//        
//        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow.png"]];
//        rightArrow.frame = CGRectMake(340,50,12,12);
//        [cell.contentView addSubview:rightArrow];
//        
//    }
//    HotelCellModel *model = [dataArray objectAtIndex:indexPath.row];
//    UILabel *moneyLabel = (UILabel*)[cell.contentView viewWithTag:1];
//    moneyLabel.text = [NSString stringWithFormat:@"%@",model.LowRate];
//    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:2];
//    nameLabel.text = [NSString stringWithFormat:@"%@",model.HotelName];
//    
//    if(model.HotelName==nil){
//        NSDictionary *data = @{
//                               @"Local": @"zh_CN",
//                               @"Request": @{
//                                       @"ArrivalDate": _ArrivalDate,
//                                       @"DepartureDate":_DepartureDate,
//                                       @"HotelIds": model.HotelId,
//                                       @"Options": @"1,2,3,4,5",
//                                       @"PaymentType": @"SelfPay",
//                                       @"RatePlanId": @317996,
//                                       @"RoomTypeId": @"0006",
//                                       },
//                               @"Version": @1.1
//                               };
//        NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
//        [[AppLogic sharedInstance] gethotelCellNameAndImage:postDatas row:(int)indexPath.row success:^(NSString *name,int row) {
//            ((HotelCellModel*)[dataArray objectAtIndex:row]).HotelName=name;
//            //[self.tableView reloadData];
//            nameLabel.text = name;
//        } fail:^(NSString *message) {
//            
//        }];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarCell"];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)view;
            if (lab.tag == 2) {
                lab.text = nil;
            }
        }
    }
    UILabel *showLab= (UILabel *)[cell.contentView viewWithTag:100.0];
    UILabel *label= [[UILabel alloc]initWithFrame:CGRectMake(230, 30, 40, 30)];
    label.tag = 2;
    if (self.seletedDays.count) {
        showLab.text = self.showStr;
        //        NSLog(@"%@",showLab.text);
        label.text = [NSString stringWithFormat:@"%.f晚",_a];
        [cell.contentView addSubview:label];
        
        //        [cell.contentView]
    }

    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HotelCellModel *model = [dataArray objectAtIndex:indexPath.row];
//    HotelDetailViewController *hotelDetailViewController = [[HotelDetailViewController alloc] initWithNibName:@"HotelDetailViewController" bundle:nil];
//    hotelDetailViewController.hotelID = model.HotelId;
//    hotelDetailViewController.ArrivalDate = _ArrivalDate;
//    hotelDetailViewController.DepartureDate = _DepartureDate;
//    [self.navigationController pushViewController:hotelDetailViewController animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //日期选择
//    if (!_calendarView) {
//        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//        [self.view addSubview:_calendarView];
//        
//        __weak typeof(self) weakSelf = self;
//        _calendarView.complete = ^(NSArray *result) {
//            if (result) {
//                weakSelf.seletedDays = [result mutableCopy];
//                [tableView reloadData];
//            }
//        };
//    }
//    [self.calendarView show];
//    self.calendarView.defaultDates = _seletedDays;

}


- (IBAction)query:(id)sender {
    HotelSearchViewController *hotelSearchViewController = [[HotelSearchViewController alloc] initWithNibName:@"HotelSearchViewController" bundle:nil];
    hotelSearchViewController.ArrivalDate=_ArrivalDate;
    hotelSearchViewController.DepartureDate=_DepartureDate;
    hotelSearchViewController.cityCode=_cityCode;
    hotelSearchViewController.cityName = _cityName;
    hotelSearchViewController.starDateStr=_starDateStr;
    hotelSearchViewController.endDateStr=_endDateStr;
    hotelSearchViewController.dayDateStr = _labelx.text;
    
    NSLog(@"%@",hotelSearchViewController.dayDateStr);
    hotelSearchViewController.days = _days;
    hotelSearchViewController.searchKeyword = _searcheText.text;
    hotelSearchViewController.seletedDays = _seletedDays;
    [self.navigationController pushViewController:hotelSearchViewController animated:YES];
}
- (IBAction)selectDestination:(id)sender {
//    SelectDestinationViewController *selectDestinationViewController = [[SelectDestinationViewController alloc] initWithNibName:@"SelectDestinationViewController" bundle:nil];
//    [self.navigationController pushViewController:selectDestinationViewController animated:YES];
    CityViewController *cityViewController = [[CityViewController alloc] initWithNibName:@"CityViewController" bundle:nil];
    cityViewController.delegate=self;
    [self.navigationController pushViewController:cityViewController animated:YES];
}

-(void)selectCity:(NSString *)name cityCode:(NSString *)cityCode{
    NSLog(@"你选择的城市的名字是___%@",name);
    _cityLabel.text = name;
    self.cityName = name;
    self.cityCode = cityCode;
}


- (IBAction)selectArrivate:(id)sender{
//    SelectDateViewController *dateTimeViewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
//    dateTimeViewController.delegate=self;
//    dateTimeViewController.mode=1;
//    selectDateFlag = 1;
//    [self.navigationController pushViewController:dateTimeViewController animated:YES];
    if (!_calendarView) {
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [self.view addSubview:_calendarView];
        __weak typeof(self) weakSelf = self;
        _calendarView.complete = ^(NSArray *result) {
            if (result) {
                weakSelf.seletedDays = [result mutableCopy];
                [weakSelf updateDate];
            }
        };
    }
    [self.calendarView show];
    self.calendarView.defaultDates = _seletedDays;
//    [self selectDepartureDate:0];
    
}

- (IBAction)selectDepartureDate:(id)sender{
//    SelectDateViewController *dateTimeViewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
//    dateTimeViewController.delegate=self;
//    dateTimeViewController.mode=1;
//    dateTimeViewController.arrivalDateStr = _ArrivalDate;
//   selectDateFlag = 2;
//    [self.navigationController pushViewController:dateTimeViewController animated:YES];
   
    if (!_calendarView) {
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [self.view addSubview:_calendarView];
//        selectDateFlag = 2;
        __weak typeof(self) weakSelf = self;
        _calendarView.complete = ^(NSArray *result) {
            if (result) {
                weakSelf.seletedDays = [result mutableCopy];
                [weakSelf updateDate];
            }
        };
    }
    [self.calendarView show];
    self.calendarView.defaultDates = _seletedDays;
   
}

- (void)updateDate {
    [self showStr];
}

//-(void)selectDate:(NSString *)dateStr{
//    //_ArrivalDate = @"2015-11-8T00:00:00+18:00";
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//    NSDate *originDateTime=[formatter dateFromString:dateStr];
//    
//    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
//    [formatter2 setDateFormat:@"yyyy-MM-dd"];
//    [formatter3 setDateFormat:@"hh:mm"];
//    NSString *str1 = [formatter2 stringFromDate:originDateTime];
////    NSString *str2 = [formatter3 stringFromDate:originDateTime];
//    
//    //NSString *lastDateTimeStr = [NSString stringWithFormat:@"%@T00:00:00+%@",str1,str2];
//    
//    if(selectDateFlag==1){
//        _ArrivalDate = self.showStr;
//        NSLog(@"----------%@--------",self.showStr);
//        _startDateLabel.text = self.showStr;
//        _startDate = originDateTime;
//        
//        NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
//        [innerFormatter setDateFormat:@"yyyy-MM-dd"];
//        _starDateStr = [innerFormatter stringFromDate:originDateTime];
//        NSLog(@"入住时间是___%@___%@",_starDateStr,_ArrivalDate);
//    }else if(selectDateFlag==2){
//        _DepartureDate = self.showStr;
//        _endDateLabel.text = self.showStr;
//        _endDate = originDateTime;
//        NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
//        [innerFormatter setDateFormat:@"yyyy-MM-dd"];
//        _endDateStr = [innerFormatter stringFromDate:originDateTime];
//        NSLog(@"离开时间是___%@___%@",_endDateStr,_DepartureDate);
//    }
//   _days = [CommonUtil getDaysFrom:_startDate To:_endDate];
//    NSLog(@"一共有几天____%d",_days);
//}
//
//-(NSString*)getYiLongDateStr:(NSString*)dateStr{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *originDateTime=[formatter dateFromString:dateStr];
//    
//    
//    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
//    [formatter2 setDateFormat:@"yyyy-MM-dd"];
//    [formatter3 setDateFormat:@"hh:mm"];
//    NSString *str1 = [formatter2 stringFromDate:originDateTime];
//    NSString *str2 = [formatter3 stringFromDate:originDateTime];
//    
//    NSString *lastDateTimeStr = [NSString stringWithFormat:@"%@T00:00:00+%@",str1,str2];
//    
//    return lastDateTimeStr;
//
//}


-(NSString*)getYiLongDateStrIII:(NSString*)dateStr{//初始化的时候调用
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    NSDate *originDateTime=[formatter dateFromString:dateStr];
    
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
    [formatter2 setDateFormat:@"yyyy.MM.dd"];
    [formatter3 setDateFormat:@"hh:mm"];
    NSString *str1 = [formatter2 stringFromDate:originDateTime];
   // NSString *str2 = [formatter3 stringFromDate:originDateTime];
    
    //NSString *lastDateTimeStr = [NSString stringWithFormat:@"%@T00:00:00+%@",str1,str2];
    
    return str1;
    
}




@end
