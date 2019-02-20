//
//  SelectDateViewController.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SelectDateViewController.h"
#import "CommonUtil.h"

@interface SelectDateViewController ()

@end

@implementation SelectDateViewController

@synthesize delegate;
@synthesize datePicker;
@synthesize confirmBtn;
@synthesize mode;


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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = NO;
}

- (void)back:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration =0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [CommonUtil getStrByKey:@"selectDateTitle"];
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 6.0f;
    // Do any additional setup after loading the view from its nib.
    NSDate* date = [[NSDate alloc] init];
    if(mode==0){
        datePicker.maximumDate = date;
    }else{
        
        
        if(_arrivalDateStr!=nil){
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = nil;
            comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
            NSDateComponents *adcomps = [[NSDateComponents alloc] init];
            [adcomps setDay:1];
            NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[formatter dateFromString:_arrivalDateStr] options:0];
            datePicker.minimumDate = newdate;
            return;
        }
        
        [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        datePicker.minimumDate = date;
    }
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

- (IBAction)confirm:(id)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(mode==0){
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    }
    NSString *dateString = [formatter stringFromDate:datePicker.date];
    if([delegate respondsToSelector:@selector(selectDate:)]){
        [delegate selectDate:dateString];
    }
    CATransition *transition = [CATransition animation];
    transition.duration =0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromTop;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
}
@end
