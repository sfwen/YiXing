//
//  VipOrderViewController.m
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VipOrderViewController.h"
#import "PayViewController.h"
#import "CustomAlertView.h"
#import "CommonUtil.h"
#import "CommentViewController.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "MJRefresh.h"
#import "CommonUtil.h"

@interface VipOrderViewController (){
    NSMutableArray *orderDataArray;
    enum ORDER_MODE orderMode;
    int page;
}
@end

@implementation VipOrderViewController

@synthesize tableView;
@synthesize numView1;
@synthesize numView2;
@synthesize numView3;
@synthesize numView4;
@synthesize indicatorLine1;
@synthesize indicatorLine2;
@synthesize indicatorLine3;
@synthesize indicatorLine4;
@synthesize tab1;
@synthesize tab2;
@synthesize tab3;
@synthesize tab4;

-(void)setMode:(enum ORDER_MODE)mode{
    orderMode = mode;
    [self setIndicatorLinePosition];
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
    if([AppLogic sharedInstance].loginSuccessWillGoViewTag==4){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    numView1.hidden=YES;
    numView2.hidden=YES;
    numView3.hidden=YES;
    numView4.hidden=YES;
    indicatorLine1.backgroundColor = [CommonUtil getColor:@"ff0000"];
    indicatorLine2.backgroundColor = [CommonUtil getColor:@"ff0000"];
    indicatorLine3.backgroundColor = [CommonUtil getColor:@"ff0000"];
    indicatorLine4.backgroundColor = [CommonUtil getColor:@"ff0000"];
    orderDataArray = [[NSMutableArray alloc] init];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title=[CommonUtil getStrByKey:@"vipOrderTitle"];
    [tableView registerNib:[UINib nibWithNibName:@"OrderNeedPayCell" bundle:nil] forCellReuseIdentifier:@"OrderNeedPayCell"];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrder:) name:@"refreshOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentSuccess:) name:@"commentSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
    [self setupRefresh];
    [self setOrderNumber];
    numView4.hidden = YES;
    [self refreshContent];
    
    [self setIndicatorLinePosition];
}


-(void)commentSuccess:(NSNotification*) notification{
    orderMode = ORDER_IS_OVER;
    page = 1;
    [self refreshContent];
    [self setOrderNumber];
}

-(void)paySuccess:(NSNotification*) notification{
    orderMode = ORDER_NO_GET;
    page = 1;
    [self refreshContent];
    [self setOrderNumber];
}

-(void)refreshOrder:(NSNotification*) notification{
    [self refreshContent];
    [self setOrderNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     OrderNeedPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderNeedPayCell"];
     [cell setNeedsLayout];
     [cell layoutIfNeeded];
     CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
     return height+1;
    //return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderNeedPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderNeedPayCell"];
    [cell setData:[orderDataArray objectAtIndex:indexPath.row]:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)deleteOrder:(UIButton *)button{
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:[CommonUtil getStrByKey:@"deleteOrderTip"] contentText:[CommonUtil getStrByKey:@"deleteOrderTip"] leftButtonTitle:[CommonUtil getStrByKey:@"cancel"] rightButtonTitle:[CommonUtil getStrByKey:@"confirm"]];
    [alert show];
    alert.leftBlock = ^() {
        //NSLog(@"取消");
    };
    alert.rightBlock = ^() {
        [self setOrderNumber];
        OrderNeedPayCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:button.tag inSection:0]];
        NSString *order_id = [cell.cellData valueForKeyPath:@"order_id"];
        
        NSDictionary* attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"order_id":order_id,
                                     };
        [[AppLogic sharedInstance] cancelOrder:attributes success:^{
            [orderDataArray removeObjectAtIndex:button.tag];
            [tableView reloadData];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
        [self setOrderNumber];
    };
}

- (void)payOrder:(UIButton *)button{
    OrderNeedPayCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:button.tag inSection:0]];
    NSString *order_number = [cell.cellData valueForKeyPath:@"order_number"];
    [AppLogic sharedInstance].order_number = order_number;
    PayViewController *payViewController = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
    payViewController.payPrice = [[cell.cellData valueForKeyPath:@"buy_price"] doubleValue];
    payViewController.goods_name = [cell.cellData valueForKeyPath:@"goods_name"];
    payViewController.payType = PAY_TYPE_NORMAL;
    [self.navigationController pushViewController:payViewController animated:YES];
}

-(void)toComment:(UIButton *)button{
    OrderNeedPayCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:button.tag inSection:0]];
    //NSString *order_number = [cell.cellData valueForKeyPath:@"order_number"];
    CommentViewController *commentViewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    commentViewController.order_id = [cell.cellData valueForKey:@"order_id"];
    commentViewController.goods_id = [cell.cellData valueForKey:@"goods_id"];
    commentViewController.goods_image = [cell.cellData valueForKey:@"goods_image"];
    commentViewController.goods_name = [cell.cellData valueForKey:@"goods_name"];
    commentViewController.goods_price = [cell.cellData valueForKey:@"buy_price"];
    commentViewController.goods_time = cell.date.text;
    [self.navigationController pushViewController:commentViewController animated:YES];
}

