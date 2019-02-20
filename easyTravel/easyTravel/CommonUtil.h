//
//  CommonUtil.h
//  easyTravel
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtil : NSObject

+ (UIColor *)getColor:(NSString*)hexColor;
+ (UIColor *)getNavigationBarBgColor;

+(BOOL)isMobileNumber:(NSString *)mobileNum;
+(BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)checkPassword:(NSString *) password;
+ (BOOL)checkUserIdCard: (NSString *) idCard;
+ (BOOL)checkBankAccount:(NSString *) account;
+ (BOOL)checkMoney:(NSString *) money;
+ (BOOL)checkQQ:(NSString *) qq;


+ (NSString *)getStrByKey: (NSString *) key;
+ (NSArray *)getArrayByKey: (NSString *) key;
+(NSString *)getJSONString:(id)theData;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData;
+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
@end
