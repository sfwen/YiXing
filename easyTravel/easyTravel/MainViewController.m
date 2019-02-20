//
//  MainViewController.m
//  easyTravel
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#define UISCREENHEIGHT  self.view.bounds.size.height
#define UISCREENWIDTH  self.view.bounds.size.width


#import "MainViewController.h"
#import "VipLobbyViewController.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "CommonUtil.h"
#import "ImagePlayerView.h"
#import "ImageDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
#import "VipViewController.h"
#import "LoginViewController.h"
#import "HotelSelectViewController.h"
#import "AFAppDotNetAPIClient.h"
#import "AdmissionViewController.h"
#import "TrainTicketsViewController.h"
#import "BasicWebViewController.h"

@interface MainViewController (){
    NSMutableArray *imageUrlArray;
    NSMutableArray *bannerTypeArray;
     NSMutableArray *bannerIdArray;
    int page;
}
@end

@implementation MainViewController

@synthesize adArea;
@synthesize vipEnter;
@synthesize ticketEnter;
@synthesize hotelEnter;
@synthesize adImage;
@synthesize pageControl;
@synthesize jdEnter;
@synthesize huocheEnter;

/*
@synthesize imagePlayer;
@synthesize vipToTopMargin;
@synthesize imagePlayerHeight;*/


