//
//  AboutDetailViewController.m
//  easyTravel
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AboutDetailViewController.h"
#import "CommonUtil.h"
#import "AppLogic.h"
#import "Common.h"
#import "UIImageView+AFNetworking.h"

@interface AboutDetailViewController ()

@end

@implementation AboutDetailViewController

@synthesize mainImage;
@synthesize webView;
@synthesize imageUrl;
@synthesize webViewUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [CommonUtil getStrByKey:@"aboutTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    //mainImage.layer.cornerRadius = 5.0f;
    //mainImage.layer.masksToBounds = YES;
    //mainImage.layer.borderWidth=1.0f;
    //mainImage.layer.borderColor = [UIColor clearColor].CGColor;
    
    //[mainImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageUrl]] placeholderImage:[UIImage imageNamed:@"adDefault.jpg"]];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,webViewUrl]]]];
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
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
