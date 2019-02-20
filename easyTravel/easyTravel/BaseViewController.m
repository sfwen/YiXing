//
//  BaseViewController.m
//  easyTravel
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


@end