-(void)setIndicatorLinePosition{
    if(orderMode==ORDER_NO_PAY){
        indicatorLine1.hidden = NO;
        indicatorLine2.hidden = YES;
        indicatorLine3.hidden = YES;
        indicatorLine4.hidden = YES;
    }else if(orderMode==ORDER_NO_GET){
        indicatorLine1.hidden = YES;
        indicatorLine2.hidden = NO;
        indicatorLine3.hidden = YES;
        indicatorLine4.hidden = YES;
    }else if(orderMode==ORDER_NO_COMMENTS){
        indicatorLine1.hidden = YES;
        indicatorLine2.hidden = YES;
        indicatorLine3.hidden = NO;
        indicatorLine4.hidden = YES;
    }else if(orderMode==ORDER_IS_OVER){
        indicatorLine1.hidden = YES;
        indicatorLine2.hidden = YES;
        indicatorLine3.hidden = YES;
        indicatorLine4.hidden = NO;
    }
}
-(void)refreshContent{
    [self setIndicatorLinePosition];
    page = 1;
    NSDictionary* attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"page":[NSString stringWithFormat:@"%d",page],
                                 @"pagesize":[NSString stringWithFormat:@"%d",ORDER_LIST_PAGE_SIZE]
                                 };
    
    [[AppLogic sharedInstance] getOrderByType:orderMode :attributes success:^(NSArray *listData) {
        [orderDataArray removeAllObjects];
        [orderDataArray addObjectsFromArray:listData];
        [tableView reloadData];
        if([orderDataArray count]==0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noOrderList"]];
        }
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)setOrderNumber{
    NSDictionary* attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"page":[NSString stringWithFormat:@"%d",1],
                                 @"pagesize":[NSString stringWithFormat:@"%d",100000]
                                 };
    [[AppLogic sharedInstance] getOrderByType:ORDER_NO_PAY :attributes success:^(NSArray *listData) {
        int tab1Num = (int)[listData count];
        [numView1 setNum:tab1Num];
        if(tab1Num>0){
            numView1.hidden=NO;
        }else{
            numView1.hidden=YES;
        }
        //NSLog(@"数字是__%d",tab1Num);
    } fail:^(NSString *message) {
        //[[AppLogic sharedInstance] makeToast:message];
    }];
    [[AppLogic sharedInstance] getOrderByType:ORDER_NO_GET :attributes success:^(NSArray *listData) {
        int tab2Num = (int)[listData count];
        [numView2 setNum:tab2Num];
        if(tab2Num>0){
            numView2.hidden=NO;
        }else{
            numView2.hidden=YES;
        }
        //NSLog(@"数字是__%d",tab2Num);
    } fail:^(NSString *message) {
        //[[AppLogic sharedInstance] makeToast:message];
    }];
    [[AppLogic sharedInstance] getOrderByType:ORDER_NO_COMMENTS :attributes success:^(NSArray *listData) {
        int tab3Num = (int)[listData count];
        [numView3 setNum:tab3Num];
        if(tab3Num>0){
            numView3.hidden=NO;
        }else{
            numView3.hidden=YES;
        }
        //NSLog(@"数字是__%d",tab3Num);
    } fail:^(NSString *message) {
        //[[AppLogic sharedInstance] makeToast:message];
    }];
    [[AppLogic sharedInstance] getOrderByType:ORDER_IS_OVER :attributes success:^(NSArray *listData) {
        int tab4Num = (int)[listData count];
        [numView4 setNum:tab4Num];
        //NSLog(@"数字是__%d",tab4Num);
    } fail:^(NSString *message) {
        //[[AppLogic sharedInstance] makeToast:message];
    }];
    
    
    
    
    
    /*
    NSDictionary* attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"page":[NSString stringWithFormat:@"%d",1],
                                 @"pagesize":[NSString stringWithFormat:@"%d",100000]
                                 };
    
    [[AppLogic sharedInstance] getOrderByType:ORDER_ALL :attributes success:^(NSArray *listData) {
        
        
        int tab1Num = 0;
        int tab2Num = 0;
        int tab3Num = 0;
        int tab4Num = 0;
        
        for(int i=0;i<[listData count];i++){
            NSDictionary *eachData = [listData objectAtIndex:i];
            if([[eachData valueForKeyPath:@"pay_status"] intValue]==1
               ){
                tab1Num++;
            }
            
            if([[eachData valueForKeyPath:@"pay_status"] intValue]==3
               &&[[eachData valueForKeyPath:@"apply_status"] intValue]==1//1无申请状态 2
               &&[[eachData valueForKeyPath:@"is_contents"] intValue]==2
               &&[[eachData valueForKeyPath:@"hav_status"] intValue]==1
               ){
                tab2Num++;
            }
            
            if([[eachData valueForKeyPath:@"is_contents"] intValue]==2
               &&[[eachData valueForKeyPath:@"pay_status"] intValue]==3
               &&[[eachData valueForKeyPath:@"hav_status"] intValue]==3
               ){
                tab3Num++;
            }
            
            if([[eachData valueForKeyPath:@"is_over"] intValue]==1
               ){
                tab4Num++;
            }
        }
        
        NSLog(@"数字__%d__%d__%d___%d",tab1Num,tab2Num,tab3Num,tab4Num);
        
        
        
        
        
        
    } fail:^(NSString *message) {
        //[[AppLogic sharedInstance] makeToast:message];
    }];*/
}


