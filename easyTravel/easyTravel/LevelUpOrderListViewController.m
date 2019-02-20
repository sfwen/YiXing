//
//  LevelUpOrderListViewController.m
//  easyTravel
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LevelUpOrderListViewController.h"
#import "PayViewController.h"
#import "CustomAlertView.h"
#import "CommonUtil.h"
#import "CommentViewController.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "MJRefresh.h"
#import "CommonUtil.h"
#import "LevelUpCell.h"



@interface LevelUpOrderListViewController (){
    NSMutableArray *orderDataArray;
    int page;
}
@end

@implementation LevelUpOrderListViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = [CommonUtil getStrByKey:@"levelUpListTitle"];
    orderDataArray = [[NSMutableArray alloc] init];
    [tableView registerNib:[UINib nibWithNibName:@"LevelUpCell" bundle:nil] forCellReuseIdentifier:@"LevelUpCell"];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    [self setupRefresh];
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode
                                 };
    [[AppLogic sharedInstance] getLevelUpOrderList:attributes success:^(NSArray *data) {
        //NSLog(@"%@",data);
        [orderDataArray addObjectsFromArray:data];
        [tableView reloadData];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
    self.view.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LevelUpCell"];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //return height+1;
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LevelUpCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LevelUpCell"];
    //[cell setData:[orderDataArray objectAtIndex:indexPath.row]:indexPath.row];
    //cell.delegate = self;
    [cell setSelectionStyle:nil];
    [cell setData:[orderDataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        
        [[AppLogic sharedInstance] getLevelUpOrderList:attributes success:^(NSArray *listData) {
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
        
        [[AppLogic sharedInstance] getLevelUpOrderList:attributes success:^(NSArray *listData) {
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


@end
