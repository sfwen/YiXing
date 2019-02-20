//
//  HotelOrderListViewController.m
//  easyTravel
//
//  Created by apple on 15/10/31.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HotelOrderListViewController.h"
#import "CommonUtil.h"
#import "HotelOrderDetailViewController.h"
#import "CityViewController.h"
#import "HotelDetailViewController.h"
#import "AppLogic.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"

@interface HotelOrderListViewController (){
    int rowCount;
    NSArray *datas;
    NSMutableArray *tab1DataArray;
    NSMutableArray *tab2DataArray;
    NSMutableArray *tab3DataArray;
    int currentTab;
}

@property(nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation HotelOrderListViewController

-(MBProgressHUD *)HUD{
    if(_HUD==nil){
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.labelText = @"查询酒店";
        _HUD.detailsLabelText = @"请耐心等待";
        _HUD.square = YES;
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentTab = 0;
    rowCount = 0;
    datas = [[NSArray alloc] init];
    tab1DataArray = [[NSMutableArray alloc] init];
    tab2DataArray = [[NSMutableArray alloc] init];
    tab3DataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.title = @"酒店订单";
    _redLine1.backgroundColor = [CommonUtil getColor:@"E15944"];
    _redLine2.backgroundColor = [CommonUtil getColor:@"E15944"];
    _redLine3.backgroundColor = [CommonUtil getColor:@"E15944"];
    _redLine1.hidden = NO;
    _redLine2.hidden = YES;
    _redLine3.hidden = YES;
    _title1.tintColor = [CommonUtil getColor:@"E15944"];
    _title2.tintColor = [CommonUtil getColor:@"000000"];
    _title3.tintColor = [CommonUtil getColor:@"000000"];
    _topBottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    
    [self setupRefresh];
    
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
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[HotelDetailViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btn1Click:(id)sender {
    currentTab=0;
    _redLine1.hidden = NO;
    _redLine2.hidden = YES;
    _redLine3.hidden = YES;
    _title1.tintColor = [CommonUtil getColor:@"E15944"];
    _title2.tintColor = [CommonUtil getColor:@"000000"];
    _title3.tintColor = [CommonUtil getColor:@"000000"];
    [self.tableView reloadData];
    if([tab1DataArray count]==0){
        [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
    }
}

- (IBAction)btn2Click:(id)sender {
    currentTab=1;
    _redLine1.hidden = YES;
    _redLine2.hidden = NO;
    _redLine3.hidden = YES;
    _title1.tintColor = [CommonUtil getColor:@"000000"];
    _title2.tintColor = [CommonUtil getColor:@"E15944"];
    _title3.tintColor = [CommonUtil getColor:@"000000"];
    [self.tableView reloadData];
    if([tab2DataArray count]==0){
        [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
    }
}

- (IBAction)btn3Click:(id)sender {
    currentTab=2;
    _redLine1.hidden = YES;
    _redLine2.hidden = YES;
    _redLine3.hidden = NO;
    _title1.tintColor = [CommonUtil getColor:@"000000"];
    _title2.tintColor = [CommonUtil getColor:@"000000"];
    _title3.tintColor = [CommonUtil getColor:@"E15944"];
    [self.tableView reloadData];
    if([tab3DataArray count]==0){
        [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
    }
}


#pragma mark -
#pragma mark Table View DataSource And Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(currentTab==0){
        return [tab1DataArray count];
    }else if(currentTab==1){
        return [tab2DataArray count];
    }else if(currentTab==2){
        return [tab3DataArray count];
    }
    return 0;
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
        
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"customer_service_hotel.png"]];
        icon.frame = CGRectMake(10,20,40,40);
        [cell.contentView addSubview:icon];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 260, 45)];
        nameLabel.numberOfLines=0;
        nameLabel.text = @"成都天府丽都喜来登酒店";
        nameLabel.textColor=[CommonUtil getColor:@"555555"];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.tag = 1;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *moneyLable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, 8, 60, 40)];
        moneyLable.text = @"预付¥622";
        moneyLable.tag = 5;
        moneyLable.textColor=[CommonUtil getColor:@"555555"];
        moneyLable.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:moneyLable];
        
        UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 200, 30)];
        typeLabel.text = @"高级大床间";
        typeLabel.tag = 2;
        typeLabel.textColor=[CommonUtil getColor:@"555555"];
        typeLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:typeLabel];
        
        
        UILabel *ruzhuDate = [[UILabel alloc] initWithFrame:CGRectMake(60, 65, 120, 30)];
        ruzhuDate.text = @"入:10-20";
        ruzhuDate.tag = 3;
        ruzhuDate.textColor=[CommonUtil getColor:@"555555"];
        ruzhuDate.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:ruzhuDate];
        
