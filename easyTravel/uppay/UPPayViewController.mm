//
//  UPPayViewController.m
//  easyTravel
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UPPayViewController.h"
#import "UPPayPlugin.h"
#import "AppLogic.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "CommonUtil.h"
#import "VipOrderViewController.h"
#import "VipViewController.h"


#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80
#define kCellHeight_Normal  50
#define kCellHeight_Manual  145

#define kVCTitle          @"商户测试"
#define kBtnFirstTitle    @"获取订单，开始测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"


#define kMode_Development             @"01"
#define kMode_Release             @"00"
#define kURL_TN_Normal                @"http://202.101.25.178:8080/sim/gettn"
#define kURL_TN_Configure             @"http://202.101.25.178:8080/sim/app.jsp?user=123456789"

#define UPRelease(X) if (X !=nil) {[X release];X = nil;}

@interface UPPayViewController (){
    NSMutableData* _responseData;
}

@property(nonatomic, copy)NSString *tnMode;

@end

@implementation UPPayViewController

@synthesize tnMode;
@synthesize tn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[CommonUtil getStrByKey:@"upPayTitle"];
    self.tnMode = kMode_Release;
    [UPPayPlugin startPay:tn mode:self.tnMode viewController:self delegate:self];
    //[self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
}

- (void)startNetWithURL:(NSURL *)url
{
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
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


#pragma mark - connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        [[AppLogic sharedInstance] makeToast:kErrorNet];
        [connection cancel];
    }
    else
    {
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        NSLog(@"tn=%@",tn);
        [UPPayPlugin startPay:tn mode:self.tnMode viewController:self delegate:self];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[AppLogic sharedInstance] makeToast:kErrorNet];
}


//银联回调
- (void)UPPayPluginResult:(NSString *)result
{
    //NSString* msg = [NSString stringWithFormat:@"支付结果：%@", result];
    //[[AppLogic sharedInstance] makeToast:msg];
    
    
    
    if([result isEqualToString:@"fail"]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"upPayFail"]];
        [self.navigationController popViewControllerAnimated:NO];
    }else if([result isEqualToString:@"cancel"]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"upPayCancel"]];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"upPaySuccess"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[VipOrderViewController class]]) {
                [self.navigationController popToViewController:temp animated:NO];
            }
        }
        
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[VipViewController class]]) {
                [self.navigationController popToViewController:temp animated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
            }
        }
    }
    
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

@end
