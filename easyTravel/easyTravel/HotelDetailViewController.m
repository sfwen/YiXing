//
//  HotelDetailViewController.m
//  easyTravel
//
//  Created by apple on 15/11/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HotelDetailViewController.h"
#import "CommonUtil.h"
#import "AddHotelOrderViewController.h"
#import "AppLogic.h"
#import <objc/runtime.h>
#import "AppLogic.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoBroswerVC.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import "LDCalendarView.h"
#import "NSDate+Extend.h"
#import "HotelSelectViewController.h"

@interface HotelDetailViewController (){
    NSArray *rooms;
    NSArray *BookingRules;
    NSArray *GuaranteeRules;
    //NSMutableArray *data;
    NSMutableDictionary *expandedDictionary;
    NSArray *locations;
    NSArray *Images;
    UIImageView *bigImageView;
    NSString *HotelName;
    NSString *Address;
     NSString *Phone;
    int selectDateFlag;
    CGFloat _a;
    NSTimeInterval  _interval0;
    NSTimeInterval  _interval1;
    UILabel * _totalNightLabel;
}


@property(nonatomic,strong)MBProgressHUD *HUD;
@property (nonatomic, strong)LDCalendarView    *calendarView;//日历控件


@property (nonatomic, copy)NSString *showStr;


@end

@implementation HotelDetailViewController

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
//    _interval0 = 0.0;
//    _interval1 = 0.0;
    for (NSNumber *interval in self.seletedDays) {
        NSString *partStr = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"yyyy.MM.dd"];
        NSString * string = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"MM.dd"];
        if (i == 0) {
            _ArrivalDate = partStr;
            _starDateStr = string;
            
            _interval0 = interval.doubleValue;
            NSLog(@"1**8%@",partStr);
            [str appendFormat:@"%@",partStr ];
            _starDateStr = partStr;
            i ++;
            [str appendString:@"\n\r"];
        } else {
            _DepartureDate = partStr;
            _endDateStr = string;
            _interval1 = interval.doubleValue;
            NSLog(@"2***8%@",partStr);
            [str appendFormat:@"%@",partStr];
            _endDateStr = partStr;
            [str appendString:@"\r"];
         
        }
        
        //        NSLog(@"%@",partStr);
    }
       _a = (_interval1 - _interval0) / 24 / 3600 / 1000;
//        NSLog(@"%.0f", _a);
//     self.dayStr = [NSString stringWithFormat:@"%.f 晚",_a];
//    _totalNightLabel.text = [NSString stringWithFormat:@"%.f 晚",_a];
   
    
    
    return [str copy];
}


