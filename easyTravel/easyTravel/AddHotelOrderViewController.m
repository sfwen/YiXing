//
//  TestViewController.m
//  easyTravel
//
//  Created by cg on 15/11/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AddHotelOrderViewController.h"
#import "CommonUtil.h"
#import "AppLogic.h"
#import "HotelOrderListViewController.h"
#import "MBProgressHUD.h"

@interface AddHotelOrderViewController (){
    int selectDateFlag;
    int roomCount;
    NSString *earlistArrivalDateTimeStr;
    NSString *latestArrivalDateTimeStr;
}

@property(nonatomic,strong)UILabel *hotleNameLabel;
@property(nonatomic,strong)UILabel *startAndLeaveDateLabel;
@property(nonatomic,strong)UILabel *totalNightsLabel;
@property(nonatomic,strong)UILabel *bedTypeLabel;
@property(nonatomic,strong)UILabel *breakfestLabel;
@property(nonatomic,strong)UILabel *totalMoneyLabel;

@property(nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation AddHotelOrderViewController

-(MBProgressHUD *)HUD{
    if(_HUD==nil){
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.labelText = @"请耐心等待";
        _HUD.detailsLabelText = @"提交订单中";
        _HUD.square = YES;
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单填写";
    roomCount= 1;
    // Do any additional setup after loading the view from its nib.
    _chooseNumView = [[ChooseNumView alloc] init];
    [self.view addSubview:_chooseNumView];
    _chooseNumView.delegate = self;
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

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - UITableViewDataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows[] = {1,2,roomCount,1};
    return rows[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){
        static NSString *row1Identify = @"row1Identify";
        
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:row1Identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row1Identify];
            
            [cell.contentView addSubview:self.hotleNameLabel];
            [cell.contentView addSubview:self.startAndLeaveDateLabel];
            [cell.contentView addSubview:self.totalNightsLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 1)];
            line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
            [cell.contentView addSubview:line];
            [cell.contentView addSubview:self.bedTypeLabel];
            [cell.contentView addSubview:self.breakfestLabel];
        }
        
        self.hotleNameLabel.text = _hName;
        self.startAndLeaveDateLabel.text = [NSString stringWithFormat:@"入住:%@ 离店:%@",_starDateStr,_endDateStr];
        self.totalNightsLabel.text = [NSString stringWithFormat:@"共%d晚",_days];
//        self.totalNightsLabel.text = _dayDateStr;
        
        self.bedTypeLabel.text = _bedType;
        self.breakfestLabel.text = _ratePlanName;
        
        return cell;
    }else if(indexPath.section==1){
        static NSString *row2Identify = @"row2Identify";
        
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:row2Identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row2Identify];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 120, 32)];
            titleLabel.tag=1;
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 300, 32)];
            contentLabel.tag=2;
            
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:contentLabel];
        }
        
        UILabel *titleLabel = [cell.contentView viewWithTag:1];
        UILabel *contentLabel = [cell.contentView viewWithTag:2];
        
        if(indexPath.row==0){
            titleLabel.text=@"联系人手机";
            contentLabel.text=[AppLogic sharedInstance].phone;
        }else if(indexPath.row==1){
            titleLabel.text=@"房间数";
            contentLabel.text=[NSString stringWithFormat:@"%d间",roomCount];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==2){
        static NSString *row3Identify = @"row3Identify";
        
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:row3Identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row3Identify];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 120, 32)];
            titleLabel.tag=1;
            
            UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(140, 5, 300, 32)];
            field.tag=2;
            
            [cell.contentView addSubview:titleLabel];
            [cell.contentView addSubview:field];
        }
        
        UILabel *titleLabel = [cell.contentView viewWithTag:1];
        titleLabel.text = @"入住人";
        
        UITextField *field = [cell.contentView viewWithTag:2];
        field.placeholder=@"输入姓名";
        
        if(indexPath.row==0){
            field.text=[AppLogic sharedInstance].real_name;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section==3){
        static NSString *row4Identify = @"row4Identify";
        
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:row4Identify];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:row4Identify];
            
            UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-170, 10, 150, 50)];
            submitBtn.backgroundColor = [CommonUtil getColor:@"ff6c6a"];
            [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
            //[submitBtn setImage:[UIImage imageNamed:@"submitHotelOrder.png"] forState:UIControlStateNormal];
            submitBtn.tag = 2;
            
            [submitBtn addTarget:self action:@selector(doSubmit:) forControlEvents:UIControlEventTouchDown];
            
            [cell.contentView addSubview:self.totalMoneyLabel];
            [cell.contentView addSubview:submitBtn];
        }
        
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", _singleMoney*roomCount];
        NSLog(@"--------%@",self.totalMoneyLabel.text);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