//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 0;
    imageUrlArray = [[NSMutableArray alloc] init];
    bannerTypeArray = [[NSMutableArray alloc] init];
    bannerIdArray = [[NSMutableArray alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getNavigationBarBgColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [CommonUtil getColor:@"ffffff"],UITextAttributeTextColor,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    UITapGestureRecognizer *vipTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipGestureRecongnizer:)];
    vipTapGesture.numberOfTapsRequired = 1;
    vipTapGesture.delegate = self;
    [vipEnter addGestureRecognizer:vipTapGesture];
    
    
    UITapGestureRecognizer *ticketTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ticketGestureRecongnizer:)];
    ticketTapGesture.numberOfTapsRequired = 1;
    ticketTapGesture.delegate = self;
    [ticketEnter addGestureRecognizer:ticketTapGesture];
    
    
    UITapGestureRecognizer *hotelTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hotelGestureRecongnizer:)];
    hotelTapGesture.numberOfTapsRequired = 1;
    hotelTapGesture.delegate = self;
    [hotelEnter addGestureRecognizer:hotelTapGesture];
    
    UITapGestureRecognizer *jdTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jdGestureRecongnizer:)];
    jdTapGesture.numberOfTapsRequired = 1;
    jdTapGesture.delegate = self;
    [jdEnter addGestureRecognizer:jdTapGesture];
    
    UITapGestureRecognizer *huocheTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(huocheGestureRecongnizer:)];
    huocheTapGesture.numberOfTapsRequired = 1;
    huocheTapGesture.delegate = self;
    [huocheEnter addGestureRecognizer:huocheTapGesture];
    
    /*
    imagePlayer.pageControlPosition = ICPageControlPosition_BottomRight;
    [imagePlayer initWithCount:5 delegate:self];
    imagePlayer.autoScroll = NO;
    
    if(IS_IPHONE_4_OR_LESS){
        vipToTopMargin.constant = 5;
        //imagePlayerHeight.constant = -20.0f;
    }*/
    adImage.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [adImage addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [adImage addGestureRecognizer:swipeLeftGesture];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [adImage addGestureRecognizer:tapGesture];
    
    
    NSDictionary *attributes = @{};
    [[AppLogic sharedInstance] getBannerContent:attributes success:^(NSDictionary *data) {
        
        /**/
        [imageUrlArray addObject:[data valueForKeyPath:@"ib_image1"]];
        [imageUrlArray addObject:[data valueForKeyPath:@"ib_image2"]];
        [imageUrlArray addObject:[data valueForKeyPath:@"ib_image3"]];
        [imageUrlArray addObject:[data valueForKeyPath:@"ib_image4"]];
        [imageUrlArray addObject:[data valueForKeyPath:@"ib_image5"]];
        [imageUrlArray addObject:[data valueForKeyPath:@"ib_image6"]];
        
        
        /*
        [imageUrlArray addObject:@"http://img4.ppmsg.net/Upload2010/63/csbjntmdmzNianlna/01.jpg"];
        [imageUrlArray addObject:@"http://img4.ppmsg.net/Upload2010/63/csbjntmdmzNianlna/02.jpg"];
        [imageUrlArray addObject:@"http://img4.ppmsg.net/Upload2010/63/csbjntmdmzNianlna/03.jpg"];
        [imageUrlArray addObject:@"http://img4.ppmsg.net/Upload2010/63/csbjntmdmzNianlna/04.jpg"];
        [imageUrlArray addObject:@"http://img4.ppmsg.net/Upload2010/63/csbjntmdmzNianlna/05.jpg"];
        [imageUrlArray addObject:@"http://img4.ppmsg.net/Upload2010/63/csbjntmdmzNianlna/06.jpg"];*/
        
        
        /**/
        [bannerTypeArray addObject:[data valueForKeyPath:@"ib_type1"]];
        [bannerTypeArray addObject:[data valueForKeyPath:@"ib_type2"]];
        [bannerTypeArray addObject:[data valueForKeyPath:@"ib_type3"]];
        [bannerTypeArray addObject:[data valueForKeyPath:@"ib_type4"]];
        [bannerTypeArray addObject:[data valueForKeyPath:@"ib_type5"]];
        [bannerTypeArray addObject:[data valueForKeyPath:@"ib_type6"]];
        
        [bannerIdArray addObject:[data valueForKeyPath:@"ib_goods_id1"]];
        [bannerIdArray addObject:[data valueForKeyPath:@"ib_goods_id2"]];
        [bannerIdArray addObject:[data valueForKeyPath:@"ib_goods_id3"]];
        [bannerIdArray addObject:[data valueForKeyPath:@"ib_goods_id4"]];
        [bannerIdArray addObject:[data valueForKeyPath:@"ib_goods_id5"]];
        [bannerIdArray addObject:[data valueForKeyPath:@"ib_goods_id6"]];
        
        pageControl.numberOfPages = [imageUrlArray count];
        pageControl.currentPage = page;
        
        [self updateImage];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)updateImage{
    if([imageUrlArray count]<=0){
        return;
    }
    [adImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,[imageUrlArray objectAtIndex:page]]] placeholderImage:[UIImage imageNamed:@"adDefault.jpg"]];
    
    //[adImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:page]]] placeholderImage:[UIImage imageNamed:@"adDefault.jpg"]];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    if([bannerTypeArray count]<=0){
        return;
    }
    
    if([[bannerTypeArray objectAtIndex:page] integerValue]==1){
        VipViewController *viewController = [[VipViewController alloc] initWithNibName:@"VipViewController" bundle:nil];
        viewController.goods_id = [bannerIdArray objectAtIndex:page];
        //viewController.goods_price = [cell.cellData valueForKeyPath:@"goods_price"];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if([[bannerTypeArray objectAtIndex:page] integerValue]==2){
        [[AppLogic sharedInstance] makeToast:@"暂不支持机票预订跳转"];
    }else if([[bannerTypeArray objectAtIndex:page] integerValue]==3){
        [[AppLogic sharedInstance] makeToast:@"暂不支持酒店预订跳转"];
    }
    
    
    //[adImage setImage:[UIImage imageNamed:@"head.jpg"]];
    /*
    WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewController.url = [webViewUrlArray objectAtIndex:page];
    [self.navigationController pushViewController:webViewController animated:YES];*/
}

-(void)handleSwipeGesture:(UITapGestureRecognizer *)sender{
    UISwipeGestureRecognizerDirection direction=[(UISwipeGestureRecognizer*) sender direction];
    switch (direction) {
        case UISwipeGestureRecognizerDirectionRight:
            page--;
            if(page<0){
                page = 0;
            }
            pageControl.currentPage = page;
            [self updateImage];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            page++;
            if(page>5){
                page = 5;
            }
            pageControl.currentPage = page;
            [self updateImage];
            break;
    }
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    imageView.image = [UIImage imageNamed:@"ad.png"];
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    ImageDetailViewController *detailViewController = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
    detailViewController.imageUrl = @"http://img3.ppmsg.net/Upload2010/66/zgydsjyxxmfmmrw/01.jpg";
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)vipGestureRecongnizer:(UITapGestureRecognizer *)sender{
    [self.navigationController pushViewController:[[VipLobbyViewController alloc] initWithNibName:@"VipLobbyViewController" bundle:nil] animated:YES];
}

