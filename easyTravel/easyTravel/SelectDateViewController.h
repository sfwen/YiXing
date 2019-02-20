//
//  SelectDateViewController.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetDateDelegate <NSObject>
-(void)selectDate:(NSString*)dateStr;
@end

@interface SelectDateViewController : UIViewController

@property(assign,nonatomic) id<SetDateDelegate> delegate;

@property(assign,nonatomic) int mode;

- (IBAction)confirm:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;





@property(nonatomic,strong)NSString *arrivalDateStr;

@end
