//
//  TicketOrderViewController.m
//  easyTravel
//
//  Created by ChenChong on 15/12/14.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TicketOrderViewController.h"
#import "ScenicSpotViewController.h"
#import "PlayHappyViewController.h"
@interface TicketOrderViewController ()

@end

@implementation TicketOrderViewController
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"门票";
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 70)];
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70)];
//    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(gotoScenicSpot) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:button1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 40)];
    label1.text = @"景点门票订单";
    [view1 addSubview:label1];
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *28 / 32, 35, 8, 13)];
    imgView1.image = [UIImage imageNamed:@"rightArrow"];
    [view1 addSubview:imgView1];
    [self.view addSubview:view1];
    /**
     **第一根线
     */
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 135, [UIScreen mainScreen].bounds.size.width, 1)];
    view2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view2];
    /**
     **第二个按钮
     */
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 136, [UIScreen mainScreen].bounds.size.width, 70)];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70 )];
    [button2 addTarget:self action:@selector(gotoPlayHappy) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:button2];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 40)];
    label2.text = @"当地玩乐订单";
    [view3 addSubview:label2];
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width *28 / 32, 35, 8, 13)];
    imgView2.image = [UIImage imageNamed:@"rightArrow"];
    [view3 addSubview:imgView2];
    [self.view addSubview:view3];
    /**
     **第二根线
     */
    UIView *endView = [[UIView alloc]initWithFrame:CGRectMake(0, 206, [UIScreen mainScreen].bounds.size.width, 1)];
    endView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:endView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gotoScenicSpot{
    ScenicSpotViewController * scenicSpotViewController = [[ ScenicSpotViewController alloc] init];
    [self.navigationController pushViewController:scenicSpotViewController animated:YES];

}


-(void)gotoPlayHappy{
    PlayHappyViewController *playHappyViewController = [[ PlayHappyViewController alloc] init];
    [self.navigationController pushViewController:playHappyViewController animated:YES];
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