//        UILabel *ruzhuXinQi = [[UILabel alloc] initWithFrame:CGRectMake(125, 60, 80, 30)];
//        ruzhuXinQi.text = @"(周二)";
//        ruzhuXinQi.textColor=[CommonUtil getColor:@"999999"];
//        ruzhuXinQi.font = [UIFont systemFontOfSize:14];
//        [cell.contentView addSubview:ruzhuXinQi];
        
        UILabel *likaiDate = [[UILabel alloc] initWithFrame:CGRectMake(190, 65, 120, 30)];
        likaiDate.text = @"离:10-21";
        likaiDate.tag = 4;
        likaiDate.textColor=[CommonUtil getColor:@"555555"];
        likaiDate.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:likaiDate];
        
//        UILabel *liKaiXinQi = [[UILabel alloc] initWithFrame:CGRectMake(235, 60, 80, 30)];
//        liKaiXinQi.text = @"(周三)";
//        liKaiXinQi.textColor=[CommonUtil getColor:@"999999"];
//        liKaiXinQi.font = [UIFont systemFontOfSize:14];
//        [cell.contentView addSubview:liKaiXinQi];
        
    }
    
    UILabel *nameLabel = [cell viewWithTag:1];
    UILabel *typeLabel = [cell viewWithTag:2];
    UILabel *ruzhuDate = [cell viewWithTag:3];
    UILabel *likaiDate = [cell viewWithTag:4];
    UILabel *moneyLable = [cell viewWithTag:5];
    
    
    NSDictionary *hotelOrder = nil;
    
    if(currentTab==0){
        hotelOrder = [tab1DataArray objectAtIndex:indexPath.row];
    }else if(currentTab==1){
        hotelOrder = [tab2DataArray objectAtIndex:indexPath.row];
    }else if(currentTab==2){
        hotelOrder = [tab3DataArray objectAtIndex:indexPath.row];
    }
    
    
    nameLabel.text = [hotelOrder objectForKey:@"HotelName"];
    typeLabel.text = [hotelOrder objectForKey:@"RoomTypeName"];
    NSString *dataArrival = [hotelOrder objectForKey:@"ArrivalDate"];
    NSString *dataDepature = [hotelOrder objectForKey:@"DepartureDate"];
    ruzhuDate.text = [NSString stringWithFormat:@"入:%@",[dataArrival substringWithRange:NSMakeRange(0,10)]];
    likaiDate.text = [NSString stringWithFormat:@"离:%@",[dataDepature substringWithRange:NSMakeRange(0,10)]];
    moneyLable.text = [NSString stringWithFormat:@"¥%@",[hotelOrder objectForKey:@"TotalPrice"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HotelOrderDetailViewController *hotelOrderDetailViewController = [[HotelOrderDetailViewController alloc] initWithNibName:@"HotelOrderDetailViewController" bundle:nil];
    
    if(currentTab==0){
        hotelOrderDetailViewController.detailInfo = [tab1DataArray objectAtIndex:indexPath.row];
    }else if(currentTab==1){
        hotelOrderDetailViewController.detailInfo = [tab2DataArray objectAtIndex:indexPath.row];
    }else if(currentTab==2){
        hotelOrderDetailViewController.detailInfo = [tab3DataArray objectAtIndex:indexPath.row];
    }
    
    
    hotelOrderDetailViewController.currentTab = currentTab;
    [self.navigationController pushViewController:hotelOrderDetailViewController animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSDictionary *data = @{
                           @"Local": @"zh_CN",
                           @"Request": @{
                                   @"Mobile":[AppLogic sharedInstance].phone,
                                   @"PageIndex":@1,
                                   @"PageSize":@100,
                                   },
                           @"Version": @1.1
                           };
    
    
    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.order.list",@"mod":@1};
    
    //[self.HUD show:YES];
    
    [[AppLogic sharedInstance] getHotelOrderList:postDatas success:^(NSDictionary *data) {
        //{"Code":"0","Result":{"Count":0}}
        //rowCount = [[[data objectForKey:@"Result"] objectForKey:@"Count"] intValue];
        //[self.HUD hide:YES];
        
        
        
        [tab1DataArray removeAllObjects];
        [tab2DataArray removeAllObjects];
        [tab3DataArray removeAllObjects];
        
        
        
        datas = [[data objectForKey:@"Result"] objectForKey:@"Orders"];
        
        for(int i=0;i<[datas count];i++){
            NSDictionary *hotelOrder = [datas objectAtIndex:i];
            NSString *Status = [hotelOrder objectForKey:@"Status"];
            
            
            if([Status isEqualToString:@"E"]||[Status isEqualToString:@"D"]){
                [tab3DataArray addObject:hotelOrder];
            }else if([Status isEqualToString:@"F"]||[Status isEqualToString:@"C"]){
                [tab2DataArray addObject:hotelOrder];
            }else{
                [tab1DataArray addObject:hotelOrder];
            }
        }
        
        
        [self.tableView reloadData];
        
        
        
        if(currentTab==0){
            if([tab1DataArray count]==0){
                [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
            }
        }
        
        if(currentTab==1){
            if([tab2DataArray count]==0){
                [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
            }
        }
        
        if(currentTab==2){
            if([tab3DataArray count]==0){
                [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
            }
        }
        
        
        
        
    } fail:^(NSString *message) {
        //[self.HUD hide:YES];
        [[AppLogic sharedInstance] makeToast:message];
    }];
}






- (void)setupRefresh
{
    __weak HotelOrderListViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        NSDictionary *data = @{
                               @"Local": @"zh_CN",
                               @"Request": @{
                                       @"Mobile":[AppLogic sharedInstance].phone,
                                       @"PageIndex":@1,
                                       @"PageSize":@100,
                                       },
                               @"Version": @1.1
                               };
        
        
        NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.order.list",@"mod":@1};
        
        //[self.HUD show:YES];
        
        [[AppLogic sharedInstance] getHotelOrderList:postDatas success:^(NSDictionary *data) {
            //{"Code":"0","Result":{"Count":0}}
            //rowCount = [[[data objectForKey:@"Result"] objectForKey:@"Count"] intValue];
            //[self.HUD hide:YES];
            
            [self.tableView headerEndRefreshing];
            
            [tab1DataArray removeAllObjects];
            [tab2DataArray removeAllObjects];
            [tab3DataArray removeAllObjects];
            
            
            
            datas = [[data objectForKey:@"Result"] objectForKey:@"Orders"];
            
            for(int i=0;i<[datas count];i++){
                NSDictionary *hotelOrder = [datas objectAtIndex:i];
                NSString *Status = [hotelOrder objectForKey:@"Status"];
                
                
                if([Status isEqualToString:@"E"]||[Status isEqualToString:@"D"]){
                    [tab3DataArray addObject:hotelOrder];
                }else if([Status isEqualToString:@"F"]||[Status isEqualToString:@"C"]){
                    [tab2DataArray addObject:hotelOrder];
                }else{
                    [tab1DataArray addObject:hotelOrder];
                }
            }
            
            
            [self.tableView reloadData];
            
            
            
            if(currentTab==0){
                if([tab1DataArray count]==0){
                    [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
                }
            }
            
            if(currentTab==1){
                if([tab2DataArray count]==0){
                    [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
                }
            }
            
            if(currentTab==2){
                if([tab3DataArray count]==0){
                    [[AppLogic sharedInstance] makeToast:@"未查询到订单"];
                }
            }
            
            
            
            
        } fail:^(NSString *message) {
            //[self.HUD hide:YES];
            [self.tableView headerEndRefreshing];
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = [CommonUtil getStrByKey:@"headerPullToRefreshText"];
    self.tableView.headerReleaseToRefreshText = [CommonUtil getStrByKey:@"headerReleaseToRefreshText"];
    self.tableView.headerRefreshingText = [CommonUtil getStrByKey:@"headerRefreshingText"];

}

@end
