//
//  MyAccountViewController.m
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//


#import "Common.h"
#import "MyAccountViewController.h"
#import "CommonUtil.h"
#import "ChargeViewController.h"
#import "WithDrawCashViewController.h"
#import "AppLogic.h"
#import "MoneyBackListCell.h"
#import "MJRefresh.h"


@interface MyAccountViewController (){
    NSTimer *timer;
    NSMutableArray *dataArray;
    int page;
}

@end

@implementation MyAccountViewController

@synthesize customTable;
@synthesize accountMoneyLabel;
@synthesize accountMoneyText;
@synthesize yuanLabel;
@synthesize chargeBtn;
@synthesize withDrawCashBtn;
@synthesize grayLine;
@synthesize redLine;
@synthesize detailLabel;
@synthesize detailScrollView;
@synthesize tableWidth;
@synthesize tableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.title = [CommonUtil getStrByKey:@"myAccountTitle"];
    accountMoneyText.text = [NSString stringWithFormat:@"%.2f",[AppLogic sharedInstance].myMoney];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    accountMoneyLabel.textColor = [CommonUtil getColor:@"ffb739"];
    accountMoneyText.textColor = [CommonUtil getColor:@"ffb739"];
    yuanLabel.textColor = [CommonUtil getColor:@"ffb739"];
    chargeBtn.backgroundColor = [CommonUtil getColor:@"ff5353"];
    withDrawCashBtn.backgroundColor = [CommonUtil getColor:@"78d446"];
    customTable.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    grayLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    redLine.backgroundColor = [CommonUtil getColor:@"ff0000"];
    detailLabel.textColor = [CommonUtil getColor:@"333333"];
    
    tableWidth.constant = self.view.bounds.size.width;
    chargeBtn.layer.cornerRadius = 3.0;
    [chargeBtn.layer setBorderColor:[[CommonUtil getColor:@"ff5353"] CGColor]];
    [chargeBtn.layer setBorderWidth:1.0];
    withDrawCashBtn.layer.cornerRadius = 3.0;
    [withDrawCashBtn.layer setBorderColor:[[CommonUtil getColor:@"78d446"] CGColor]];
    [withDrawCashBtn.layer setBorderWidth:1.0];
    //[self.view addSubview:customTable];
    
    
    /*
     "create_time" = 1436981385;
     "order_id" = 1;
     "r_money" = "11.00";
     "r_number" = 111;
     uid = 32;
     username = "\U5218\U5fb7\U534e";
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyMoney:) name:@"updateMyMoney" object:nil];
    
    
    dataArray = [[NSMutableArray alloc] init];
    tableView.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    [tableView registerNib:[UINib nibWithNibName:@"MoneyBackListCell" bundle:nil] forCellReuseIdentifier:@"MoneyBackListCell"];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    [self setupRefresh];
    
    [self freshTable];
}

-(void)freshTable{
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 };
    [[AppLogic sharedInstance] getMoneyBackList:attributes success:^(NSArray *listData) {
        [dataArray removeAllObjects];
        [dataArray addObject:@[[[CommonUtil getArrayByKey:@"myAccountTitleArray"] objectAtIndex:0],[[CommonUtil getArrayByKey:@"myAccountTitleArray"] objectAtIndex:1],[[CommonUtil getArrayByKey:@"myAccountTitleArray"] objectAtIndex:2]]];
        if([listData count]<=0){
            //[dataArray addObject:@[[CommonUtil getStrByKey:@"nowNoData"],[CommonUtil getStrByKey:@"nowNoData"],[CommonUtil getStrByKey:@"nowNoData"]]];
        }
        for(int i=0;i<[listData count];i++){
            NSDate *createDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[[listData objectAtIndex:i] valueForKeyPath:@"create_time"] doubleValue]];
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateText = [formatter stringFromDate:createDate];
            [dataArray addObject:@[[[listData objectAtIndex:i] valueForKeyPath:@"r_number"],dateText,[[listData objectAtIndex:i] valueForKeyPath:@"r_money"]]];
        }
        [tableView reloadData];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)updateMyMoney:(NSNotification*) notification{
    accountMoneyText.text = [NSString stringWithFormat:@"%.2f",[AppLogic sharedInstance].myMoney];
}

- (void)getMoneyTimer:(NSTimer*)theTimer{
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 };
    [[AppLogic sharedInstance] getMoney:attributes success:^{
        accountMoneyText.text = [NSString stringWithFormat:@"%.2f",[AppLogic sharedInstance].myMoney];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getMoneyTimer:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inCharge:(id)sender {
    [self.navigationController pushViewController:[[ChargeViewController alloc] initWithNibName:@"ChargeViewController" bundle:nil] animated:YES];
}

- (IBAction)getCash:(id)sender {
    [self.navigationController pushViewController:[[WithDrawCashViewController alloc] initWithNibName:@"WithDrawCashViewController" bundle:nil] animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyBackListCell"];
    NSArray *data = [dataArray objectAtIndex:indexPath.row];
    [cell setLabelText:[data objectAtIndex:0] :[data objectAtIndex:1] :[data objectAtIndex:2]];
    return cell;
}

- (void)setupRefresh
{
    
    
    
    [self.tableView addHeaderWithCallback:^{
        page = 1;
        
        
        
        NSDictionary* attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"page":[NSString stringWithFormat:@"%d",page],
                                     @"pagesize":[NSString stringWithFormat:@"%d",ORDER_LIST_PAGE_SIZE]
                                     };
        
        [[AppLogic sharedInstance] getMoneyBackList:attributes success:^(NSArray *listData) {
            [self.tableView headerEndRefreshing];
            [dataArray removeAllObjects];
            [dataArray addObject:@[[[CommonUtil getArrayByKey:@"myAccountTitleArray"] objectAtIndex:0],[[CommonUtil getArrayByKey:@"myAccountTitleArray"] objectAtIndex:1],[[CommonUtil getArrayByKey:@"myAccountTitleArray"] objectAtIndex:2]]];
            if([listData count]<=0){
                //[dataArray addObject:@[[CommonUtil getStrByKey:@"nowNoData"],[CommonUtil getStrByKey:@"nowNoData"],[CommonUtil getStrByKey:@"nowNoData"]]];
            }
            for(int i=0;i<[listData count];i++){
                NSDate *createDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[[listData objectAtIndex:i] valueForKeyPath:@"create_time"] doubleValue]];
                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateText = [formatter stringFromDate:createDate];
                [dataArray addObject:@[[[listData objectAtIndex:i] valueForKeyPath:@"r_number"],dateText,[[listData objectAtIndex:i] valueForKeyPath:@"r_money"]]];
            }
            [tableView reloadData];
        } fail:^(NSString *message) {
            [self.tableView headerEndRefreshing];
            [[AppLogic sharedInstance] makeToast:message];
        }];
        
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        if([dataArray count] != (page*ORDER_LIST_PAGE_SIZE)){
            [self.tableView footerEndRefreshing];
            return;
        }
        
        NSDictionary* attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"page":[NSString stringWithFormat:@"%d",page+1],
                                     @"pagesize":[NSString stringWithFormat:@"%d",ORDER_LIST_PAGE_SIZE]
                                     };
        
        [[AppLogic sharedInstance] getMoneyBackList:attributes success:^(NSArray *listData) {
            if(![listData isKindOfClass:[NSArray class]] || [dataArray count]==0){
                
            }else{
                for(int i=0;i<[listData count];i++){
                    NSDate *createDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[[listData objectAtIndex:i] valueForKeyPath:@"create_time"] doubleValue]];
                    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    NSString *dateText = [formatter stringFromDate:createDate];
                    [dataArray addObject:@[[[listData objectAtIndex:i] valueForKeyPath:@"r_number"],dateText,[[listData objectAtIndex:i] valueForKeyPath:@"r_money"]]];
                }

                page++;
            }
            
            [tableView reloadData];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
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