-(MBProgressHUD *)HUD{
    if(_HUD==nil){
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.labelText = @"酒店详情获取中";
        _HUD.detailsLabelText = @"请耐心等待";
        _HUD.square = YES;
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self updateDate];
    NSLog(@"viewDidLoad");
    expandedDictionary = [[NSMutableDictionary alloc] init];
    self.title=@"酒店详情";
    selectDateFlag = 1;
    
    [self showStr];
    
//    _arrivalDateLabel.text = [NSString stringWithFormat:@"入%@",_starDateStr];
//    _apartDateLabel.text = [NSString stringWithFormat:@"离%@",_endDateStr];
//    _allNightLabel.text = [NSString stringWithFormat:@"%d晚",_days];
//    
//    _blackArea.alpha=0.8;
//    self.view.backgroundColor = [CommonUtil getColor:@"F2F2F2"];
//    _adressArea.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
//    _adressArea.layer.borderWidth = 1.0f;
//    _line1.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
//    _line1.layer.borderWidth = 1.0f;
//    _line2BottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
//    _line3BottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
//    _line4BottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    
    
    
    [self.HUD show:YES];
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"ArrivalDate": _ArrivalDate,
                                   @"DepartureDate": _DepartureDate,
                                   @"HotelIds":self.hotelID,
                                   @"Options": @"1,2,3,4,5",
                                   @"PaymentType":@"SelfPay",
                                   },
                           @"Version": @1.1
                           };
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
    [[AppLogic sharedInstance] getHotelDetail:postDatas success:^(NSDictionary* data) {
        [self.HUD hide:YES];
        Images = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Images"];
        HotelName = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
        Address = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        Phone = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Phone"];
//        imagePlayer.pageControl.hidden = YES;
//        imagePlayer.autoScroll=NO;
//        [imagePlayer initWithCount:1 delegate:self];
//        NSString *HotelName = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
//        _hotelNameLabel.text = HotelName;
//        _addressLabel.text = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        rooms = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Rooms"];
        BookingRules = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"BookingRules"];
        GuaranteeRules = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"GuaranteeRules"];
        for(int i=0;i<[rooms count];i++){
            [expandedDictionary setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *message) {
        [self.HUD hide:YES];
    }];

    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    [_tableView setTableHeaderView:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
//    [imageView setImageWithURL:[NSURL URLWithString:[[locations objectAtIndex:index] objectForKey:@"Url"]] placeholderImage:[UIImage imageNamed:@"guide1.png"]];
    bigImageView = imageView;
    NSDictionary * image = [Images objectAtIndex:index];
    
    locations = [image objectForKey:@"Locations"];
    
    [imageView setImageWithURL:[NSURL URLWithString:[[locations objectAtIndex:0] objectForKey:@"Url"]] placeholderImage:[UIImage imageNamed:@"guide1.png"]];
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    //NSLog(@"你点击的是第%d张图片",index);
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:[Images count]];
        for (NSUInteger i = 0; i< [Images count]; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            
            pbModel.mid = i + 1;
            pbModel.title = @"";
            pbModel.desc = @"";
            NSDictionary * image = [Images objectAtIndex:i];
            NSArray *los = [image objectForKey:@"Locations"];
            pbModel.image_HD_U = [[los objectAtIndex:0] objectForKey:@"Url"];
            
            //源frame
            UIImageView *imageV =(UIImageView *)bigImageView;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
    
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ding:(id)sender {
    NSIndexPath *indexPath = objc_getAssociatedObject(sender, "btnParams");
    //NSLog(@"tag__%d__%d",indexPath.section,indexPath.row);
    
    int section = indexPath.section-1;
    
    NSDictionary* RatePlan = [[[rooms objectAtIndex:section] objectForKey:@"RatePlans"] objectAtIndex:indexPath.row];
    NSString *ratePlanName = [RatePlan objectForKey:@"RatePlanName"];
    int singleMoney = [[RatePlan objectForKey:@"TotalRate"] intValue];
    NSString *bedType = [[rooms objectAtIndex:section] objectForKey:@"BedType"];
    
    NSString *GuaranteeRuleIds = [RatePlan objectForKey:@"GuaranteeRuleIds"];
    NSString *PaymentType = [RatePlan objectForKey:@"PaymentType"];//SelfPay-前台自付、Prepay-预付
    
    NSArray *gRuleIds = [GuaranteeRuleIds componentsSeparatedByString:@","];
    
    
    if([self ifNeedGuarantee:gRuleIds]){
        [[AppLogic sharedInstance] makeToast:@"需要担保,暂不支持"];
        return;
    }else{
    }
    
    
    if([GuaranteeRuleIds isEqualToString:@""]&&[PaymentType isEqualToString:@"SelfPay"]){
        //可以先不给钱
    }else{
        //暂时给钱
        //[[AppLogic sharedInstance] makeToast:@"暂时不支持"];
        //return;
    }
    
    
    NSString *RoomTypeId = [RatePlan objectForKey:@"RoomTypeId"];
    NSString *RatePlanId = [RatePlan objectForKey:@"RatePlanId"];
    NSString *CustomerType = [RatePlan objectForKey:@"CustomerType"];
    NSString *CurrencyCode = [RatePlan objectForKey:@"CurrencyCode"];
    
    
    AddHotelOrderViewController *addHotelOrderViewController = [[AddHotelOrderViewController alloc] initWithNibName:@"AddHotelOrderViewController" bundle:nil];
    addHotelOrderViewController.starDateStr = _starDateStr;
    addHotelOrderViewController.endDateStr = _endDateStr;
    if (_a == 0) {
        addHotelOrderViewController.days = _days;
    }else {
        addHotelOrderViewController.days = (int)_a;
    }
    addHotelOrderViewController.ArrivalDate = _ArrivalDate;
    addHotelOrderViewController.DepartureDate = _DepartureDate;
    addHotelOrderViewController.hName =HotelName;
    addHotelOrderViewController.ratePlanName = ratePlanName;
    addHotelOrderViewController.seletedDays = _seletedDays;
    addHotelOrderViewController.bedType = bedType;
    addHotelOrderViewController.singleMoney = singleMoney;
    addHotelOrderViewController.dayDateStr = self.dayStr;
    addHotelOrderViewController.RoomTypeId = RoomTypeId;
    addHotelOrderViewController.RatePlanId = RatePlanId;
    addHotelOrderViewController.CustomerType = CustomerType;
    addHotelOrderViewController.PaymentType = PaymentType;
    addHotelOrderViewController.CurrencyCode = CurrencyCode;
    addHotelOrderViewController.HotelId = self.hotelID;
    addHotelOrderViewController.roomType = [[rooms objectAtIndex:section] objectForKey:@"Name"];
    addHotelOrderViewController.phone=Phone;
    addHotelOrderViewController.address=Address;
 
    [self.navigationController pushViewController:addHotelOrderViewController animated:YES];
    
}


#pragma mark -
#pragma mark Table view data source


//对指定的节进行“展开/折叠”操作
-(void)collapseOrExpand:(NSInteger)section{
    [expandedDictionary setObject:[NSNumber numberWithBool:![[expandedDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)section]] intValue]] forKey:[NSString stringWithFormat:@"%ld",(long)section]];
}

