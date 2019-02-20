//
//  CommonUtil.m
//  easyTravel
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil



+ (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

+(UIColor *)getNavigationBarBgColor{
    return [CommonUtil getColor:@"0bc0f4"];
}

+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)){
        return YES;
    }else{
        return NO;
    }
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSString * m177 = @"^1(77)\\d{8}$";
//    NSString * m14 = @"^1(4)\\d{9}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    NSPredicate *regextest177 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", m177];
//    NSPredicate *regextest14 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", m14];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextest177 evaluateWithObject:mobileNum] == YES)
//        || ([regextest14 evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)checkPassword:(NSString *) password
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password];
}


+ (BOOL)checkBankAccount:(NSString *) account
{
    NSString *regex = @"^\\d{16}|\\d{19}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:account];
}

+ (BOOL)checkMoney:(NSString *) money
{
    NSString *regex = @"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:money];
}

+ (BOOL)checkQQ:(NSString *) qq{
    NSString *regex = @"^[0-9]+([0-9]{1})+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:qq];
}


+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}


+ (NSString *)getStrByKey: (NSString *) key{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"stringPlist" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [data objectForKey:key];

}
+ (NSArray *)getArrayByKey: (NSString *) key{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"stringPlist" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [data objectForKey:key];
}

+(NSString *)getJSONString:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length]>0&&error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}


+ (NSDictionary *)dictionaryWithJsonData:(NSData *)jsonData{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return dayComponents.day;
}

@end