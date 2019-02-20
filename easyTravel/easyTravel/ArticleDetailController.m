//
//  ArticleDetailController.m
//  easyTravel
//
//  Created by IOS002 on 16/2/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ArticleDetailController.h"
#import "CommonUtil.h"

@interface ArticleDetailController () {
    
    IBOutlet UIWebView *_webView;
}

@end

@implementation ArticleDetailController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getNavigationBarBgColor];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://yixing.zgcom.cn/api.php/Document/info/did/%@",_IDString]];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