//返回指定节的“expanded”值
-(Boolean)isExpanded:(int)section{
    return [[expandedDictionary objectForKey:[NSString stringWithFormat:@"%d",section]] intValue];
}

//按钮被点击时触发
-(void)expandButtonClicked:(id)sender{
    UIButton* btn= (UIButton*)sender;
    NSInteger section= btn.tag; //取得tag知道点击对应哪个块
    //NSLog(@"click %d", section);
    [self collapseOrExpand:section];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(rooms==nil){
        return 1;
    }else{
        return [rooms count]+1;
    }
    NSLog(@"numberOfSectionsInTableView");
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else{
        section = section - 1;
        //对指定节进行“展开”判断
        if (![self isExpanded:section]){
            //若本节是“折叠”的，其行数返回为0
            return 0;
        }
        return [[[rooms objectAtIndex:section] objectForKey:@"RatePlans"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    if(indexPath.section==0){
        static NSString *detailTopIdentify = @"detailTopIdentify";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailTopIdentify];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailTopIdentify];
            
            
            
            ImagePlayerView *imagePlayer = [[ImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
            imagePlayer.pageControl.hidden = YES;
            imagePlayer.autoScroll=NO;
            imagePlayer.tag = 1;
            [cell.contentView addSubview:imagePlayer];
            
            
            UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
            blankView.tag=2;
            blankView.backgroundColor=[UIColor blackColor];
            blankView.alpha=0.8f;
            [cell.contentView addSubview:blankView];
            
            UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, self.view.frame.size.width-20, 50)];
            hotelName.numberOfLines=0;
            hotelName.textColor=[UIColor whiteColor];
            hotelName.tag = 1;
            [blankView addSubview:hotelName];
            
            
            UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, 18, 18)];
            addressIcon.image=[UIImage imageNamed:@"global_hotel_order_list_address.png"];
            [cell.contentView addSubview:addressIcon];
            
            
            UILabel *addressName = [[UILabel alloc] initWithFrame:CGRectMake(30, 140, self.view.frame.size.width-45, 60)];
            addressName.textColor = [UIColor darkTextColor];//[CommonUtil getColor:@"dcdcdc"];
            addressName.font=[UIFont systemFontOfSize:15];
            addressName.tag = 3;
            addressName.numberOfLines=0;
            [cell.contentView addSubview:addressName];
            
            
            UIImageView *hotelIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, 32, 32)];
            hotelIcon.image=[UIImage imageNamed:@"customer_service_hotel.png"];
            [cell.contentView addSubview:hotelIcon];
            
            
            
            UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 190, 120, 30)];
            startDateLabel.textColor = [UIColor darkTextColor];//[CommonUtil getColor:@"dcdcdc"];
            startDateLabel.font=[UIFont systemFontOfSize:15];
            startDateLabel.tag = 4;
            [cell.contentView addSubview:startDateLabel];
            
            UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 215, 120, 30)];
            endDateLabel.textColor = [UIColor darkTextColor];//[CommonUtil getColor:@"dcdcdc"];
            endDateLabel.font=[UIFont systemFontOfSize:15];
            endDateLabel.tag = 5;
            [cell.contentView addSubview:endDateLabel];
            
            UILabel *totalNightLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 200, 100, 30)];
            totalNightLabel.textColor = [UIColor darkTextColor];//[CommonUtil getColor:@"dcdcdc"];
            totalNightLabel.font=[UIFont systemFontOfSize:15];
            totalNightLabel.tag = 6;
            [cell.contentView addSubview:totalNightLabel];
            
            
            UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine"]];
            line.frame = CGRectMake(0,190, self.view.frame.size.width, 0.5);
            line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
            [cell.contentView addSubview:line];
            
            UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separatorLine"]];
            line2.frame = CGRectMake(0,245, self.view.frame.size.width, 0.5);
            line2.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
            [cell.contentView addSubview:line2];
            
        }
        
        ImagePlayerView *imagePlayer = (ImagePlayerView*)[cell.contentView viewWithTag:1];
        [imagePlayer initWithCount:1 delegate:self];
        
        UIView *blankView = (UIView*)[cell.contentView viewWithTag:2];
        UILabel *hotelName = (UILabel*)[blankView viewWithTag:1];
        UILabel *addressName = (UILabel*)[cell.contentView viewWithTag:3];
        UILabel *startDateLabel = (UILabel*)[cell.contentView viewWithTag:4];
        UILabel *endDateLabel = (UILabel*)[cell.contentView viewWithTag:5];
        _totalNightLabel = (UILabel*)[cell.contentView viewWithTag:6];
        
        startDateLabel.userInteractionEnabled=YES;
        endDateLabel.userInteractionEnabled=YES;
        
        {
            NSArray *gestures = startDateLabel.gestureRecognizers;//移除之前的监听
            for(int i=0;i<[gestures count];i++){
                [startDateLabel removeGestureRecognizer:[gestures objectAtIndex:i]];
            }
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectStartDate:)];
            [startDateLabel addGestureRecognizer:tapGesture];
        }
        
        {
            NSArray *gestures = endDateLabel.gestureRecognizers;//移除之前的监听
            for(int i=0;i<[gestures count];i++){
                [endDateLabel removeGestureRecognizer:[gestures objectAtIndex:i]];
            }
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectEndDate:)];
            [endDateLabel addGestureRecognizer:tapGesture];
        }
        
        
        
        
        startDateLabel.text = [NSString stringWithFormat:@"入:%@",_starDateStr];
        endDateLabel.text = [NSString stringWithFormat:@"离:%@",_endDateStr];
