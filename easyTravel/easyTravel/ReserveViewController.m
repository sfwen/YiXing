//
//  ReserveViewController.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ReserveViewController.h"
#import "CommonUtil.h"
#import "PayViewController.h"
#import "SelectDateViewController.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "CommonUtil.h"

@interface ReserveViewController (){
    NSTimer *timer;
}

@end

@implementation ReserveViewController{
    int personNum;
    double shouldPayMoney;
}

@synthesize goToPayBtn;
@synthesize payLabel;
@synthesize payPrice;
@synthesize minusBtn;
@synthesize personNumLabel;
@synthesize plusBtn;
@synthesize date;
@synthesize name;
@synthesize telephone;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize numLabel;
@synthesize nameLabel;
@synthesize telephoneLabel;
@synthesize goods_normal_price;
@synthesize goods_vip_price;
@synthesize selectDateView;

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
    //self.navigationController.navigationBar.hidden = NO;
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    personNum = 1;
    telephone.delegate = self;
    self.title=@"填写贵宾厅订单";
    titleLabel.text = [AppLogic sharedInstance].goods_name;
    goToPayBtn.layer.cornerRadius = 6.0;
    goToPayBtn.backgroundColor = [CommonUtil getColor:@"ff5353"];
    [goToPayBtn.layer setBorderColor:[[CommonUtil getColor:@"ff5353"] CGColor]];
    [goToPayBtn.layer setBorderWidth:1.0];
    payPrice.textColor = [CommonUtil getColor:@"fd682b"];
    
    minusBtn.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    minusBtn.layer.borderWidth = 1;
    minusBtn.tintColor = [CommonUtil getColor:@"dcdcdc"];
    
    plusBtn.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    plusBtn.layer.borderWidth = 1;
    plusBtn.tintColor = [CommonUtil getColor:@"dcdcdc"];
    
    personNumLabel.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    personNumLabel.layer.borderWidth = 1;
    personNumLabel.textColor = [CommonUtil getColor:@"dcdcdc"];
    
    titleLabel.textColor=[CommonUtil getColor:@"444444"];
    dateLabel.textColor=[CommonUtil getColor:@"676767"];
    numLabel.textColor=[CommonUtil getColor:@"676767"];
    nameLabel.textColor=[CommonUtil getColor:@"676767"];
    telephoneLabel.textColor=[CommonUtil getColor:@"676767"];
    payLabel.textColor=[CommonUtil getColor:@"333433"];
    // Do any additional setup after loading the view from its nib.
    telephone.keyboardType = UIKeyboardTypePhonePad;
    
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString *dateString = [formatter stringFromDate:[[NSDate alloc] init]];
    //date.text = dateString;
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [selectDateView addGestureRecognizer:tapGesture];
    
    
    [self calculateShouPayMoney];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    
    SelectDateViewController *controller = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
    controller.delegate = self;
    controller.mode = 1;
    [self.navigationController pushViewController: controller animated:NO];
}

-(void)updatePrice{
    //payPrice.text = [NSString stringWithFormat:@"¥%.2f",[goods_price doubleValue]*personNum];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)minus:(id)sender {
    personNum--;
    if(personNum<1){
        personNum=1;
    }
    personNumLabel.text=[NSString stringWithFormat:@"%d",personNum];
    [self calculateShouPayMoney];
    //[self updatePrice];
}
- (IBAction)plus:(id)sender {
    personNum++;
    personNumLabel.text=[NSString stringWithFormat:@"%d",personNum];
    [self calculateShouPayMoney];
    //[self updatePrice];
}

- (IBAction)chooseDateBtnClick:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    
    SelectDateViewController *controller = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
    controller.delegate = self;
    controller.mode = 1;
    [self.navigationController pushViewController: controller animated:NO];
}

-(void)selectDate:(NSString *)dateStr{
    //NSLog(@"%@",dateStr);
    date.text = dateStr;
}

- (IBAction)goToPay:(id)sender {
    
    if([date.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"dateEmpty"]];
        return;
    }
    
    if(name.text.length<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"nameEmpty"]];
        return;
    }
    
    if([telephone.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"phoneEmpty"]];
        return;
    }
    
    if(![CommonUtil isMobileNumber:telephone.text]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"telError"]];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *useDate=[formatter dateFromString:date.text];
    NSDictionary* attributes = @{@"ucode":[AppLogic sharedInstance].ucode,
                                 @"goods_id":[AppLogic sharedInstance].goods_id,
                                 @"buy_num":[NSNumber numberWithInt:personNum],
                                 @"buyer_name":name.text,
                                 @"buyer_phone":telephone.text,
                                 @"use_times":[NSNumber numberWithDouble:[useDate timeIntervalSince1970]],
                                 };
    [[AppLogic sharedInstance] addOrder:attributes success:^(NSDictionary* orderData){
        PayViewController *payViewController = [[PayViewController alloc] initWithNibName:@"PayViewController" bundle:nil];
        [AppLogic sharedInstance].order_number = [orderData valueForKeyPath:@"order_number"];
        payViewController.payPrice = shouldPayMoney;
        payViewController.goods_name = titleLabel.text;
        payViewController.payType = PAY_TYPE_NORMAL;
        [self.navigationController pushViewController:payViewController animated:YES];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}





- (void)flagTimer:(NSTimer*)theTimer{
    [self calculateShouPayMoney];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(flagTimer:) userInfo:nil repeats:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
}



-(void)calculateShouPayMoney{
    //payPrice.text = [NSString stringWithFormat:@"¥%.2f",[goods_price doubleValue]*personNum];
    if([AppLogic sharedInstance].vipFlag==1){
        shouldPayMoney = (personNum)*[goods_vip_price doubleValue];
    }else if([AppLogic sharedInstance].vipFlag==2){
        shouldPayMoney = (personNum)*[goods_normal_price doubleValue];
    }else if([AppLogic sharedInstance].vipFlag==3){
        if([telephone.text isEqualToString:[AppLogic sharedInstance].phone]
           &&[name.text isEqualToString:[AppLogic sharedInstance].real_name]){//是本人购买的话
            if(personNum==1){
                shouldPayMoney = 0;
            }else{
                shouldPayMoney = (personNum-1)*[goods_vip_price doubleValue];
            }
        }else{//不是本人购买
            shouldPayMoney = (personNum)*[goods_vip_price doubleValue];
        }
    }
    payPrice.text = [NSString stringWithFormat:@"¥%.2f",shouldPayMoney];
}


@end
