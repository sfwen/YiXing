//
//  SearchViewController.m
//  easyTravel
//
//  Created by IOS002 on 16/2/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SearchViewController.h"
#import "ArticleDetailController.h"
#import "AppLogic.h"
#import "CommonUtil.h"

@interface SearchViewController ()<UISearchBarDelegate> {
    
    IBOutlet UITableView *_tableView;
    NSMutableArray *_titleArr;
}

@end

#define KViewWidth [UIScreen mainScreen].bounds.size.width
#define KTitle @"title"
#define KCid   @"cid"

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

/**
 * 搭建navigationItem
 */
- (UIView *)buildNavigationTitleView {
    UISearchBar *search = [[UISearchBar alloc] initWithFrame:CGRectMake(16, 20, KViewWidth - 32, 40)];
    search.delegate = self;
    search.layer.cornerRadius = 5.0;
    search.tintColor = [UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:0.4];
    search.placeholder = @"问题/关键字";
    [search becomeFirstResponder];
    search.searchBarStyle = UISearchBarStyleMinimal;
    return search;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getNavigationBarBgColor];
    self.navigationItem.titleView = [self buildNavigationTitleView];
    _titleArr = [NSMutableArray array];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Do any additional setup after loading the view from its nib.
}

- (void)addBackButton {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 31);
    [btn setImage:[UIImage imageNamed:@"btn_back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_back_d"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBackPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

/**
 * 返回
 */
- (void)btnBackPressed {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSDictionary *dic = @{@"key":searchBar.text};
    [[AppLogic sharedInstance] searchArticleWithAttributtes:dic success:^(NSArray *data) {
        for (NSDictionary *dic in data) {
            NSString *str = [dic valueForKeyPath:@"title"];
            NSString *cidStr = [dic valueForKeyPath:@"id"];
            NSDictionary *objDic = @{KTitle:str,KCid:cidStr};
            [_titleArr addObject:objDic];
            [_tableView reloadData];
        }
    } fail:nil];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = _titleArr[indexPath.row];
    cell.textLabel.text = [dic valueForKeyPath:KTitle];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
    
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
