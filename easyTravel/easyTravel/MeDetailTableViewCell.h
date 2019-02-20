//
//  MeDetailTableViewCell.h
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellDraw.h"

@protocol UPdateSexDelegate <NSObject>

-(void)updateSex:(NSString*)sexStr;

@end

@interface MeDetailTableViewCell : UITableViewCell

@property(strong,nonatomic)CellDraw *cellDraw;

@property(assign,nonatomic) id<UPdateSexDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *content;

@property (weak, nonatomic) IBOutlet UILabel *manLabel;
@property (weak, nonatomic) IBOutlet UILabel *womanLabel;
@property (weak, nonatomic) IBOutlet UIButton *manCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *womanCheckBox;
- (IBAction)checkBox1:(id)sender;
- (IBAction)checkBox2:(id)sender;


-(void)displayCheckBox;
-(void)hideCheckBox;
-(NSString*)getSexString;



-(void)updateData:(NSMutableDictionary*)info:(int)row;

@end