//        _totalNightLabel.text = [NSString stringWithFormat:@"%.f 晚",_a];
        
        hotelName.text=HotelName;
        addressName.text=Address;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            UILabel *breakfastLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 32)];
            breakfastLabel.text = @"不含早 (预付)";
            breakfastLabel.tag=1;
            [cell.contentView addSubview:breakfastLabel];
            
            UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 260, 60)];
            cancelLabel.text = @"不可取消";
            cancelLabel.tag=2;
            cancelLabel.numberOfLines=0;
            cancelLabel.textColor = [CommonUtil getColor:@"dcdcdc"];
            cancelLabel.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:cancelLabel];
            
            
            UIButton* dingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dingBtn.tag = 99;
            dingBtn.frame = CGRectMake(cell.frame.size.width-40, 10, 32, 32);
            [dingBtn addTarget:self action:@selector(ding:)
              forControlEvents:UIControlEventTouchUpInside];
            [dingBtn setTitle:@"订" forState:UIControlStateNormal];
            dingBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [dingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            dingBtn.backgroundColor=[CommonUtil getColor:@"FE5555"];
            //[dingBtn setImage: [ UIImage imageNamed:@"ding.png" ] forState:UIControlStateNormal];
            [cell.contentView addSubview:dingBtn];
            
            
            UILabel *hotelMoney = [[UILabel alloc] initWithFrame:CGRectMake(dingBtn.frame.origin.x-50, 10, 100, 30)];
            //hotelMoney.text=@"¥682";
            //hotelMoney.textAlignment=UITextAlignmentRight;
            hotelMoney.tag=3;
            hotelMoney.textColor=[CommonUtil getColor:@"FF5555"];
            [cell.contentView addSubview:hotelMoney];
            
            
            if(IS_IPHONE_5){
                dingBtn.frame = CGRectMake(cell.frame.size.width-40, 10, 32, 32);
                hotelMoney.frame = CGRectMake(dingBtn.frame.origin.x-50, 10, 100, 30);
                cancelLabel.frame = CGRectMake(5, 40, self.view.frame.size.width-10, 60);
            }else if(IS_IPHONE_6||IS_IPHONE_6P){
                dingBtn.frame = CGRectMake(self.view.frame.size.width-40, 10, 32, 32);
                hotelMoney.frame = CGRectMake(dingBtn.frame.origin.x-50, 10, 100, 30);
                cancelLabel.frame = CGRectMake(5, 40, self.view.frame.size.width-10, 60);
            }
            
            
        }
        
        
        UILabel *breakfastLabel = [cell.contentView viewWithTag:1];
        UILabel *cancelLabel = [cell.contentView viewWithTag:2];
        UILabel *hotelMoney = [cell.contentView viewWithTag:3];
        
        
        UIButton *dingBtn = [cell.contentView viewWithTag:99];
        
        objc_setAssociatedObject(dingBtn, "btnParams", indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        
        
        NSDictionary* RatePlan = [[[rooms objectAtIndex:indexPath.section-1] objectForKey:@"RatePlans"] objectAtIndex:indexPath.row];
        breakfastLabel.text = [RatePlan objectForKey:@"RatePlanName"];
        hotelMoney.text = [NSString stringWithFormat:@"¥%d",[[RatePlan objectForKey:@"TotalRate"] intValue]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        NSString *GuaranteeRuleIds = [RatePlan objectForKey:@"GuaranteeRuleIds"];
        NSString *PaymentType = [RatePlan objectForKey:@"PaymentType"];
        NSArray *gRuleIds = [GuaranteeRuleIds componentsSeparatedByString:@","];
        
        
        if([self ifNeedGuarantee:gRuleIds]){
            dingBtn.backgroundColor=[UIColor grayColor];
            //[dingBtn setImage: [ UIImage imageNamed:@"ding_gray.png" ] forState:UIControlStateNormal];
        }else{
            dingBtn.backgroundColor=[CommonUtil getColor:@"FE5555"];
            //[dingBtn setImage: [ UIImage imageNamed:@"ding.png" ] forState:UIControlStateNormal];
        }
        
        NSString* BookingRuleIds = [RatePlan objectForKey:@"BookingRuleIds"];
        NSArray *ruleIds = [BookingRuleIds componentsSeparatedByString:@","];
        NSString* ruleDescription = @"";
        for(int i=0;i<[ruleIds count];i++){
            NSString *ruleId = [ruleIds objectAtIndex:i];
            NSString *description = [self getBookingRuleDescription:ruleId];
            ruleDescription = [NSString stringWithFormat:@"%@%@",ruleDescription,description];
        }
        cancelLabel.text = ruleDescription;
        
        return cell;
    }
}
//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_a == 0) {
        _totalNightLabel.text = self.dayStr;
    }else {
    _totalNightLabel.text = [NSString stringWithFormat:@"%.f 晚",_a];
    }
    NSLog(@"willDisplayCell");
}

