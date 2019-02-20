//
//  WithDrawCashViewController.m
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "WithDrawCashViewController.h"
#import "CommonUtil.h"
#import "WithDrawCashToAliPayController.h"
#import "WithDrawCashToBankViewController.h"
#import "AppLogic.h"

@interface WithDrawCashViewController (){
    NSTimer *timer;
}
@end

@implementation WithDrawCashViewController

@synthesize checkbox1;
@synthesize checkbox2;
@synthesize line;
@synthesize confirmBtn;
@synthesize moneyContent;
@synthesize moneyTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CommonUtil getStrByKey:@"withDrawCashTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    moneyTitle.textColor = [CommonUtil getColor:@"4a4a4a"];
    moneyContent.textColor = [CommonUtil getColor:@"fd682b"];
    checkbox1.selected = YES;
    checkbox2.selected = NO;
    [checkbox1 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox1 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [checkbox2 setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [checkbox2 setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 3.0f;
    // Do any additional setup after loading the view from its nib.
    moneyContent.text = [NSString stringWithFormat:@"%.2f元",[AppLogic sharedInstance].myMoney];
}


- (void)getMoneyTimer:(NSTimer*)theTimer{
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 };
    [[AppLogic sharedInstance] getMoney:attributes success:^{
        moneyContent.text = [NSString stringWithFormat:@"%.2f元",[AppLogic sharedInstance].myMoney];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(getMoneyTimer:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
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

- (IBAction)checkBoxClick1:(UIButton*)btn {
    btn.selected=!btn.selected;
    if(btn.selected){
        checkbox2.selected = NO;
    }
}
- (IBAction)checkBoxClick2:(UIButton*)btn{
    btn.selected=!btn.selected;
    if(btn.selected){
        checkbox1.selected = NO;
    }
}
- (IBAction)confirm:(id)sender {
    if(checkbox1.selected){
        [self.navigationController pushViewController:[[WithDrawCashToAliPayController alloc] initWithNibName:@"WithDrawCashToAliPayController" bundle:nil] animated:YES];
    }else{
        [self.navigationController pushViewController:[[WithDrawCashToBankViewController alloc] initWithNibName:@"WithDrawCashToBankViewController" bundle:nil] animated:YES];
    }
}

@end
