//
//  VipLobbyViewController.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VipLobbyViewController.h"
#import "CommonUtil.h"
#import "VipLobbyCell.h"
#import "VipViewController.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "MJRefresh.h"
#import "CommonUtil.h"

@interface VipLobbyViewController (){
}
@end

@implementation VipLobbyViewController

@synthesize tableView;
@synthesize searchContainer;
@synthesize searchText;
@synthesize data;
@synthesize page;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)back:(id)sender{
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    data = [[NSMutableArray alloc] init];
    self.title=[CommonUtil getStrByKey:@"vipLobbyTitle"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getNavigationBarBgColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [CommonUtil getColor:@"ffffff"],UITextAttributeTextColor,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
                                                                     
    // Do any additional setup after loading the view from its nib.
    searchContainer.layer.borderWidth=1;
    searchContainer.layer.cornerRadius=6;
    searchContainer.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    [tableView registerNib:[UINib nibWithNibName:@"VipLobbyCell" bundle:nil] forCellReuseIdentifier:@"VipLobbyCell"];
    tableView.showsVerticalScrollIndicator=YES;
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    searchText.delegate = self;
    searchText.returnKeyType = UIReturnKeySearch;
    [self doSearch:nil];
    
    // 2.集成刷新控件
    [self setupRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [searchText resignFirstResponder];
    [self doSearch:searchText.text];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    VipLobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipLobbyCell"];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height+1;*/
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
    //return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VipLobbyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VipLobbyCell"];
    [cell setData:[data objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VipLobbyCell *cell = (VipLobbyCell *)[tableView cellForRowAtIndexPath:indexPath];
    VipViewController *viewController = [[VipViewController alloc] initWithNibName:@"VipViewController" bundle:nil];
    viewController.goods_id = [cell.cellData valueForKeyPath:@"goods_id"];
    viewController.goods_price = [cell.cellData valueForKeyPath:@"goods_price"];
    [self.navigationController pushViewController:viewController animated:YES];
}



- (void)setupRefresh
{
     __weak VipLobbyViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.page = 1;
        NSDictionary *attributes = @{
                                     @"page":[NSString stringWithFormat:@"%d",weakSelf.page],
                                     @"pagesize":[NSString stringWithFormat:@"%d",LOBBY_LIST_PAGE_SIZE],
                                     @"select":searchText.text
                                     };
        [[AppLogic sharedInstance] getVipLobbyList:attributes success:^(NSArray *listData){
            if([listData count]<=0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noSearchContent"]];
            }else{
                if([listData count]<LOBBY_LIST_PAGE_SIZE){
                    [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"loadAll"]];
                }
            }
            [weakSelf.data removeAllObjects];
            [weakSelf.data addObjectsFromArray:listData];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView headerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    
    [self.tableView addFooterWithCallback:^{
        if([weakSelf.data count] != (weakSelf.page*LOBBY_LIST_PAGE_SIZE)){
            [weakSelf.tableView footerEndRefreshing];
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"loadAll"]];
            return;
        }
        NSDictionary *attributes = @{
                                     @"page":[NSString stringWithFormat:@"%d",page+1],
                                     @"pagesize":[NSString stringWithFormat:@"%d",LOBBY_LIST_PAGE_SIZE],
                                     @"select":searchText.text
                                     };
        [[AppLogic sharedInstance] getVipLobbyList:attributes success:^(NSArray *listData){
            if([listData count]<=0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"loadAll"]];
            }else{
                if([listData count]<LOBBY_LIST_PAGE_SIZE){
                    [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"loadAll"]];
                }
                if([listData count]==LOBBY_LIST_PAGE_SIZE){
                    weakSelf.page++;
                }
            }
            [weakSelf.data addObjectsFromArray:listData];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView footerEndRefreshing];
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

- (IBAction)doSearch:(id)sender {
    page = 1;
    __weak VipLobbyViewController *weakSelf = self;
    NSDictionary *attributes = @{
                                 @"page":[NSString stringWithFormat:@"%d",page],
                                 @"pagesize":[NSString stringWithFormat:@"%d",LOBBY_LIST_PAGE_SIZE],
                                 @"select":searchText.text
                                 };
    [[AppLogic sharedInstance] getVipLobbyList:attributes success:^(NSArray *listData){
        if([listData count]<=0){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noSearchContent"]];
        }
        [weakSelf.data removeAllObjects];
        [weakSelf.data addObjectsFromArray:listData];
        [weakSelf.tableView reloadData];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}
@end