-(BOOL)ifNeedGuarantee:(NSArray*)gRuleIds{
    for(int i=0;i<[gRuleIds count];i++){
        NSString *outterRuleId = [gRuleIds objectAtIndex:i];
        for(int j=0;j<[GuaranteeRules count];j++){
            NSDictionary *currentRule = [GuaranteeRules objectAtIndex:j];
            NSString *innerRuleId = [currentRule objectForKey:@"GuranteeRuleId"];
            if([outterRuleId longLongValue]==[innerRuleId longLongValue]){
                BOOL IsAmountGuarantee = [[currentRule objectForKey:@"IsAmountGuarantee"] intValue]==0?YES:NO;
                BOOL IsTimeGuarantee = [[currentRule objectForKey:@"IsTimeGuarantee"] intValue]==0?YES:NO;
                if(IsAmountGuarantee&&IsTimeGuarantee){
                    return YES;
                }
            }
        }
    }
    return NO;
}


-(NSString*)getBookingRuleDescription:(NSString*)ruleId{
    for(int i=0;i<[BookingRules count];i++){
        NSDictionary *bookingRule = [BookingRules objectAtIndex:i];
        NSString *bookingRuleId = [bookingRule objectForKey:@"BookingRuleId"];
        NSString *Description = [bookingRule objectForKey:@"Description"];
        if([bookingRuleId intValue] == [ruleId intValue]){
            return Description;
        }
    }
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        return 250;
    }else{
        return 90;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0){
        return 0;
    }else{
        return 80;
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if(section==0){
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }else{
        section = section - 1;
        UIView *hView;
        hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 80)];
        
        UIButton* eButton = [[UIButton alloc] init];
        eButton.frame = CGRectMake(self.view.frame.size.width-30, 25, 24, 20);
        [eButton addTarget:self action:@selector(expandButtonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        eButton.tag = section;//把节号保存到按钮tag，以便传递到expandButtonClicked方法
        //根据是否展开，切换按钮显示图片
        if ([self isExpanded:section])
            [eButton setImage: [ UIImage imageNamed:@"upArrow.png" ] forState:UIControlStateNormal];
        else
            [eButton setImage: [ UIImage imageNamed:@"downArrow.png" ] forState:UIControlStateNormal];
        
        
        UIImageView *hotelImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        hotelImage.layer.cornerRadius=5.0f;
        [hotelImage setImageWithURL:[NSURL URLWithString:[[rooms objectAtIndex:section] objectForKey:@"ImageUrl"]] placeholderImage:[UIImage imageNamed:@"guide1.png"]];
        
        UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 300, 30)];
        hotelName.text=[[rooms objectAtIndex:section] objectForKey:@"Name"];
        hotelName.textColor=[CommonUtil getColor:@"000000"];
        
        UILabel *hotelArea = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 200, 30)];
        //hotelArea.text=@"30平米 大床1.8米";
        hotelArea.text=[[rooms objectAtIndex:section] objectForKey:@"BedType"];//
        //hotelArea.text=[[rooms objectAtIndex:section] objectForKey:@"Description"];
        hotelArea.font = [UIFont systemFontOfSize:13];
        hotelArea.textColor=[CommonUtil getColor:@"999999"];
        
        NSString* floorInfo = [[rooms objectAtIndex:section] objectForKey:@"Floor"];
        //Floor = "4-18";ImageUrl = "http://pavo.elongstatic.com/i/Hotel120_120/0000gNjg.jpg"
        if(floorInfo){
            UILabel *hotelFloor = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 200, 30)];
            //hotelFloor.text=@"有窗口 8-18层";
            hotelFloor.text=[NSString stringWithFormat:@"%@层",[[rooms objectAtIndex:section] objectForKey:@"Floor"]];
            hotelFloor.font = [UIFont systemFontOfSize:13];
            hotelFloor.textColor=[CommonUtil getColor:@"999999"];
            [hView addSubview: hotelFloor];
        }else{
        }
        
        UILabel *hotelMoney = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-140, 30, 100, 30)];
        //hotelMoney.text=@"¥682";
        hotelMoney.text=[self getTheLowRate:section];
        //hotelMoney.text=[NSString stringWithFormat:@"¥682"];
        
        hotelMoney.textColor=[CommonUtil getColor:@"FF5555"];
        
        UILabel *hotelQI = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 32, 30)];
        hotelQI.text=@"起";
        hotelQI.textColor=[CommonUtil getColor:@"999999"];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 80-1,self.view.frame.size.width, 1)];
        bottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
        
        [hView addSubview: eButton];
        [hView addSubview: hotelImage];
        [hView addSubview: hotelName];
        [hView addSubview: bottomLine];
        [hView addSubview: hotelArea];
        
        [hView addSubview: hotelMoney];
        [hView addSubview: hotelQI];
        
        
        return hView;
    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0){
        return [[UIView alloc] init];
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        view.backgroundColor = [CommonUtil getColor:@"E8E8E8"];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        return 20;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView)
    {
        CGFloat sectionHeaderHeight = 80;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y+60, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}



