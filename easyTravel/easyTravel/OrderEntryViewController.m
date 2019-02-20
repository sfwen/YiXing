//
//  OrderEntryViewController.m
//  easyTravel
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "OrderEntryViewController.h"
#import "CommonUtil.h"
#import "VipOrderViewController.h"
#import "LevelUpOrderListViewController.h"
#import "AppLogic.h"
#import "HotelOrderListViewController.h"
#import "AFAppDotNetAPIClient.h"
#import "TicketOrderViewController.h"
#import "TrainTicketOrderViewController.h"
@interface OrderEntryViewController ()

@end

@implementation OrderEntryViewController

@synthesize view1;
@synthesize view2;
@synthesize view3;
@synthesize view4;
@synthesize view7;
@synthesize view8;
@synthesize title7;
@synthesize title8;
@synthesize title1;
@synthesize title2;
@synthesize title3;
@synthesize title4;
@synthesize view3BottomLine;
@synthesize view4BottomeLine;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    // Do any additional setup after loading the view from its nib.
    self.title = [CommonUtil getStrByKey:@"orderEntryTitle"];
    view2.layer.borderWidth = 1.0f;
    view2.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    title1.textColor = [CommonUtil getColor:@"b9da80"];
    title2.textColor = [CommonUtil getColor:@"2bc1f5"];
    title3.textColor = [CommonUtil getColor:@"D6B3F6"];
    title4.textColor = [CommonUtil getColor:@"f4602c"];
    title7.textColor =[UIColor colorWithRed:223 / 255.0 green:47 / 255.0 blue:67 / 255.6 alpha:1];
//    title5.textColor = [UIColor colorWithRed:223 / 255.0 green:47 / 255.0 blue:67 / 255.6 alpha:1];
    title8.textColor = [CommonUtil getColor:@"b9da80"];
    view3BottomLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    view4BottomeLine.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view1Tap:)];
    tapGesture1.numberOfTapsRequired = 1;
    tapGesture1.delegate = self;
    [view1 addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view2Tap:)];
    tapGesture2.numberOfTapsRequired = 1;
    tapGesture2.delegate = self;
    [view2 addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view3Tap:)];
    tapGesture3.numberOfTapsRequired = 1;
    tapGesture3.delegate = self;
    [view3 addGestureRecognizer:tapGesture3];
    
    
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view4Tap:)];
    tapGesture4.numberOfTapsRequired = 1;
    tapGesture4.delegate = self;
    [view4 addGestureRecognizer:tapGesture4];
    /**
     **第五行
     */
    UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view7Tap:)];
    tapGesture5.numberOfTapsRequired = 1;
    tapGesture5.delegate = self;
    [view7 addGestureRecognizer:tapGesture5];
    /**
     **第六行
     */
    UITapGestureRecognizer *tapGesture6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view8Tap:)];
    tapGesture6.numberOfTapsRequired = 1;
    tapGesture6.delegate = self;
    [view8 addGestureRecognizer:tapGesture6];

}
/**
 **第五行方法
 */
-(void)view7Tap:(UITapGestureRecognizer *)sender{
    TrainTicketOrderViewController *trainTicketOrderViewController = [[TrainTicketOrderViewController alloc]initWithNibName:@"TrainTicketOrderViewController" bundle:nil];
    [self.navigationController pushViewController:trainTicketOrderViewController animated:YES];
}
/**
 **第六行方法
 */
-(void)view8Tap:(UITapGestureRecognizer *)sender{
    TicketOrderViewController *ticketOrderViewController = [[TicketOrderViewController alloc] initWithNibName:@"TicketOrderViewController" bundle:nil];
    [self.navigationController pushViewController:ticketOrderViewController animated:YES];
}

-(void)view3Tap:(UITapGestureRecognizer *)sender{
    HotelOrderListViewController *hotelOrderListViewController = [[HotelOrderListViewController alloc] initWithNibName:@"HotelOrderListViewController" bundle:nil];
    [self.navigationController pushViewController:hotelOrderListViewController animated:YES];
}

-(void)view4Tap:(UITapGestureRecognizer *)sender{
    LevelUpOrderListViewController *levelUpOrderListViewController = [[LevelUpOrderListViewController alloc] initWithNibName:@"LevelUpOrderListViewController" bundle:nil];
    [self.navigationController pushViewController:levelUpOrderListViewController animated:YES];
}

-(void)view1Tap:(UITapGestureRecognizer *)sender{
    VipOrderViewController *vipOrderViewController = [[VipOrderViewController alloc] initWithNibName:@"VipOrderViewController" bundle:nil];
    [self.navigationController pushViewController:vipOrderViewController animated:YES];
}

-(void)view2Tap:(UITapGestureRecognizer *)sender{
    [[NSUserDefaults standardUserDefaults] setValue:@"http://yixing.appjk.517na.com/OpenPlatService.ashx/" forKey:@"baseUrl"];
    //user_card  uid
    [NA517 startOrderWithPID:@"00280004" AppKey:@"0F4456FDA4CB491FAA1749019F6C8F7E" UserID:[[AppLogic sharedInstance].userInfo valueForKeyPath:@"uid"] Delegate:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)startToNA517
{
    [self.navigationController pushViewController:[NA517 shareNA517].searchViewController animated:YES];
    //[self presentViewController:[NA517 shareNA517].searchViewController animated:YES completion:nil];
}
-(void)startToOrder
{
    UIViewController *viewController = [NA517 shareNA517].orderViewController;
    viewController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController pushViewController:viewController animated:YES];
    
}

-(void)backFromNA517
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)backFromOrder
{
    self.navigationController.navigationBar.translucent=YES;
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
