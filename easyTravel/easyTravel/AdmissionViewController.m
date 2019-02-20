//
//  AdmissionViewController.m
//  easyTravel
//
//  Created by ChenChong on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "AdmissionViewController.h"
#import "MainViewController.h"
@interface AdmissionViewController ()<UIWebViewDelegate>

@end

@implementation AdmissionViewController
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
- (void)back:(id)sender{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.ctrip.com/webapp/ticket/index?allianceid=286932&sid=749312&popup=close&autoawaken=close"]];
    _webView.delegate = self;
    [self.view addSubview: _webView];
    [_webView loadRequest:request];
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
//    }
//    return self;
//}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航
    // 191 237 255
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:97 / 255.0 green:197 / 255.0 blue:249 / 255.0 alpha:1];
   [self.view addSubview:view];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.ctrip.com/webapp/ticket/index?allianceid=286932&sid=749312&popup=close&autoawaken=close"]];
 

    _webView.delegate = self;
    [self.view addSubview: _webView];
    [_webView loadRequest:request];
   
}
//-(void)viewWillAppear:(BOOL)animated{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
//    view.backgroundColor = [UIColor colorWithRed:97 / 255.0 green:197 / 255.0 blue:249 / 255.0 alpha:1];
//    [self.view addSubview:view];
//
//      _webView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlSrt = [NSString stringWithFormat:@"%@",request.URL];
    NSLog(@"%@",urlSrt);
    NSLog(@"%lu",(unsigned long)urlSrt.length);
    
    NSLog(@"%@",request.URL);
    int i = 20;
    NSString *urlStr2 = [urlSrt substringToIndex:i - 1];
    NSLog(@"%@",urlStr2);
    
    
    
    if ([request.URL isEqual:[NSURL URLWithString:@"http://m.ctrip.com/html5/"]] || [request.URL isEqual:@"http://m.ctrip.com/webapp/train/home/index"] || [request.URL isEqual:@"http://m.ctrip.com/html5/"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
     }
        else if ([request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201511/vacation/winter/app/app-mod2.html?ctm_ref=tkt_hp_sub_cp_1"]]){
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else if([request.URL isEqual:[NSURL URLWithString:@"http://m.ctrip.com/webapp/ticket/index?allianceid=286932&sid=749312&popup=close&autoawaken=close"]]){
            [[self navigationController] setNavigationBarHidden:YES animated:NO];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
            view.backgroundColor = [UIColor colorWithRed:97 / 255.0 green:197 / 255.0 blue:249 / 255.0 alpha:1];
            [self.view addSubview:view];
            _webView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20);
            
        }else if ([request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201511/vacation/winter/app/app-mod2.html?disable_webview_cache_key=1&target=ticket&ctm_ref=tkt_hp_ban_ukn_2"]]){
            [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else if ([request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201510/vacation/tqr2.0/app-mod1.html?disable_webview_cache_key=1&target=ticket&ctm_ref=tkt_hp_ban_ukn_1"]]){
            [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else if ([request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201510/vacation/tqr2.0/app-mod1.html?ctm_ref=tkt_hp_sub_cp_2"]]){
            [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else if ([request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201509/vacation/yhd/app-mod1.html?ctm_ref=tkt_hp_sub_cp_3"]]){
            [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else if ([request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201512/vacation/christmas/app-mod1.html?ctm_ref=tkt_hp_sub_cp_4"]]){
            [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else if  ([urlStr2 isEqualToString:@"ctrip://wireless/h5"]){
            
            [[self navigationController] setNavigationBarHidden:NO animated:NO];
            _webView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
        }else{
             //if (![request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201511/vacation/winter/app/app-mod2.html?ctm_ref=tkt_hp_sub_cp_1"]] || ![request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201511/vacation/winter/app/app-mod2.html?disable_webview_cache_key=1&target=ticket&ctm_ref=tkt_hp_ban_ukn_2"]] ||![request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201510/vacation/tqr2.0/app-mod1.html?disable_webview_cache_key=1&target=ticket&ctm_ref=tkt_hp_ban_ukn_1"]] || ![request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201510/vacation/tqr2.0/app-mod1.html?ctm_ref=tkt_hp_sub_cp_2"]] || ![request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201509/vacation/yhd/app-mod1.html?ctm_ref=tkt_hp_sub_cp_3"]] || ![request.URL isEqual:[NSURL URLWithString:@"http://pages.ctrip.com/commerce/promote/201512/vacation/christmas/app-mod1.html?ctm_ref=tkt_hp_sub_cp_4"]] ) {
            [[self navigationController] setNavigationBarHidden:YES animated:NO];
            _webView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20);
            
        }
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

@end