-(UILabel *)totalMoneyLabel{
    if(_totalMoneyLabel==nil){
        _totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 120, 32)];
        _totalMoneyLabel.tag = 1;
    }
    return _totalMoneyLabel;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 120;
    }else if(indexPath.section==1){
        return 45;
    }
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section==0){
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        v.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
        return v;
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    v.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0){
        return 20;
    }
    return 0;
}


-(UILabel *)hotleNameLabel{
    if(_hotleNameLabel==nil){
        _hotleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-20, 50)];
        _hotleNameLabel.numberOfLines=0;
        _hotleNameLabel.text=@"标题";
    }
    return _hotleNameLabel;
}

-(UILabel *)startAndLeaveDateLabel{
    if(_startAndLeaveDateLabel==nil){
        _startAndLeaveDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 43, 300, 32)];
        _startAndLeaveDateLabel.text=@"入住:11-15 离开:11-20";
    }
    return _startAndLeaveDateLabel;
}

-(UILabel *)totalNightsLabel{
    if(_totalNightsLabel==nil){
        _totalNightsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50, 43, 50, 32)];
        _totalNightsLabel.text=@"共1晚";
    }
    return _totalNightsLabel;
}

-(UILabel *)bedTypeLabel{
    if(_bedTypeLabel==nil){
        _bedTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 200, 32)];
        _bedTypeLabel.text=@"高级大";
    }
    return _bedTypeLabel;
}

-(UILabel *)breakfestLabel{
    if(_breakfestLabel==nil){
        _breakfestLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 95, 200, 32)];
        _breakfestLabel.text=@"含有";
    }
    return _breakfestLabel;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        if(indexPath.row==0){
        }else if(indexPath.row==1){
            [_chooseNumView show];
        }
    }
}

