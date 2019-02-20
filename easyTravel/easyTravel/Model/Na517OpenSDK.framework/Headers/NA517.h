//
//  NA517.h
//  NA517
//
//  Created by cy on 14-9-15.
//  Copyright (c) 2014年 cy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
@protocol  NA517Delegate<NSObject>
@optional
//进入航班查询页面
-(void)startToNA517;
//进入订单列表
-(void)startToOrder;
//从主页返回方法
-(void)backFromNA517;
//从订单返回方法
-(void)backFromOrder;
@end

@interface NA517 : NSObject
@property(nonatomic,retain) UIViewController* searchViewController;
@property(nonatomic,retain) UIViewController* orderViewController;
@property(nonatomic,retain) UIViewController<NA517Delegate>* delegate;

+ (NA517*)shareNA517;

/*! @brief    启动SDK方法一
 *
 * 描述 PID       合作伙伴唯一标识符
 * 描述 UserID    唯一用户名
 * 描述 Delegate  传入启动SDK的viewController 一般为self
 */
+ (void)startWithPID:(NSString *)pid
              AppKey:(NSString *)appKey
              UserID:(NSString *)userID
            UserName:(NSString *)userName
             UserTel:(NSString *)userTel
            Delegate:(UIViewController<NA517Delegate> *)delegate;

/*! @brief    进入订单方法一
 *
 * 描述 PID       合作伙伴唯一标识符
 * 描述 UserID    唯一用户名
 * 描述 Delegate  传入启动SDK的viewController 一般为self
 */
+ (void)startOrderWithPID:(NSString *)pid
                   AppKey:(NSString *)appKey
                   UserID:(NSString *)userID
                 Delegate:(UIViewController *)delegate;


@end
