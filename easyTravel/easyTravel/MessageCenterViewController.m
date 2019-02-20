//
//  MessageCenterViewController.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "CommonUtil.h"
#import "MessageCenterTableViewCell.h"
#import "MessageDetailViewController.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "MJRefresh.h"
#import "CommonUtil.h"

@interface MessageCenterViewController (){
    NSMutableArray *data;
    int page;
}
@end

@implementation MessageCenterViewController
@synthesize tableView;
@synthesize line;
@synthesize topArea;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    data = [[NSMutableArray alloc] init];
    [tableView registerNib:[UINib nibWithNibName:@"MessageCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCenterTableViewCell"];
    tableView.showsVerticalScrollIndicator=NO;
    self.title = [CommonUtil getStrByKey:@"messageTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    topArea.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    // Do any additional setup after loading the view from its nib.
    
    
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"page":[NSString stringWithFormat:@"%d",page],
                                 @"pagesize":[NSString stringWithFormat:@"%d",LIST_PAGE_SIZE]
                                 };
    [[AppLogic sharedInstance] getMessageList:attributes success:^(NSArray *listData){
        if([listData count]<=0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noMsg"]];
        }
        [data removeAllObjects];
        [data addObjectsFromArray:listData];
        [tableView reloadData];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    [self setupRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 1;
}*/

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCenterTableViewCell"];
    
    cell.content.text = [data objectAtIndex:indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height+1;*/
    return 95;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCenterTableViewCell"];
    [cell setData:[data objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageCenterTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.icon.image = [UIImage imageNamed:@"oldMessage.png"];
    ((Msg*)[data objectAtIndex:indexPath.row]).is_read = 2;
    //[[data objectAtIndex:indexPath.row] setValue:[NSNumber numberWithInt:2] forKeyPath:@"is_read"];
    //[[data objectAtIndex:indexPath.row] setObject:[NSNumber numberWithInt:2] forKey:@"is_read"];
    MessageDetailViewController *detail = [[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController" bundle:nil];
    detail.msdId = ((Msg*)[data objectAtIndex:indexPath.row]).id;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)setupRefresh
{
    
    [self.tableView addHeaderWithCallback:^{
        page = 1;
        
        
        
        NSDictionary *attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"page":[NSString stringWithFormat:@"%d",page],
                                     @"pagesize":[NSString stringWithFormat:@"%d",LIST_PAGE_SIZE]
                                     };
        [[AppLogic sharedInstance] getMessageList:attributes success:^(NSArray *listData){
            if([listData count]<=0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noMsg"]];
            }
            [data removeAllObjects];
            [data addObjectsFromArray:listData];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    
    [self.tableView addFooterWithCallback:^{
        if([data count] != (page*LIST_PAGE_SIZE)){
            [self.tableView footerEndRefreshing];
            return;
        }
        
        NSDictionary *attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"page":[NSString stringWithFormat:@"%d",page+1],
                                     @"pagesize":[NSString stringWithFormat:@"%d",LIST_PAGE_SIZE]
                                     };
        [[AppLogic sharedInstance] getMessageList:attributes success:^(NSArray *listData){
            if([listData count]<=0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noMsg"]];
            }else{
                page++;
            }
            [data addObjectsFromArray:listData];
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