- (IBAction)tab1Click:(id)sender {
    orderMode = ORDER_NO_PAY;
    [self refreshContent];
}

- (IBAction)tab1BtnClick:(id)sender {
    orderMode = ORDER_NO_PAY;
    [self refreshContent];
}

- (IBAction)tab2Click:(id)sender {
    orderMode = ORDER_NO_GET;
    [self refreshContent];
}

- (IBAction)tab2BtnClick:(id)sender {
    orderMode = ORDER_NO_GET;
    [self refreshContent];
}

- (IBAction)tab3Click:(id)sender {
    orderMode = ORDER_NO_COMMENTS;
    [self refreshContent];
}

- (IBAction)tab3BtnClick:(id)sender {
    orderMode = ORDER_NO_COMMENTS;
    [self refreshContent];
}

- (IBAction)tab4Click:(id)sender {
    orderMode = ORDER_IS_OVER;
    [self refreshContent];
}

- (IBAction)tab4BtnClick:(id)sender {
    orderMode = ORDER_IS_OVER;
    [self refreshContent];
}

-(void)confirmUse:(UIButton *)button{
    OrderNeedPayCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:button.tag inSection:0]];
    
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"order_id":[cell.cellData valueForKeyPath:@"order_id"],
                                 };
    [[AppLogic sharedInstance] confirmUseOrder:attributes success:^{
         orderMode = ORDER_NO_COMMENTS;
        [self refreshContent];
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"useSuccess"]];
        [self setOrderNumber];
    } fail:^(NSString *message) {
        [self refreshContent];
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
}

-(void)applyForMoneyBack:(UIButton *)button{
    OrderNeedPayCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:button.tag inSection:0]];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:[CommonUtil getStrByKey:@"applyTip"] contentText:[CommonUtil getStrByKey:@"applyTip"] leftButtonTitle:[CommonUtil getStrByKey:@"cancel"] rightButtonTitle:[CommonUtil getStrByKey:@"confirm"]];
    [alert show];
    alert.leftBlock = ^() {
        //NSLog(@"取消");
    };
    alert.rightBlock = ^() {
        [self setOrderNumber];
        NSDictionary *attributes = @{
                                     @"title":@"",
                                     @"content":@"",
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"order_id":[cell.cellData valueForKeyPath:@"order_id"],
                                     };
        [[AppLogic sharedInstance] getMoneyBack:attributes success:^{
            [self refreshContent];
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"haveApply"]];
        } fail:^(NSString *message) {
            [self refreshContent];
            [[AppLogic sharedInstance] makeToast:message];
        }];
    };
    
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
        
        [[AppLogic sharedInstance] getOrderByType:orderMode :attributes success:^(NSArray *listData) {
            if([orderDataArray count]==0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noOrderList"]];
            }
            [orderDataArray removeAllObjects];
            [orderDataArray addObjectsFromArray:listData];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        if([orderDataArray count] != (page*ORDER_LIST_PAGE_SIZE)){
            [self.tableView footerEndRefreshing];
            return;
        }
        
        NSDictionary* attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"page":[NSString stringWithFormat:@"%d",page+1],
                                     @"pagesize":[NSString stringWithFormat:@"%d",ORDER_LIST_PAGE_SIZE]
                                     };
        
        [[AppLogic sharedInstance] getOrderByType:orderMode :attributes success:^(NSArray *listData) {
            if(![listData isKindOfClass:[NSArray class]] || [orderDataArray count]==0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noMoreOrder"]];
            }else{
                [orderDataArray addObjectsFromArray:listData];
                page++;
            }
            
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
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


- (void)deleteOver:(UIButton *)button{
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:[CommonUtil getStrByKey:@"deleteOrderTip"] contentText:[CommonUtil getStrByKey:@"deleteOrderTip"] leftButtonTitle:[CommonUtil getStrByKey:@"cancel"] rightButtonTitle:[CommonUtil getStrByKey:@"confirm"]];
    [alert show];
    alert.leftBlock = ^() {
        //NSLog(@"取消");
    };
    alert.rightBlock = ^() {
        OrderNeedPayCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath  indexPathForRow:button.tag inSection:0]];
        NSString *order_id = [cell.cellData valueForKeyPath:@"order_id"];
        
        NSDictionary* attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"order_id":order_id,
                                     };
        [[AppLogic sharedInstance] hideOrder:attributes success:^{
            [orderDataArray removeObjectAtIndex:button.tag];
            [tableView reloadData];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
        [self setOrderNumber];
    };
}

@end

