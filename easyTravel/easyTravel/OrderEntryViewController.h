//
//  OrderEntryViewController.h
//  easyTravel
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Na517OpenSDK/Na517OpenSDK.h>

@interface OrderEntryViewController : UIViewController<NA517Delegate>

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UIView *view3BottomLine;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UIView *view4BottomeLine;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UILabel *title7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UILabel *title8;




@end
