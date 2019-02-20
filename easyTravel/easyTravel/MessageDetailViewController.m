//
//  MessageDetailViewController.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "CommonUtil.h"
#import "Toast+UIView.h"
#import "AppLogic.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController{
    NSDictionary *msgData;
}
@synthesize line;
@synthesize msgTitle;
@synthesize msgContent;
@synthesize msgDate;
@synthesize msgIcon;
@synthesize msgTime;
@synthesize msdId;


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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=[CommonUtil getStrByKey:@"msgDetailTitle"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    line.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    msgTitle.textColor = [CommonUtil getColor:@"333333"];
    msgContent.textColor = [CommonUtil getColor:@"bababa"];
    msgDate.textColor = [CommonUtil getColor:@"bdbdbd"];
    msgTime.textColor = [CommonUtil getColor:@"bdbdbd"];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary* attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"id":[NSNumber numberWithInt:msdId],
                                 };
    [[AppLogic sharedInstance] getMessageDetail:attributes success:^(NSDictionary *messageData) {
        msgData = messageData;
        msgTitle.text = [msgData valueForKeyPath:@"title"];
        msgContent.text = [msgData valueForKeyPath:@"content"];
        if([[msgData valueForKeyPath:@"is_read"] intValue]==1){
            msgIcon.image = [UIImage imageNamed:@"oldMessage.png"];
        }else{
            msgIcon.image = [UIImage imageNamed:@"newMessage.png"];
        }
        NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
        [formatterDate setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [formatterDate stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:[[msgData valueForKeyPath:@"create_time"] doubleValue]]];
        msgDate.text=dateString;
        
        NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
        [formatterTime setDateFormat:@"hh:mm:ss"];
        NSString *timeString = [formatterTime stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:[[msgData valueForKeyPath:@"create_time"] doubleValue]]];
        msgTime.text=timeString;

        
        
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
