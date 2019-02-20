//
//  VipLobbyViewController.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VipLobbyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchContainer;
- (IBAction)doSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *data;
@property(assign,nonatomic) int page;
@end
