//
//  UserViewController.m
//  easyTravel
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserViewController.h"
#import "CommonUtil.h"
#import "MeCell.h"
#import "ModifyPwdController.h"
#import "MeDetailViewController.h"
#import "MyAccountViewController.h"
#import "MessageCenterViewController.h"
#import "LoginViewController.h"
#import "MyScoreViewController.h"
#import "VipOrderViewController.h"
#import "CommentViewController.h"
#import "AppLogic.h"
#import "UIImageView+AFNetworking.h"
#import "AboutViewController.h"
#import "OrderEntryViewController.h"
#import "LevelUpViewController.h"
#import "AFAppDotNetAPIClient.h"

@interface UserViewController (){
    NSTimer *timer;
}
@end

@implementation UserViewController{
    NSArray *iconArray;
    NSArray *titleArray;
}


@synthesize exitBtn;
@synthesize loginBtn;
@synthesize levelUpBtn;
@synthesize tableView;
@synthesize head;
@synthesize vipImageView;


- (void)initDataSource {
    iconArray= [[NSArray alloc] initWithObjects:@"meIcon.png",@"accountIcon.png",@"scoreIcon.png",@"modifyPwdIcon.png",@"vipOrderIcon.png",@"msgCenterIcon.png",@"aIcon.png",nil];
    titleArray = [CommonUtil getArrayByKey:@"userTitleArray"];
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [tableView registerNib:[UINib nibWithNibName:@"MeCell" bundle:nil] forCellReuseIdentifier:@"MeCell"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getNavigationBarBgColor];
    
    
    //self.title = [CommonUtil getStrByKey:@"userTitle"];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    titleView.text = [CommonUtil getStrByKey:@"userTitle"];
    titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [CommonUtil getColor:@"ffffff"],UITextAttributeTextColor,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     
                                                                     nil]];
    loginBtn.layer.cornerRadius = 3.0f;
    loginBtn.layer.borderColor  = [CommonUtil getColor:@"0bc0f4"].CGColor;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.tintColor = [CommonUtil getColor:@"0bc0f4"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    levelUpBtn.tintColor = [CommonUtil getColor:@"000000"];

    // Do any additional setup after loading the view from its nib.
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    //tableView.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    tableView.separatorStyle = NO;
    tableView.scrollEnabled = YES;
    
    head.layer.masksToBounds =YES;
    head.layer.cornerRadius =30;
    //head.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",IMAGE_HOST,[AppLogic sharedInstance].head_img];
    [head setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head.jpg"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:@"updateUserInfo" object:nil];
    [self setAccountRelatedBtnInfo];
    
}

-(void)updateUserInfo:(NSNotification*) notification{
    [loginBtn setTitle:[[AppLogic sharedInstance].userInfo valueForKeyPath:@"real_name"] forState:UIControlStateNormal];
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",IMAGE_HOST,[AppLogic sharedInstance].head_img];
    [head setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head.jpg"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    if([AppLogic sharedInstance].isLogin){
        [loginBtn setTitle:[[AppLogic sharedInstance].userInfo valueForKeyPath:@"real_name"] forState:UIControlStateNormal];
        if(exitBtn==nil){
            exitBtn = [[UIBarButtonItem alloc] initWithTitle:[CommonUtil getStrByKey:@"exit"] style:UIBarButtonItemStyleDone target:self action:@selector(doExit:)];
            exitBtn.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = exitBtn;
        }
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        exitBtn = nil;
        head.image = [UIImage imageNamed:@"head.jpg"];
    }
    
    if([AppLogic sharedInstance].isLogin){
        [[AppLogic sharedInstance] getUserInfo:@{
                                                 @"ucode":[AppLogic sharedInstance].ucode,
        } success:^(NSDictionary *personInfo) {
            [loginBtn setTitle:[personInfo valueForKeyPath:@"real_name"] forState:UIControlStateNormal];
            [self setAccountRelatedBtnInfo];
        } fail:^(NSString *message) {
                                                     
        }];
    }
    
}

-(void)setAccountRelatedBtnInfo{
    //[AppLogic sharedInstance].vipFlag=2;
    if([AppLogic sharedInstance].vipFlag==1){//vip会员
        [vipImageView setImage:[UIImage imageNamed:@"v2.png"] forState:UIControlStateNormal];
        [levelUpBtn setTitle:[CommonUtil getStrByKey:@"v2Name"] forState:UIControlStateNormal];
    }else if([AppLogic sharedInstance].vipFlag==2){//普通用户
        [vipImageView setImage:[UIImage imageNamed:@"vipIcon.png"] forState:UIControlStateNormal];
        [levelUpBtn setTitle:[CommonUtil getStrByKey:@"levelUp"] forState:UIControlStateNormal];
    }else if([AppLogic sharedInstance].vipFlag==3){//砖石会员
        [vipImageView setImage:[UIImage imageNamed:@"v3.png"] forState:UIControlStateNormal];
        [levelUpBtn setTitle:[CommonUtil getStrByKey:@"v3Name"] forState:UIControlStateNormal];
    }
}

-(void)doExit:(id)sender{
    [[AppLogic sharedInstance] exit];
    [loginBtn setTitle:[CommonUtil getStrByKey:@"login"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = nil;
    exitBtn = nil;
    MeCell *cellOrder = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    MeCell *cellMessage = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    cellOrder.flag.hidden=YES;
    cellMessage.flag.hidden=YES;
    [AppLogic sharedInstance].vipFlag = 2;
    [self setAccountRelatedBtnInfo];
    head.image = [UIImage imageNamed:@"head.jpg"];
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

- (IBAction)doLogin:(id)sender {
    if([AppLogic sharedInstance].isLogin){
        return;
    }
    LoginViewController *loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [AppLogic sharedInstance].loginSuccessWillGoViewTag = 6;
    [self.navigationController pushViewController:loginController animated:YES];
}
- (IBAction)levelUp:(id)sender {
    if([AppLogic sharedInstance].vipFlag==3){//砖石会员
        //[[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isMostVip"]];
        //return;
    }
    [self toLevelUpView];
}

- (IBAction)buyVip:(id)sender {
    if([AppLogic sharedInstance].vipFlag==3){//砖石会员
        //[[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isMostVip"]];
        //return;
    }
     [self toLevelUpView];
}

-(void)toLevelUpView{
    if(![AppLogic sharedInstance].isLogin){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notLogin"]];
        return;
    }
    LevelUpViewController *levelUpViewController = [[LevelUpViewController alloc] initWithNibName:@"LevelUpViewController" bundle:nil];
    [self.navigationController pushViewController:levelUpViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
    /*
    if(IS_IPHONE_6P){
        return 50;
    }else if(IS_IPHONE_6){
        return 50;
    }else if(IS_IPHONE_5){
        return 50;
    }else{
        return 40;
    }*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeCell"];
    cell.imgIcon.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    cell.rowTitle.text = [titleArray objectAtIndex:indexPath.row];
    return cell;
}


-(void)toLoginViewController:(int)tag{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [AppLogic sharedInstance].loginSuccessWillGoViewTag = tag;
    [self.navigationController pushViewController:loginViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(![AppLogic sharedInstance].isLogin&&indexPath.row!=6){
        [self toLoginViewController:(int)indexPath.row];
        return;
    }
    switch (indexPath.row) {
        case 0:{
            if(![AppLogic sharedInstance].isLogin){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notLogin"]];
                return;
            }
            MeDetailViewController *meDetailViewController = [[MeDetailViewController alloc] initWithNibName:@"MeDetailViewController" bundle:nil];
            [self.navigationController pushViewController:meDetailViewController animated:YES];
        }
            break;
        case 1:{
            if(![AppLogic sharedInstance].isLogin){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notLogin"]];
                return;
            }
            MyAccountViewController *myAccountViewController = [[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil];
            [self.navigationController pushViewController:myAccountViewController animated:YES];
        }
            break;
        case 2:{
            MyScoreViewController *myScoreViewController = [[MyScoreViewController alloc] initWithNibName:@"MyScoreViewController" bundle:nil];
            [self.navigationController pushViewController:myScoreViewController animated:YES];
        }
            break;
        case 3:{
            if(![AppLogic sharedInstance].isLogin){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notLogin"]];
                return;
            }
            ModifyPwdController *pwdController = [[ModifyPwdController alloc] initWithNibName:@"ModifyPwdController" bundle:nil];
            [self.navigationController pushViewController:pwdController animated:YES];
        }
            break;
        case 4:{
            if(![AppLogic sharedInstance].isLogin){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notLogin"]];
                return;
            }
            /*
            VipOrderViewController *vipOrderViewController = [[VipOrderViewController alloc] initWithNibName:@"VipOrderViewController" bundle:nil];
            [self.navigationController pushViewController:vipOrderViewController animated:YES];*/
            OrderEntryViewController *orderEntryViewController = [[OrderEntryViewController alloc] initWithNibName:@"OrderEntryViewController" bundle:nil];
            [self.navigationController pushViewController:orderEntryViewController animated:YES];
        }
            break;
        case 5:{
            if(![AppLogic sharedInstance].isLogin){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"notLogin"]];
                return;
            }
            MessageCenterViewController *messageCenterViewController = [[MessageCenterViewController alloc] initWithNibName:@"MessageCenterViewController" bundle:nil];
            [self.navigationController pushViewController:messageCenterViewController animated:YES];
        }
            break;
        case 6:{
            AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
            break;
        default:
            break;
    }
}



- (void)flagTimer:(NSTimer*)theTimer{
    if(![AppLogic sharedInstance].isLogin){
        return;
    }
    [self setOrderRedPoint];
    MeCell *cellMessage = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSDictionary *attributes2 = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"page":[NSString stringWithFormat:@"%d",1],
                                 @"pagesize":[NSString stringWithFormat:@"%d",10000]
                                 };
    [[AppLogic sharedInstance] getMessageList:attributes2 success:^(NSArray *listData){
        int msgUnReadNum = 0;
        for(int i=0;i<[listData count];i++){
            NSDictionary *data = [listData objectAtIndex:i];
            if([[data valueForKeyPath:@"is_read"] intValue]==2){
                msgUnReadNum++;
            }
        }
        if(msgUnReadNum>0){
            cellMessage.flag.hidden=NO;
        }else{
            cellMessage.flag.hidden=YES;
        }
        
    } fail:^(NSString *message) {
        
    }];
}

-(void)setOrderRedPoint{
    MeCell *cellOrder = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSDictionary* attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"page":[NSString stringWithFormat:@"%d",1],
                                 @"pagesize":[NSString stringWithFormat:@"%d",100000]
                                 };
    [[AppLogic sharedInstance] getOrderByType:ORDER_NO_PAY :attributes success:^(NSArray *listData) {
        if([listData count]>0){
            cellOrder.flag.hidden=NO;
        }else{
            [[AppLogic sharedInstance] getOrderByType:ORDER_NO_GET :attributes success:^(NSArray *listData) {
                if([listData count]>0){
                    cellOrder.flag.hidden=NO;
                }else{
                    [[AppLogic sharedInstance] getOrderByType:ORDER_NO_COMMENTS :attributes success:^(NSArray *listData) {
                        if([listData count]>0){
                            cellOrder.flag.hidden=NO;
                        }else{
                            cellOrder.flag.hidden=YES;
                        }
                    } fail:^(NSString *message) {
                    }];
                }
            } fail:^(NSString *message) {
            }];
        }
    } fail:^(NSString *message) {
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(flagTimer:) userInfo:nil repeats:YES];
    
    if(![AppLogic sharedInstance].isLogin){
        return;
    }
    [self setOrderRedPoint];
    MeCell *cellMessage = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSDictionary *attributes2 = @{
                                  @"ucode":[AppLogic sharedInstance].ucode,
                                  @"page":[NSString stringWithFormat:@"%d",1],
                                  @"pagesize":[NSString stringWithFormat:@"%d",10000]
                                  };
    [[AppLogic sharedInstance] getMessageList:attributes2 success:^(NSArray *listData){
        int msgUnReadNum = 0;
        for(int i=0;i<[listData count];i++){
            NSDictionary *data = [listData objectAtIndex:i];
            if([[data valueForKeyPath:@"is_read"] intValue]==2){
                msgUnReadNum++;
            }
        }
        if(msgUnReadNum>0){
            cellMessage.flag.hidden=NO;
        }else{
            cellMessage.flag.hidden=YES;
        }
        
    } fail:^(NSString *message) {
        
    }];

    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
}


@end