-(NSString*)getTheLowRate:(int)section{
    NSArray *RatePlans = [[rooms objectAtIndex:section] objectForKey:@"RatePlans"];
    float lowRate = 99999;
    for(int i=0;i<[RatePlans count];i++){
        NSDictionary *RatePlan = [RatePlans objectAtIndex:i];
        if([[RatePlan objectForKey:@"TotalRate"] floatValue]<lowRate){
            lowRate = [[RatePlan objectForKey:@"TotalRate"] floatValue];
        }
    }
    return [NSString stringWithFormat:@"¥%d",(int)lowRate];
}

- (void)selectStartDate:(UITapGestureRecognizer*)gesture
{
    NSLog(@"start");
//    SelectDateViewController *dateTimeViewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
//    //dateTimeViewController.arrivalDateStr = _DepartureDate;
//    dateTimeViewController.delegate=self;
//    dateTimeViewController.mode=1;
//    selectDateFlag = 1;
//    [self.navigationController pushViewController:dateTimeViewController animated:YES];
//     selectDateFlag = 1;
    if (!_calendarView) {
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//        selectDateFlag = 1;
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
    

}

- (void)selectEndDate:(UITapGestureRecognizer*)gesture
{
    NSLog(@"end");
//    SelectDateViewController *dateTimeViewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
//    dateTimeViewController.delegate=self;
//    dateTimeViewController.mode=1;
//    dateTimeViewController.arrivalDateStr = _ArrivalDate;
//    selectDateFlag = 2;
//    [self.navigationController pushViewController:dateTimeViewController animated:YES];
//     selectDateFlag = 2;
    if (!_calendarView) {
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
//        selectDateFlag = 2;
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
//    [_tableView reloadData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
   [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
//   NSDate *originDateTime=[formatter dateFromString:_ArrivalDate];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    [formatter3 setDateFormat:@"hh:mm"];
//    NSString *str1 = [formatter2 stringFromDate:originDateTime];
    //NSString *str2 = [formatter3 stringFromDate:originDateTime];
    
    //NSString *lastDateTimeStr = [NSString stringWithFormat:@"%@T00:00:00+%@",str1,str2];
//    NSNumber *interval;


//    if(selectDateFlag==1){
//        _ArrivalDate = self.showStr;
//        _starDateStr = self.showStr;
//        //_startDateLabel.text = str1;
////        _startDate = originDateTime;
//        NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
//        [innerFormatter setDateFormat:@"yyyy-MM-dd"];
////        _starDateStr = [innerFormatter stringFromDate:originDateTime];
////        NSLog(@"入住时间是___%@___%@",_starDateStr,_ArrivalDate);
//    }else if(selectDateFlag==2){
//        _DepartureDate = self.showStr;
//        _endDateStr = self.showStr;
//        //_endDateLabel.text = str1;
////        _endDate = originDateTime;
//        //NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
//        //[innerFormatter setDateFormat:@"yyyy-MM-dd"];
//        //_endDateStr = [innerFormatter stringFromDate:originDateTime];
//        //NSLog(@"离开时间是___%@___%@",_endDateStr,_DepartureDate);
//    }
    
    
    
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags=NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:_starDateStr] toDate:[date dateFromString:_endDateStr] options:0];
    NSLog(@"%ld天%ld小时%ld分钟%ld秒",(long)[d day],(long)[d hour],(long)[d minute],(long)[d second]);
    
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setFirstWeekday:2];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *fromDate;
//    NSDate *toDate;
//    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:_starDateStr]];
//    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[dateFormatter dateFromString:_endDateStr]];
////    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
//    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
//    // dayComponents.day  即为间隔的天数
//    NSLog(@"%ld",(long)dayComponents.day);
    
    
    
    _days = (int)[CommonUtil getDaysFrom:[formatter2 dateFromString:_ArrivalDate] To:[formatter2 dateFromString:_DepartureDate]];
  
    if(_days<0){
        _days = 0;
    }
    [self.tableView reloadData];
    
    
    [self.HUD show:YES];
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"ArrivalDate": _ArrivalDate,
                                   @"DepartureDate": _DepartureDate,
                                   @"HotelIds":self.hotelID,
                                   @"Options": @"1,2,3,4,5",
                                   @"PaymentType":@"SelfPay",
                                   },
                           @"Version": @1.1
                           };
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
    [[AppLogic sharedInstance] getHotelDetail:postDatas success:^(NSDictionary* data) {
        [self.HUD hide:YES];
        Images = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Images"];
        HotelName = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
        Address = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        //        imagePlayer.pageControl.hidden = YES;
        //        imagePlayer.autoScroll=NO;
        //        [imagePlayer initWithCount:1 delegate:self];
        //        NSString *HotelName = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
        //        _hotelNameLabel.text = HotelName;
        //        _addressLabel.text = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        rooms = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Rooms"];
        BookingRules = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"BookingRules"];
        GuaranteeRules = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"GuaranteeRules"];
        for(int i=0;i<[rooms count];i++){
            [expandedDictionary setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *message) {
        [self.HUD hide:YES];
    }];
    
    
    NSLog(@"一共有几天____%d",_days);
}




