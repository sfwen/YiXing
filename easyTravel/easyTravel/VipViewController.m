//
//  VipViewController.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VipViewController.h"
#import "CommonUtil.h"
#import "ReserveViewController.h"
#import "CommentCell.h"
#import  <QuartzCore/CoreAnimation.h>
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "UIImageView+AFNetworking.h"
#import "ImageDetailViewController.h"
#import "NSString+Extension.h"
#import "MJRefresh.h"
#import "CommonUtil.h"
#import "VipOrderViewController.h"
#import "LoginViewController.h"

@interface VipViewController (){
    NSDictionary *detailInfo;
    NSArray *adImageArray;
    NSArray *bigImageArray;
    NSMutableArray *commentDataArray;
}
@end

@implementation VipViewController{
    int page;
}

@synthesize segmentControl;
@synthesize line1;
@synthesize line2;
@synthesize view1;
@synthesize view2;
@synthesize view3;
@synthesize imagePlayer;
@synthesize normalPrice;
@synthesize vipPrice;
@synthesize reserveBtn;
@synthesize tableView;
@synthesize goods_id;
@synthesize goods_price;
@synthesize titleLabel;
@synthesize normalPriceLabel;
@synthesize vipPriceLabel;
@synthesize webView;

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
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 391, [UIScreen mainScreen].bounds.size.width, 150)];
//    textView.backgroundColor = [UIColor redColor];
    [view1 addSubview:textView];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20,[UIScreen mainScreen].bounds.size.width - 40, 40)];
    textLabel.text = @"购买须知：";
    textLabel.font = [UIFont fontWithName:@"Helvetica" size:20.f];
    [textView addSubview:textLabel];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, [UIScreen mainScreen].bounds.size.width - 40, 70)];
    contentLabel.text = @"付费贵宾厅需提前一天预定;\n免费贵宾厅可以不用预定,持会员卡到机场使用即可;(使用方法和贵宾厅地址请细读详细信息)";
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    [textView addSubview:contentLabel];
    
    page = 1;
    [AppLogic sharedInstance].goods_id = goods_id;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    commentDataArray = [[NSMutableArray alloc] init];
    self.title=[CommonUtil getStrByKey:@"vipLobbyTitle"];
    imagePlayer.pageControlPosition = ICPageControlPosition_BottomCenter;
    //imagePlayer.autoScroll = NO;
    segmentControl.tintColor = [CommonUtil getNavigationBarBgColor];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Arial"size:16],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segmentControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    line1.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line2.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    //view1.hidden = YES;
    view2.hidden = YES;
    view3.hidden = YES;
    normalPrice.textColor = [CommonUtil getColor:@"fd682b"];
    vipPrice.textColor = [CommonUtil getColor:@"fd682b"];
    titleLabel.textColor = [CommonUtil getColor:@"464646"];
    normalPriceLabel.textColor = [CommonUtil getColor:@"676767"];
    vipPriceLabel.textColor = [CommonUtil getColor:@"676767"];
    
    reserveBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    reserveBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    reserveBtn.layer.borderWidth = 1.0f;
    reserveBtn.layer.cornerRadius = 6.0f;
    
    [tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.separatorStyle=NO;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *goodsInfoAttributes = @{@"goods_id":self.goods_id};
    [[AppLogic sharedInstance] getVIpLobbyDetail:goodsInfoAttributes success:^(NSDictionary *goodsInfo) {
        detailInfo = goodsInfo;
        normalPrice.text = [NSString stringWithFormat:@"￥%@",[detailInfo valueForKey:@"goods_price"]];
        vipPrice.text = [NSString stringWithFormat:@"￥%@",[detailInfo valueForKey:@"vip_price"]];
        titleLabel.text = [detailInfo valueForKey:@"goods_name"];
        [AppLogic sharedInstance].goods_name = [detailInfo valueForKey:@"goods_name"];
        adImageArray = @[[detailInfo valueForKey:@"goods_image_banner1"],[detailInfo valueForKey:@"goods_image_banner2"]
                          ,[detailInfo valueForKey:@"goods_image_banner3"],[detailInfo valueForKey:@"goods_image_banner4"]
                          ,[detailInfo valueForKey:@"goods_image_banner5"]];
        bigImageArray = @[[detailInfo valueForKey:@"goods_image1"],[detailInfo valueForKey:@"goods_image2"]
                                  ,[detailInfo valueForKey:@"goods_image3"],[detailInfo valueForKey:@"goods_image4"]
                                  ,[detailInfo valueForKey:@"goods_image5"]];
        [imagePlayer initWithCount:[adImageArray count] delegate:self];
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,[goodsInfo valueForKeyPath:@"url"]]]]];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
    NSDictionary *getCommentListAttributes = @{
                                               @"goods_id":self.goods_id,
                                               @"page":[NSNumber numberWithInt:page],
                                               @"pagesize":[NSNumber numberWithInt:LIST_PAGE_SIZE],
                                               };
    [[AppLogic sharedInstance] getCommentList:getCommentListAttributes success:^(NSArray *listData) {
        [commentDataArray addObjectsFromArray:listData];
        [tableView reloadData];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
    [self setupRefresh];
    webView.detectsPhoneNumbers = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"paySuccess" object:nil];
}

