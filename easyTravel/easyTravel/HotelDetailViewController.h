//
//  HotelDetailViewController.h
//  easyTravel
//
//  Created by apple on 15/11/1.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagePlayerView.h"
#import "SelectDateViewController.h"

@interface HotelDetailViewController : UIViewController<ImagePlayerViewDelegate,SetDateDelegate>{
    
}

//@property (weak, nonatomic) IBOutlet ImagePlayerView *imagePlayer;
//@property (weak, nonatomic) IBOutlet UIView *blackArea;
//@property (weak, nonatomic) IBOutlet UIView *line1;
//@property (weak, nonatomic) IBOutlet UIView *adressArea;
//@property (weak, nonatomic) IBOutlet UIView *line2;
//@property (weak, nonatomic) IBOutlet UIView *line2BottomLine;
//@property (weak, nonatomic) IBOutlet UIView *line3BottomLine;
//@property (weak, nonatomic) IBOutlet UIView *line4BottomLine;
//- (IBAction)yuDing:(id)sender;
//- (IBAction)ding:(id)sender;


@property(nonatomic,copy)NSString* hotelID;

//@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,copy)NSString* ArrivalDate;
@property(nonatomic,copy)NSString* DepartureDate;

//@property (weak, nonatomic) IBOutlet UILabel *arrivalDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *apartDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *allNightLabel;



@property(nonatomic,assign)int days;
@property(nonatomic,copy)NSString* starDateStr;//简写开始时间只包含月和日
@property(nonatomic,copy)NSString* endDateStr;//简写结束时间只包含月和日
@property (nonatomic ,strong) NSString *dayStr;



@property(nonatomic,strong)NSDate *startDate;
@property(nonatomic,strong)NSDate *endDate;


@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期

@end
