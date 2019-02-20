//
//  RegisterCell.h
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@protocol SendMessageDelete <NSObject>

-(void)senMsg:(UIButton*)btn;

@end

@interface RegisterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *text;

@property(strong,nonatomic)CellDraw *cellDraw;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgCodeBtn;
- (IBAction)sendMessage:(UIButton*)sender;

@property (assign, nonatomic) id<SendMessageDelete> delegate;

@end
