//
//  MeDetailViewController.h
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MeDetailTableViewCell.h"
#import "SelectDateViewController.h"

@interface MeDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UPdateSexDelegate,SetDateDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property(strong,nonatomic) UIBarButtonItem *editBtn;

@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *head;
@property (weak, nonatomic) IBOutlet UIButton *vipImageView;
@property (weak, nonatomic) IBOutlet UIButton *levelUpBtn;
- (IBAction)levelUp1:(id)sender;
- (IBAction)levelUp2:(id)sender;
@end
