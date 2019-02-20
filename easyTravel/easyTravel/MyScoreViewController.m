//
//  MyScoreViewController.m
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyScoreViewController.h"
#import "CommonUtil.h"
#import "AppLogic.h"
#import "MJRefresh.h"
#import "ScoreCell.h"

@interface MyScoreViewController (){
    NSMutableArray *scoreDataArray;
    int page;
}

@end

@implementation MyScoreViewController

@synthesize myScoreLabel;
@synthesize myscoreLabel2;
@synthesize score;
@synthesize tableView;
@synthesize line;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[CommonUtil getStrByKey:@"scoreViewControllerTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f9f9f9"];
    // Do any additional setup after loading the view from its nib.
    page = 1;
    scoreDataArray = [[NSMutableArray alloc] init];
    [tableView registerNib:[UINib nibWithNibName:@"ScoreCell" bundle:nil] forCellReuseIdentifier:@"ScoreCell"];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    [self setupRefresh];
    
    [[AppLogic sharedInstance] getScore:@{@"ucode":[AppLogic sharedInstance].ucode} success:^(NSString *score) {
        self.score.text = score;
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    [[AppLogic sharedInstance] getScoreList:@{@"ucode":[AppLogic sharedInstance].ucode} success:^(NSArray *scoreData) {
        //NSLog(@"%@",scoreData);
        [scoreDataArray addObjectsFromArray:scoreData];
        [tableView reloadData];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
    
    myScoreLabel.textColor = [CommonUtil getColor:@"ffb752"];
    myscoreLabel2.textColor = [CommonUtil getColor:@"ffb752"];
    score.textColor = [CommonUtil getColor:@"ff5157"];
    
    tableView.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    tableView.layer.borderWidth = 1.0f;
    line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        [[AppLogic sharedInstance] getScoreList:attributes success:^(NSArray *listData) {
            if([scoreDataArray count]==0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noOrderList"]];
            }
            [scoreDataArray removeAllObjects];
            [scoreDataArray addObjectsFromArray:listData];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    
    
    [self.tableView addFooterWithCallback:^{
        if([scoreDataArray count] != (page*ORDER_LIST_PAGE_SIZE)){
            [self.tableView footerEndRefreshing];
            return;
        }
        
        NSDictionary* attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"page":[NSString stringWithFormat:@"%d",page+1],
                                     @"pagesize":[NSString stringWithFormat:@"%d",ORDER_LIST_PAGE_SIZE]
                                     };
        
        [[AppLogic sharedInstance] getScoreList:attributes success:^(NSArray *listData) {
            if(![listData isKindOfClass:[NSArray class]] || [scoreDataArray count]==0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noMoreOrder"]];
            }else{
                [scoreDataArray addObjectsFromArray:listData];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [scoreDataArray count];
    //return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell"];
    //[cell setData:[orderDataArray objectAtIndex:indexPath.row]:indexPath.row];
    //cell.delegate = self;
    [cell setSelectionStyle:nil];
    [cell setData:[scoreDataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
