//
//  BasicWebViewController.h
//  easyTravel
//
//  Created by Land on 2019/2/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface BasicWebViewController : UIViewController


/** 为了提示加载效率以及与页面间的交互，故使用WKWebView */
@property (strong, nonatomic) WKWebView * webView;
/** 加载方法，get或是post */
@property (assign, nonatomic) BOOL postMethod;

/**
 初始化控制器
 
 @param url 链接地址
 @param title 控制器的标题
 */
- (id)initWithURL:(NSString*)url title:(NSString*)title;
/**
 初始化控制器
 
 @param url 链接地址
 @param title 控制器标题
 @param params 页面参数
 */
- (id)initWithURL:(NSString*)url title:(NSString*)title parameters:(NSDictionary*)params;

@end
