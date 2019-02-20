//
//  UserViewController.h
//  easyTravel
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) UIBarButtonItem *exitBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)doLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *levelUpBtn;
- (IBAction)levelUp:(id)sender;
- (IBAction)buyVip:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *head;


@property (weak, nonatomic) IBOutlet UIButton *vipImageView;

@end
