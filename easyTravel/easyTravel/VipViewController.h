//
//  VipViewController.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"

@interface VipViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ImagePlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UILabel *normalPrice;
@property (weak, nonatomic) IBOutlet UILabel *vipPrice;
- (IBAction)reserve:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;
- (IBAction)segmentValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *normalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipPriceLabel;

@property(strong,nonatomic) NSString *goods_id;
@property(strong,nonatomic) NSString *goods_price;

@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayer;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