/** 机票 */
-(void)ticketGestureRecongnizer:(UITapGestureRecognizer *)sender{
    if([AppLogic sharedInstance].isLogin){
//        [[NSUserDefaults standardUserDefaults] setValue:@"http://yixing.appjk.517na.com/OpenPlatService.ashx/" forKey:@"baseUrl"];
//        [NA517 startWithPID:@"00280004" AppKey:@"0F4456FDA4CB491FAA1749019F6C8F7E" UserID:[[AppLogic sharedInstance].userInfo valueForKeyPath:@"uid"] UserName:[AppLogic sharedInstance].real_name UserTel:[AppLogic sharedInstance].phone Delegate:self];
        BasicWebViewController * vc = [[BasicWebViewController alloc] initWithURL:@"https://m.ly.com/flightnew?refid=46834294" title:@"机票预订"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [AppLogic sharedInstance].loginSuccessWillGoViewTag = 999;
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}

/** 酒店 */
-(void)hotelGestureRecongnizer:(UITapGestureRecognizer *)sender{
    if(![AppLogic sharedInstance].isLogin){
        [AppLogic sharedInstance].loginSuccessWillGoViewTag = 8;
        [self.navigationController pushViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] animated:YES];
        return;
    }
//    HotelSelectViewController *hotelSelectViewController = [[HotelSelectViewController alloc] initWithNibName:@"HotelSelectViewController" bundle:nil];
//    [self.navigationController pushViewController:hotelSelectViewController animated:YES];
    BasicWebViewController * vc = [[BasicWebViewController alloc] initWithURL:@"https://m.ly.com/hotel/?refid=46834294" title:@"酒店预定"];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 **景点
 */
-(void)jdGestureRecongnizer:(UITapGestureRecognizer *)sender{
//    [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isBuilding"]];
    if(![AppLogic sharedInstance].isLogin){
        [AppLogic sharedInstance].loginSuccessWillGoViewTag = 8;
        [self.navigationController pushViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] animated:YES];
        return;
    }
//    AdmissionViewController *admissionViewController = [[AdmissionViewController alloc] initWithNibName:@"AdmissionViewController" bundle:nil];
//    [self.navigationController pushViewController:admissionViewController animated:YES];
    BasicWebViewController * vc = [[BasicWebViewController alloc] initWithURL:@"https://m.ly.com/scenery/?refid=232774189" title:@"景点"];
    [self.navigationController pushViewController:vc animated:YES];

}
/**
 **火车票
 */

-(void)huocheGestureRecongnizer:(UITapGestureRecognizer *)sender{
//   [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isBuilding"]];
    NSLog(@"aaaaaaa");
    if(![AppLogic sharedInstance].isLogin){
        [AppLogic sharedInstance].loginSuccessWillGoViewTag = 8;
        [self.navigationController pushViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] animated:YES];
        return;
    }
//    TrainTicketsViewController * traViewController = [[TrainTicketsViewController alloc]initWithNibName:@"TrainTicketsViewController" bundle:nil];
//    [self.navigationController pushViewController:traViewController animated:YES];

    BasicWebViewController * vc = [[BasicWebViewController alloc] initWithURL:@"https://m.ly.com/uniontrain/webapp/train/index.html?refid=46834294" title:@"火车票"];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self createScrollView];
    self.navigationController.navigationBar.hidden = YES;
    //self.hidesBottomBarWhenPushed = NO;
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startToNA517
{
    UIViewController *toController = [NA517 shareNA517].searchViewController;
    toController.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.translucent=NO;
    [self.navigationController pushViewController:toController animated:YES];
    //[self presentViewController:[NA517 shareNA517].searchViewController animated:YES completion:nil];
}
-(void)startToOrder
{
    [self.navigationController pushViewController:[NA517 shareNA517].orderViewController animated:YES];
    //[self presentViewController:[NA517 shareNA517].orderViewController animated:YES completion:nil];
    
}

-(void)backFromNA517
{
    self.navigationController.navigationBar.translucent=YES;
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)backFromOrder
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

@end
