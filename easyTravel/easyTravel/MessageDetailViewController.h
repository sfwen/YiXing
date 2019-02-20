//
//  MessageDetailViewController.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *msgTitle;
@property (weak, nonatomic) IBOutlet UILabel *msgDate;
@property (weak, nonatomic) IBOutlet UILabel *msgTime;
@property (weak, nonatomic) IBOutlet UILabel *msgContent;
@property (weak, nonatomic) IBOutlet UIImageView *msgIcon;

@property(assign,nonatomic) int msdId;

@end
