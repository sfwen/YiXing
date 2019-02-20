//
//  AppDelegate.h
//  easyTravel
//
//  Created by apple on 15/7/13.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#import <Availability.h>
#import <UIKit/UIKit.h>
#import "XmlDataParser.h"
#import "CityViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) XmlDataParser *xmlParser;


@end

