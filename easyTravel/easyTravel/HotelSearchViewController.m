//
//  HotelSearchViewController.m
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HotelSearchViewController.h"
#import "CommonUtil.h"
#import "HotelDetailViewController.h"
#import "HotelCellModel.h"
#import "AppLogic.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface HotelSearchViewController (){
    NSMutableArray *dataArray;
    int page;
    int selectDateFlag;
}
@property(nonatomic,strong)MBProgressHUD *HUD;
@end

@implementation HotelSearchViewController


-(MBProgressHUD *)HUD{
    if(_HUD==nil){
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.labelText = @"酒店查询中";
        _HUD.detailsLabelText = @"请耐心等待";
        _HUD.square = YES;
    }
    return _HUD;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
     dataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.title=_cityName;
    if(self.cityCode==nil){
        self.cityCode=@"0101";
    }
    [AppLogic sharedInstance].ArrivalDate=_ArrivalDate;
    [AppLogic sharedInstance].DepartureDate=_DepartureDate;
    NSDictionary *data = @{@"Local":@"zh_CN",@"Request":@{@"QueryType":@"LocationName",@"QueryText":_searchKeyword,@"ArrivalDate":_ArrivalDate,@"CityId":self.cityCode,@"CustomerType":@"None",@"DepartureDate":_DepartureDate,@"PageIndex":[NSNumber numberWithInt:page],@"PageSize":@7,@"PaymentType":@"All",@"ResultType":@"1,2,3",@"Sort":@"Default"},@"Version":@2.0};
    
    
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.list"};
    [self.HUD show:YES];
    [[AppLogic sharedInstance] getHotelList:postDatas success:^(NSArray *data) {
        [self.HUD hide:YES];
        [dataArray addObjectsFromArray:data];
        [self.tableView reloadData];
    } fail:^(NSString *message) {
        [self.HUD hide:YES];
    }];
    [self setupRefresh];
    //self.tableView.separatorStyle = nil;
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
    static NSString *orderListCellIdentifier = @"orderListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderListCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:orderListCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide2.png"]];
        icon.layer.cornerRadius=10.0f;
        icon.frame = CGRectMake(10,10,100,80);
        icon.tag = 9;
        [cell.contentView addSubview:icon];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 200, 50)];
        nameLabel.text = @"";
        nameLabel.tag = 2;
        nameLabel.numberOfLines=0;
        nameLabel.textColor=[CommonUtil getColor:@"555555"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:nameLabel];
        
        UILabel *yLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 80, 30)];
        yLabel.text = @"¥";
        yLabel.textColor=[CommonUtil getColor:@"999999"];
        yLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:yLabel];
        
        UILabel *ruzhuXinQi = [[UILabel alloc] initWithFrame:CGRectMake(140, 60, 80, 30)];
        ruzhuXinQi.text = @"622";
        ruzhuXinQi.tag = 1;
        ruzhuXinQi.textColor=[CommonUtil getColor:@"F94E02"];
        ruzhuXinQi.font = [UIFont systemFontOfSize:17];
        [cell.contentView addSubview:ruzhuXinQi];
        
        UILabel *likaiDate = [[UILabel alloc] initWithFrame:CGRectMake(200, 60, 80, 30)];
        likaiDate.text = @"起";
        likaiDate.textColor=[CommonUtil getColor:@"999999"];
        likaiDate.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:likaiDate];
        
