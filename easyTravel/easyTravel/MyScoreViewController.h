//
//  MyScoreViewController.h
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScoreViewController : UIViewController<UITabBarDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *myScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *myscoreLabel2;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *line;
@end
