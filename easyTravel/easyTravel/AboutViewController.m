//
//  AboutViewController.m
//  easyTravel
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AboutViewController.h"
#import "CommonUtil.h"
#import "AppLogic.h"
#import "Common.h"
#import "AboutDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

@synthesize mainImage;
@synthesize view1;
@synthesize view2;
@synthesize phoneText;
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
    
    view1.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    view1.layer.borderWidth = 1.0f;
    view2.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    view2.layer.borderWidth = 1.0f;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [view2 addGestureRecognizer:tapGesture];
    
    
    NSDictionary *attributes = @{};
    [[AppLogic sharedInstance] getAboutInfo:attributes success:^(NSDictionary *data) {
        /*
         data =     {
         "a_id" = 1;
         "a_imagelogo" = "/Uploads/Picture/2015-08-26/55dd5ab66176a.jpg";
         "a_tel" = 4000838370;
         url = "/api.php/about/description/";
         };
         */
        phoneText.text = [data valueForKeyPath:@"a_tel"];
        imageUrl = [data valueForKeyPath:@"a_imagelogo"];
        webViewUrl = [data valueForKeyPath:@"url"];
        
        //[mainImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,imageUrl]] placeholderImage:[UIImage imageNamed:@"adDefault.jpg"]];
        
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    AboutDetailViewController *detail = [[AboutDetailViewController alloc] initWithNibName:@"AboutDetailViewController" bundle:nil];
    detail.imageUrl = imageUrl;
    detail.webViewUrl = webViewUrl;
    [self.navigationController pushViewController:detail animated:YES];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)callPhone:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneText.text];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
@end