//        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow.png"]];
//        rightArrow.frame = CGRectMake(340,50,12,12);
//        [cell.contentView addSubview:rightArrow];
        
    }
    HotelCellModel *model = [dataArray objectAtIndex:indexPath.row];
    UILabel *moneyLabel = (UILabel*)[cell.contentView viewWithTag:1];
    moneyLabel.text = [NSString stringWithFormat:@"%@",model.LowRate];
    UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:2];
    if(model.HotelName!=nil){
        nameLabel.text = [NSString stringWithFormat:@"%@",model.HotelName];
    }
    UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:9];
    [imageView setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"guide2.png"]];
    
    
    if(model.HotelName==nil){
        NSDictionary *data = @{
                               @"Local": @"zh_CN",
                               @"Request": @{
                                       @"ArrivalDate": _ArrivalDate,
                                       @"DepartureDate":_DepartureDate,
                                       @"HotelIds": model.HotelId,
                                       @"Options": @"1,2,3,4,5",
//                                       @"PaymentType": @"SelfPay",
//                                       @"RatePlanId": @317996,
//                                       @"RoomTypeId": @"0006",
                                       },
                               @"Version": @1.1
                               };
        NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
        [[AppLogic sharedInstance] gethotelCellNameAndImage:postDatas row:(int)indexPath.row success:^(NSString *name,int row,NSString *thumbImage) {
            ((HotelCellModel*)[dataArray objectAtIndex:row]).HotelName=name;
            ((HotelCellModel*)[dataArray objectAtIndex:row]).image=thumbImage;
            [imageView setImageWithURL:[NSURL URLWithString:thumbImage] placeholderImage:[UIImage imageNamed:@"guide2.png"]];
            //[self.tableView reloadData];
            nameLabel.text = name;
        } fail:^(NSString *message) {
            
        }];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelCellModel *model = [dataArray objectAtIndex:indexPath.row];
    HotelDetailViewController *hotelDetailViewController = [[HotelDetailViewController alloc] initWithNibName:@"HotelDetailViewController" bundle:nil];
    hotelDetailViewController.hotelID = model.HotelId;
    hotelDetailViewController.ArrivalDate = _ArrivalDate;
    hotelDetailViewController.DepartureDate = _DepartureDate;
    hotelDetailViewController.starDateStr=_starDateStr;
    hotelDetailViewController.endDateStr=_endDateStr;
    hotelDetailViewController.days=_days;
    hotelDetailViewController.dayStr = _dayDateStr;
    hotelDetailViewController.seletedDays = _seletedDays;
    NSLog(@"%@",_dayDateStr);
    [self.navigationController pushViewController:hotelDetailViewController animated:YES];
}






- (void)setupRefresh
{
    
    [self.tableView addHeaderWithCallback:^{
        page = 1;
        
        
        
        NSDictionary *data = @{@"Local":@"zh_CN",@"Request":@{@"QueryType":@"LocationName",@"QueryText":_searchKeyword,@"ArrivalDate":_ArrivalDate,@"CityId":self.cityCode,@"CustomerType":@"None",@"DepartureDate":_DepartureDate,@"PageIndex":[NSNumber numberWithInt:page],@"PageSize":@7,@"PaymentType":@"All",@"ResultType":@"1,2,3",@"Sort":@"Default"},@"Version":@2.0};
        
        
        NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.list"};
        
        [[AppLogic sharedInstance] getHotelList:postDatas success:^(NSArray *data) {
            [dataArray removeAllObjects];
            [dataArray addObjectsFromArray:data];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        } fail:^(NSString *message) {
            [self.tableView headerEndRefreshing];
        }];

        
        
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        if([dataArray count] != (page*7)){
            [self.tableView footerEndRefreshing];
            return;
        }
        
        
        NSDictionary *data = @{@"Local":@"zh_CN",@"Request":@{@"QueryType":@"LocationName",@"QueryText":_searchKeyword,@"ArrivalDate":_ArrivalDate,@"CityId":self.cityCode,@"CustomerType":@"None",@"DepartureDate":_DepartureDate,@"PageIndex":[NSNumber numberWithInt:page+1],@"PageSize":@7,@"PaymentType":@"All",@"ResultType":@"1,2,3",@"Sort":@"Default"},@"Version":@2.0};
        
        
        NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.list"};
        
        [[AppLogic sharedInstance] getHotelList:postDatas success:^(NSArray *data) {
            if([data count]>0){
                [dataArray addObjectsFromArray:data];
                page++;
            }
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        } fail:^(NSString *message) {
            [self.tableView footerEndRefreshing];
        }];
        
    }];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = [CommonUtil getStrByKey:@"headerPullToRefreshText"];
    self.tableView.headerReleaseToRefreshText = [CommonUtil getStrByKey:@"headerReleaseToRefreshText"];
    self.tableView.headerRefreshingText = [CommonUtil getStrByKey:@"headerRefreshingText"];
    
    self.tableView.footerPullToRefreshText = [CommonUtil getStrByKey:@"footerPullToRefreshText"];
    self.tableView.footerReleaseToRefreshText = [CommonUtil getStrByKey:@"footerReleaseToRefreshText"];
    self.tableView.footerRefreshingText = [CommonUtil getStrByKey:@"footerRefreshingText"];
    
}




@end
