//
//  HotelOrderDetailViewController.m
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HotelOrderDetailViewController.h"
#import "CommonUtil.h"
#import "AppLogic.h"
#import "MBProgressHUD.h"

@interface HotelOrderDetailViewController ()


@property(nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation HotelOrderDetailViewController

-(MBProgressHUD *)HUD{
    if(_HUD==nil){
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.labelText = @"取消订单";
        _HUD.detailsLabelText = @"请耐心等待";
        _HUD.square = YES;
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"订单详情";
    self.view.backgroundColor = [CommonUtil getColor:@"F5F5F5'"];
    _line1.layer.borderColor = [CommonUtil getColor:@"C8C8C8"].CGColor;
    _line1.layer.borderWidth = 1.0f;
    _line2.layer.borderColor = [CommonUtil getColor:@"C8C8C8"].CGColor;
    _line2.layer.borderWidth = 1.0f;
    _bottomArea.layer.borderColor = [CommonUtil getColor:@"C8C8C8"].CGColor;
    _bottomArea.layer.borderWidth = 1.0f;
    
    _btn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    _btn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    _btn.layer.borderWidth = 1.0f;
    _btn.layer.cornerRadius = 6.0f;
    
    
    
    NSString *dataArrival = [_detailInfo objectForKey:@"ArrivalDate"];
    NSString *dataDepature = [_detailInfo objectForKey:@"DepartureDate"];
    
    _orderNoLabel.text = [NSString stringWithFormat:@"%d",[[_detailInfo objectForKey:@"OrderId"] intValue]];
    _hotelNameLabel.text = [_detailInfo objectForKey:@"HotelName"];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",[_detailInfo objectForKey:@"TotalPrice"]];
    _bedTypeLabel.text = [_detailInfo objectForKey:@"RoomTypeName"];
    _startAndEndDateLabel.text = [NSString stringWithFormat:@"%@离店:%@",[dataArrival substringWithRange:NSMakeRange(0,10)],[dataDepature substringWithRange:NSMakeRange(0,10)]];
    _zaocangLabel.text = [_detailInfo objectForKey:@"RatePlanName"];
    //_addressLabel.text = [_detailInfo objectForKey:@"HotelName"];
    _startDateLabel.text = [dataArrival substringWithRange:NSMakeRange(0,10)];
    
    
    if(_currentTab==1){
        _btn.hidden=YES;
    }
    if(_currentTab==2){
        _btn.hidden=YES;
    }
    
    switch (_currentTab) {
        case 0:
            _statusLabel.text=@"已确认";
            break;
        case 1:
            _statusLabel.text=@"已完成";
            break;
        case 2:
            _statusLabel.text=@"已取消";
            break;
        default:
            break;
    }
    
    _nameLabel.text=[AppLogic sharedInstance].real_name;
    
    
    
    /*
     
     {
     ArrivalDate = "2015-11-18T00:00:00+08:00";
     ConfirmationType = "SMS_cn";
     CurrencyCode = RMB;
     CustomerType = All;
     DepartureDate = "2015-11-19T00:00:00+08:00";
     EarliestArrivalTime = "2015-11-18T22:30:00+08:00";
     HotelId = 40101882;
     HotelName = "\U5c71\U6c34\U65f6\U5c1a\U9152\U5e97(\U5317\U4eac\U524d\U95e8\U5e97)";
     LatestArrivalTime = "2015-11-18T23:00:00+08:00";
     NoteToHotel = "*\U5ba2\U4eba\U624b\U673a\U53f7\Uff1a18628056964*\U3010\U738b\U6bbf\U4ee4H\U6ce8\U91ca\Uff1aebooking\U5b9e\U9645\U8ba2\U5355\U72b6\U6001\U6709\U9884\U5b9a\U672a\U5230\U3011";
     NumberOfCustomers = 1;
     NumberOfRooms = 1;
     OrderId = 335387540;
     PaymentType = SelfPay;
     RatePlanId = 1434980;
     RatePlanName = "\U4e0d\U542b\U65e9\Uff08\U9650\U65f6\U62a2\Uff09";
     RoomTypeId = 0006;
     RoomTypeName = "\U7cbe\U54c1\U5927\U5e8a\U623f";
     Status = B;
     TotalPrice = 218;
     }
     
     */
    
    
    NSDate *_startDate = [[NSDate alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
    
    
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"ArrivalDate": [formatter stringFromDate:_startDate],
                                   @"DepartureDate":[formatter stringFromDate:newdate],
                                   @"HotelIds":[_detailInfo objectForKey:@"HotelId"],
                                   @"Options": @"1,2,3,4,5",
                                   @"PaymentType":@"SelfPay",
                                   },
                           @"Version": @1.1
                           };
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
    [[AppLogic sharedInstance] getHotelDetail:postDatas success:^(NSDictionary* data) {
        NSString *Address = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Address"];
        NSString *Phone = [[[[[data objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"Phone"];
        _addressLabel.text = Address;
        _phoneLabel.text=Phone;
    } fail:^(NSString *message) {
        
    }];

    
    
    
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

- (IBAction)btnClick:(id)sender {
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"OrderId":[_detailInfo objectForKey:@"OrderId"],
                                   @"CancelCode":@"其它",
                                   },
                           @"Version": @1.1
                           };
    
    
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.order.cancel",@"mod":@1};
    [self.HUD show:YES];
    [[AppLogic sharedInstance] cancelHotelOrder:postDatas success:^(NSDictionary *data) {
        [self.HUD hide:YES];
        NSDictionary *Result = [data objectForKey:@"Result"];
        if([[Result objectForKey:@"Successs"] intValue]==0){
            [[AppLogic sharedInstance] makeToast:[data objectForKey:@"Code"]];
        }else{
            //[self.navigationController popViewControllerAnimated:YES];
            
            
            [self.HUD show:YES];
            NSString *smsContent = [NSString stringWithFormat:@"尊敬的%@，您的酒店订单已成功取消。",[AppLogic sharedInstance].real_name];
            NSDictionary* postDics = @{@"phone":[AppLogic sharedInstance].phone,@"content":smsContent};
            [self.HUD show:YES];
            [[AppLogic sharedInstance] sendSms:postDics success:^{//发送短信
                [self.HUD hide:YES];
                
                
                _statusLabel.text=@"已取消";
                _btn.hidden=YES;
                [[AppLogic sharedInstance] makeToast:@"成功取消订单"];
                
                
            } fail:^(NSString *message) {
                [self.HUD hide:YES];
                [[AppLogic sharedInstance] makeToast:message];
            }];
            
            
            
            
            
            
            
            
        }
    } fail:^(NSString *message) {
        [self.HUD hide:YES];
        [[AppLogic sharedInstance] makeToast:message];
    }];

    
}
- (IBAction)diaPhone:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_phoneLabel.text];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
@end
