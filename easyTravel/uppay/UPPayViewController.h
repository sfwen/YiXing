//
//  UPPayViewController.h
//  easyTravel
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPPayPluginDelegate.h"

@interface UPPayViewController : UIViewController<UPPayPluginDelegate>


@property(copy,nonatomic)NSString* tn;
@end