-(void)selectDate:(NSString *)dateStr{
    //_ArrivalDate = @"2015-11-8T00:00:00+18:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *originDateTime=[formatter dateFromString:dateStr];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init] ;
    [formatter2 setDateFormat:@"yyyy-MM-dd"];
    [formatter3 setDateFormat:@"hh:mm"];
    NSString *str1 = [formatter2 stringFromDate:originDateTime];
    //NSString *str2 = [formatter3 stringFromDate:originDateTime];
    
    //NSString *lastDateTimeStr = [NSString stringWithFormat:@"%@T00:00:00+%@",str1,str2];
    
    if(selectDateFlag==1){
        _ArrivalDate = str1;
        _starDateStr = str1;
        //_startDateLabel.text = str1;
        _startDate = originDateTime;
        
        NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
        [innerFormatter setDateFormat:@"yyyy-MM-dd"];
        //_starDateStr = [innerFormatter stringFromDate:originDateTime];
        //NSLog(@"入住时间是___%@___%@",_starDateStr,_ArrivalDate);
    }else if(selectDateFlag==2){
        _DepartureDate = str1;
        _endDateStr = str1;
        //_endDateLabel.text = str1;
        _endDate = originDateTime;
        //NSDateFormatter *innerFormatter = [[NSDateFormatter alloc] init];
        //[innerFormatter setDateFormat:@"yyyy-MM-dd"];
        //_endDateStr = [innerFormatter stringFromDate:originDateTime];
        //NSLog(@"离开时间是___%@___%@",_endDateStr,_DepartureDate);
    }
//    _days = (int)[CommonUtil getDaysFrom:[formatter2 dateFromString:_ArrivalDate] To:[formatter2 dateFromString:_DepartureDate]];
    if(_a<0){
        _a = 0;
    }
    [self.tableView reloadData];
    
    
    [self.HUD show:YES];
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"ArrivalDate": _ArrivalDate,
                                   @"DepartureDate": _DepartureDate,
                                   @"HotelIds":self.hotelID,
                                   @"Options": @"1,2,3,4,5",
                                   @"PaymentType":@"SelfPay",
                                   },
                           @"Version": @1.1
                           };
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
    [[AppLogic sharedInstance] getHotelDetail:postDatas success:^(NSDictionary* data) {
        [self.HUD hide:YES];
        Images = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Images"];
        HotelName = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
        Address = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        //        imagePlayer.pageControl.hidden = YES;
        //        imagePlayer.autoScroll=NO;
        //        [imagePlayer initWithCount:1 delegate:self];
        //        NSString *HotelName = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
        //        _hotelNameLabel.text = HotelName;
        //        _addressLabel.text = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        rooms = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Rooms"];
        BookingRules = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"BookingRules"];
        GuaranteeRules = [[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"GuaranteeRules"];
        for(int i=0;i<[rooms count];i++){
            [expandedDictionary setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",i]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *message) {
        [self.HUD hide:YES];
    }];
    
    
    NSLog(@"一共有几天____%d",_days);
}



@end
