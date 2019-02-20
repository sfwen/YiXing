//
//  TrainTicketOrderViewController.m
//  easyTravel
//
//  Created by ChenChong on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TrainTicketOrderViewController.h"

@interface TrainTicketOrderViewController ()<UIWebViewDelegate>

@end

@implementation TrainTicketOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:97 / 255.0 green:197 / 255.0 blue:249 / 255.0 alpha:1];
    [self.view addSubview:view];
     _webView.delegate = self;
    //隐藏导航
      [[self navigationController] setNavigationBarHidden:YES animated:NO];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://accounts.ctrip.com/H5Login/MobileValidate?from=http%3A%2F%2Fm.ctrip.com%2Fwebapp%2Fmyctrip%2Forders%2Ftrainorderlist&backUrl=http://m.ctrip.com/webapp/train/home/index"]];
    [self.view addSubview: _webView];
    [_webView loadRequest:request];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
     [[self navigationController] setNavigationBarHidden:YES animated:NO];
    NSLog(@"%@",request.URL);
    if ([request.URL isEqual:[NSURL URLWithString:@"http://m.ctrip.com/webapp/train/home/index"]] || [request.URL isEqual:[NSURL URLWithString:@"http://m.ctrip.com/html5/"]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
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

@end