-(void)chooseNumber:(int)number{
    UITableViewCell *cell1 = (UITableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    UILabel *contentLabel1 = [cell1.contentView viewWithTag:2];
    roomCount = number;
    contentLabel1.text=[NSString stringWithFormat:@"%d间",number];
    [_tableView reloadData];
}
//-(void)selectDate:(NSString *)dateStr{
//    if(selectDateFlag==1){
//        //_earlyDateLabel.text = dateStr;
//        UITableViewCell *cell1 = (UITableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//        UILabel *contentLabel1 = [cell1.contentView viewWithTag:2];
//        contentLabel1.text = dateStr;
//        earlistArrivalDateTimeStr = dateStr;
//    }else if(selectDateFlag==2){
//        //_lateDateLabel.text = dateStr;
//        UITableViewCell *cell1 = (UITableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//        UILabel *contentLabel1 = [cell1.contentView viewWithTag:2];
//        contentLabel1.text = dateStr;
//        latestArrivalDateTimeStr = dateStr;
//    }
//}

-(BOOL)checkWriteAllNames{
    for(int i=0;i<roomCount;i++){
        UITableViewCell *cell = (UITableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        UITextField *field = [cell.contentView viewWithTag:2];
        if([field.text length]<=0){
            return NO;
        }
    }
    return YES;
}


-(NSArray*)getCustomers{
    NSMutableArray *customers = [[NSMutableArray alloc] init];
    
    for(int i=0;i<roomCount;i++){
        UITableViewCell *cell = (UITableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        UITextField *field = [cell.contentView viewWithTag:2];
        NSDictionary *customer = @{
                                   @"Gender": @"Female",
                                   @"Name": field.text,
                                   @"Nationality": @"中国"
                                   };
        [customers addObject:customer];
    }
    return customers;
}


-(NSString*)getDefaultUserName{
    for(int i=0;i<roomCount;i++){
        UITableViewCell *cell = (UITableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        UITextField *field = [cell.contentView viewWithTag:2];
        if([field.text length]>0){
            return field.text;
        }
    }
    return @"";
}

-(void)doSubmit:(UIButton*)sender{
    
    if(![self checkWriteAllNames]){
        [[AppLogic sharedInstance] makeToast:@"未填写姓名"];
        return;
    }
    earlistArrivalDateTimeStr = [NSString stringWithFormat:@"%@T14:00:00 +08:00",_ArrivalDate];
    latestArrivalDateTimeStr = [NSString stringWithFormat:@"%@T19:00:00 +08:00",_ArrivalDate];
    CGFloat singleMoney = [[NSString stringWithFormat:@"%.2f", _singleMoney] floatValue];
//    CGFloat totalMoney = _days * singleMoney;
    NSNumber *TotalPrice = [NSNumber numberWithFloat:singleMoney];
    NSArray *Customers = [self getCustomers];
    
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"AffiliateConfirmationId":[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000],
                                   @"ArrivalDate": _ArrivalDate,
                                   @"ConfirmationType": @"NotAllowedConfirm",
                                   @"Contact": @{//联系人
                                           @"Gender":@"Female",
                                           @"Mobile": [AppLogic sharedInstance].phone,
                                           @"Name": [self getDefaultUserName]
                                           },
                                   @"CurrencyCode": _CurrencyCode,
                                   @"CustomerIPAddress": @"127.0.0.1",
                                   @"CustomerType": _CustomerType,
                                   @"DepartureDate": _DepartureDate,
                                   @"EarliestArrivalTime": earlistArrivalDateTimeStr,
                                   @"ExtendInfo": @{
                                           @"Int1": @0,
                                           @"Int2": @0,
                                           @"Int3": @0,
                                           @"String1": @"abc"
                                           },
                                   @"HotelId": self.HotelId,
                                   //@"IsGuaranteeOrCharged": @false,
                                   @"IsNeedInvoice": @false,//是否需要开发票
                                   @"LatestArrivalTime": latestArrivalDateTimeStr,
                                   @"NumberOfCustomers": @1,//客人信息
                                   @"NumberOfRooms": @1,
                                   @"OrderRooms": @[
                                           @{
                                               @"Customers": Customers
                                               }
                                           ],
                                   @"PaymentType": _PaymentType,
                                   @"RatePlanId": _RatePlanId,
                                   @"RoomTypeId": _RoomTypeId,
                                   @"TotalPrice":TotalPrice
                                   },
                           @"Version": @1.1
                           };
    
    
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.order.create",@"mod":@1};
    
    [self.HUD show:YES];
    [[AppLogic sharedInstance] createHotelOrder:postDatas success:^(NSDictionary *data) {
        [self.HUD hide:YES];
        
        
        
        
        
        if([[data objectForKey:@"Code"] isEqualToString:@"0"]){
            
            
            
            NSDate *currentDate = [[NSDate alloc] init];
            
            
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy年-MM月-dd日"];
            NSString *dateStr = [formatter stringFromDate:currentDate];
            
            
            NSString *smsContent = [NSString stringWithFormat:@"尊敬的%@，您于%@成功预订%@，%@%d间总价￥%d元；地址：%@ 电话:%@",[AppLogic sharedInstance].real_name,dateStr,_hName,_roomType,roomCount,_singleMoney*roomCount*_days,_address,_phone];
            

            
            
            NSDictionary* postDics = @{@"phone":[AppLogic sharedInstance].phone,@"content":smsContent};
            [self.HUD show:YES];
            [[AppLogic sharedInstance] sendSms:postDics success:^{//发送短信
                [self.HUD hide:YES];
                HotelOrderListViewController *orderListViewController = [[HotelOrderListViewController alloc] initWithNibName:@"HotelOrderListViewController" bundle:nil];
                [self.navigationController pushViewController:orderListViewController animated:YES];
                
            } fail:^(NSString *message) {
                [self.HUD hide:YES];
                [[AppLogic sharedInstance] makeToast:message];
            }];
            
            
            
            
        }else{
            [[AppLogic sharedInstance] makeToast:[data objectForKey:@"Code"]];
        }
        
        
        
        
        
        
        
        
    } fail:^(NSString *message) {
        [self.HUD hide:YES];
        [[AppLogic sharedInstance] makeToast:message];
    }];

    
    
    
}

@end
