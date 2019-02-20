//
//  WebViewController.h
//  easyTravel
//
//  Created by apple on 15/9/4.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController


@property(copy,nonatomic)NSString *url;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end