-(void)paySuccess:(NSNotification*) notification{
    VipOrderViewController *vipOrderViewController = [[VipOrderViewController alloc] initWithNibName:@"VipOrderViewController" bundle:nil];
    [vipOrderViewController setMode:ORDER_NO_GET];
    [self.navigationController pushViewController:vipOrderViewController animated:NO];
}


- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index{
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,[adImageArray objectAtIndex:index]]];
    //NSLog(@"图片地址是__%@",imageUrl);
    [imageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"adDefault.jpg"]];
}

-(void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    //NSLog(@"你点击的是第%d张图片___%@",index,goods_id);
    ImageDetailViewController *detailViewController = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
    detailViewController.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,[bigImageArray objectAtIndex:index]];
    [self.navigationController pushViewController:detailViewController animated:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reserve:(id)sender {
    if(![AppLogic sharedInstance].isLogin){
        //[[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"loginPlease"]];
        [AppLogic sharedInstance].loginSuccessWillGoViewTag = 7;
        [self.navigationController pushViewController:[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] animated:YES];
        return;
    }
    ReserveViewController *reserveViewController =[[ReserveViewController alloc] initWithNibName:@"ReserveViewController" bundle:nil];
    reserveViewController.goods_normal_price = [detailInfo valueForKey:@"goods_price"];
    reserveViewController.goods_vip_price = [detailInfo valueForKey:@"vip_price"];
    [self.navigationController pushViewController:reserveViewController animated:YES];
}
- (IBAction)segmentValueChanged:(id)sender {
    switch (self.segmentControl.selectedSegmentIndex){
        case 0:{
            view1.hidden=NO;
            view2.hidden=YES;
            view3.hidden=YES;
        }
            break;
        case 1:{
            view1.hidden=YES;
            view2.hidden=NO;
            view3.hidden=YES;
        }
            break;
        case 2:{
            view1.hidden=YES;
            view2.hidden=YES;
            view3.hidden=NO;
            
            [tableView reloadData];
            
        }
            break;
    }
}
















//tab3

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.name.text = [[commentDataArray objectAtIndex:indexPath.row] valueForKeyPath:@"real_name"];
    cell.content.text = [NSString decodeFromPercentEscapeString:[[commentDataArray objectAtIndex:indexPath.row] valueForKeyPath:@"content"]];
    if([[[commentDataArray objectAtIndex:indexPath.row] valueForKeyPath:@"sevaluation_image1"] length]==0){
        cell.contentBottomMargin.constant = -5;
        cell.imageHeight.constant = 0;
    }else{
        cell.imageHeight.constant = 80;
        cell.contentBottomMargin.constant = -85;
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height+50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [commentDataArray count];
    //return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    [cell setData:[commentDataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







- (void)setupRefresh
{
    
    [self.tableView addHeaderWithCallback:^{
        page = 1;
        
        
        
        NSDictionary *getCommentListAttributes = @{
                                                   @"goods_id":self.goods_id,
                                                   @"page":[NSNumber numberWithInt:page],
                                                   @"pagesize":[NSNumber numberWithInt:LIST_PAGE_SIZE],
                                                   };
        [[AppLogic sharedInstance] getCommentList:getCommentListAttributes success:^(NSArray *listData) {
            if([listData count]<=0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noComment"]];
            }
            [commentDataArray removeAllObjects];
            [commentDataArray addObjectsFromArray:listData];
            [self.tableView reloadData];
            [self.tableView headerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    
    [self.tableView addFooterWithCallback:^{
        if([commentDataArray count] != (page*LIST_PAGE_SIZE)){
            [self.tableView footerEndRefreshing];
            return;
        }
        NSDictionary *getCommentListAttributes = @{
                                                   @"goods_id":self.goods_id,
                                                   @"page":[NSNumber numberWithInt:page+1],
                                                   @"pagesize":[NSNumber numberWithInt:LIST_PAGE_SIZE],
                                                   };
        
        [[AppLogic sharedInstance] getCommentList:getCommentListAttributes success:^(NSArray *listData) {
            if(![listData isKindOfClass:[NSArray class]] || [listData count]<=0){
                [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"noMoreComment"]];
            }else{
                page++;
                [commentDataArray addObjectsFromArray:listData];
            }
            [self.tableView reloadData];
            [self.tableView footerEndRefreshing];
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
    }];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = [CommonUtil getStrByKey:@"headerPullToRefreshText"];
    self.tableView.headerReleaseToRefreshText = [CommonUtil getStrByKey:@"headerReleaseToRefreshText"];
    self.tableView.headerRefreshingText = [CommonUtil getStrByKey:@"headerRefreshingText"];
    
    self.tableView.footerPullToRefreshText = [CommonUtil getStrByKey:@"footerPullToRefreshText"];
    self.tableView.footerReleaseToRefreshText = [CommonUtil getStrByKey:@"footerReleaseToRefreshText"];
    self.tableView.footerRefreshingText = [CommonUtil getStrByKey:@"footerRefreshingText"];
}



@end
