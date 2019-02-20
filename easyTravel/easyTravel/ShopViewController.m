//
//  ShopViewController.m
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ShopViewController.h"
#import "AppLogic.h"
#import "ArticleListViewController.h"
#import "ArticleDetailController.h"
#import "SearchViewController.h"

@interface ShopViewController ()<UIWebViewDelegate,UISearchBarDelegate> {
    
    IBOutlet UITableView *_tableView;
    NSMutableArray *_titleArr;
}

@end

#define KViewWidth [UIScreen mainScreen].bounds.size.width

#define KTitle @"title"
#define KCid   @"cid"

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    _titleArr = @[@[@"投诉建议"],@[@"怎么参加#返现#?",@"#优惠券#如何使用?",@"怎么查我的#订单#?",@"#积分#如何使用?"]];
    _titleArr = [NSMutableArray array];
    _tableView.tableHeaderView = [self buildTalbeHeaderView];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self refreshControl];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/**
 * 搭建界面
 */
- (UIView *)buildTalbeHeaderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KViewWidth, 200)];
    CGFloat pointY = 0;
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KViewWidth, KViewWidth / 17 * 7)];
    img.image = [UIImage imageNamed:@"backImg.jpg"];
    img.userInteractionEnabled = YES;
//    搜索框
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(16, 20, KViewWidth - 32, 40)];
    search.delegate = self;
    search.layer.cornerRadius = 5.0;
    search.tintColor = [UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:0.4];
    search.placeholder = @"问题/关键字";
    search.searchBarStyle = UISearchBarStyleMinimal;
    [img addSubview:search];
//    电话咨询、在线咨询
    CGFloat padding = (KViewWidth - 80) / 3;
    NSArray *btnImgArr = @[@"onLine",@"callphone"];
    NSArray *btnTitleArr = @[@"在线咨询",@"电话咨询"];
    for (int i = 0; i < 2; i ++) {
        UIButton *callPhone = [[UIButton alloc] initWithFrame:CGRectMake(padding + (padding + 40) * i, img.frame.size.height - 70, 40, 40)];
        callPhone.layer.cornerRadius = callPhone.frame.size.height / 2;
        callPhone.layer.masksToBounds = YES;
        [callPhone setBackgroundImage:[UIImage imageNamed:btnImgArr[i]] forState:UIControlStateNormal];
        callPhone.tag = i;
        [callPhone addTarget:self action:@selector(referActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        [img addSubview:callPhone];
        UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(padding + 20 - 60 + (padding + 40) * i, img.frame.size.height - 30, 120, 25)];
        phoneLab.textAlignment = NSTextAlignmentCenter;
        phoneLab.text = btnTitleArr[i];
        phoneLab.textColor = [UIColor whiteColor];
        [img addSubview:phoneLab];
        [view addSubview:img];
    }
    pointY = img.frame.size.height;
//    热门问题
    padding = (KViewWidth - 200) / 4;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(KViewWidth / 2 - 40, pointY, 80, 30)];
    lab.text = @"热门问题";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithRed:154 / 255.0 green:155 / 255.0 blue:154 / 255.0 alpha:1];
    [view addSubview:lab];
    for (int i = 0; i < 2; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(padding / 2 + (40 + KViewWidth / 2) * i, pointY + lab.frame.size.height / 2, KViewWidth / 2  - padding - 40, 0.8)];
        lineView.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1];
        [view addSubview:lineView];
    }
    pointY += lab.frame.size.height;
    NSArray *labArr = @[@"贵宾厅相关",@"酒店相关",@"火车票相关",@"机票相关",@"门票相关",@"贵宾卡相关",@"账户服务相关",@"官方网站"];
    NSArray *imgArr = @[@"ting",@"hotal",@"train",@"fly",@"door",@"vip1",@"account1",@"web"];
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 4; j ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(padding / 2 + (50 + padding) * j, pointY + (50 + 25 + 10) * i, 50, 50)];
            btn.tag = i * 4 + j;
            [btn setBackgroundImage:[UIImage imageNamed:imgArr [i * 4 + j]] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5.0;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(btnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            UILabel *btnTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(KViewWidth / 4 * j,pointY + 50 + (50 + 25 + 10) * i , KViewWidth / 4, 25)];
            btnTitleLab.text = labArr[i * 4 + j];
            btnTitleLab.textAlignment = NSTextAlignmentCenter;
            btnTitleLab.font = [UIFont systemFontOfSize:13];
            [view addSubview:btnTitleLab];
        }
    }
    CGRect rect = view.frame;
    rect.size = CGSizeMake(KViewWidth, pointY + 75 * 2 + 20 + 5);
    view.frame = rect;
//
    return view;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    [searchBar resignFirstResponder];
}

/**
 * 咨询
 */
- (void)referActionWithSender:(UIButton *)sender {
    if (sender.tag == 0) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
            [self pushQQChatView];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你未安装QQ" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (sender.tag == 1) {
        NSString *phoneNumStr = [NSString stringWithFormat:@"tel://4000809555"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumStr]];
    }
}

- (void)btnActionWithSender:(UIButton *)sender {
    NSInteger cid;
    NSString *titleStr;
    switch (sender.tag) {
        case 0:
            cid = 41;
            titleStr = @"贵宾厅";
            break;
        case 1:
            cid = 42;
            titleStr = @"酒店";
            break;
        case 2:
            cid = 43;
            titleStr = @"火车票";
            break;
        case 3:
            cid = 44;
            titleStr = @"机票";
            break;
        case 4:
            cid = 45;
            titleStr = @"门票";
            break;
        case 5:
            cid = 46;
            titleStr = @"贵宾卡";
            break;
        case 6:
            cid = 47;
            titleStr = @"账户服务";
            break;
        case 7:
            cid = 48;
            titleStr = @"官方网站";
            break;
        default:
            break;
    }
//    NSString *cidStr = [NSString stringWithFormat:@"%ld",(long)cid];
//    NSDictionary *dic = @{@"cid":cidStr};
//    [[AppLogic sharedInstance] getarticleListWithAttributtes:dic success:nil fail:nil];
    ArticleListViewController *articleList = [[ArticleListViewController alloc] init];
    articleList.titleStr = titleStr;
    articleList.selectCid = cid;
    [self.navigationController pushViewController:articleList animated:YES];
}

/**
 * 弹出qq聊天界面
 */
- (void)pushQQChatView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=4000809555&version=1&src_type=web"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

/**
 * 刷新界面
 */
- (void)refreshControl {
    [[AppLogic sharedInstance]getRecommendArtcleListSuccess:^(NSArray *data) {
        for (NSDictionary *dic in data) {
            NSString *str = [dic valueForKeyPath:@"title"];
            NSString *cidStr = [dic valueForKeyPath:@"id"];
            NSDictionary *objDic = @{KTitle:str,KCid:cidStr};
            [_titleArr addObject:objDic];
            [_tableView reloadData];
        }
    } fail:nil];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *secArr = _titleArr[indexPath.section];
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = _titleArr[indexPath.row];
    cell.textLabel.text = [dic valueForKeyPath:KTitle];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _titleArr[indexPath.row];
    NSString *str = [dic valueForKey:KCid];
//    NSDictionary *attributtes = @{@"ID":str};
//    [[AppLogic sharedInstance]getArticleDetailWithAttributtes:str success:nil fail:nil];
    ArticleDetailController *articleDetailVC = [[ArticleDetailController alloc] init];
    articleDetailVC.IDString = str;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
