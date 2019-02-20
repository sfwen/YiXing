//
//  MainViewController.h
//  easyTravel
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import <Na517OpenSDK/Na517OpenSDK.h>

@interface MainViewController : UIViewController<UIGestureRecognizerDelegate,ImagePlayerViewDelegate,NA517Delegate>

@property (weak, nonatomic) IBOutlet UIView *adArea;

@property (weak, nonatomic) IBOutlet UIImageView *vipEnter;
@property (weak, nonatomic) IBOutlet UIImageView *ticketEnter;
@property (weak, nonatomic) IBOutlet UIImageView *hotelEnter;
@property (weak, nonatomic) IBOutlet UIImageView *jdEnter;
@property (weak, nonatomic) IBOutlet UIImageView *huocheEnter;

//@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayer;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipToTopMargin;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagePlayerHeight;
@property (weak, nonatomic) IBOutlet UIImageView *adImage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end
