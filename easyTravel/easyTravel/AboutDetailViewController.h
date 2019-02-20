//
//  AboutDetailViewController.h
//  easyTravel
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property(copy,nonatomic)NSString *imageUrl;
@property(copy,nonatomic)NSString *webViewUrl;
@end
