//
//  NSDate+Extend.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extend)

- (BOOL)isToday;

+ (NSDate *)dateStartOfDay:(NSDate *)date;

/**
 Adjust firstDate and secondDate is in the same day or not.
 **/
+ (BOOL)isSameDayWithDate:(NSDate*)firstDate andDate:(NSDate*)secondDate;

+ (BOOL)isSameDayWithTime:(NSTimeInterval )firstTime andTime:(NSTimeInterval )secondTime;
/**
 Return the 0 o'clock time of the "date".
 **/
+ (NSDate*)acquireTimeFromDate:(NSDate*)date;

/**
 Acquire the week index from date.
 **/
+ (NSInteger)acquireWeekDayFromDate:(NSDate*)date;

- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;

/* 从时间戳获取特定格式的时间字符串 */
+ (NSString *)stringWithTimestamp:(NSTimeInterval)tt format:(NSString *)format;
/*
 *  时间戳
 */
@property (nonatomic,copy,readonly) NSString *timestamp;



/*
 *  时间成分
 */
@property (nonatomic,strong,readonly) NSDateComponents *components;




/*
 *  是否是今年
 */
@property (nonatomic,assign,readonly) BOOL isThisYear;




/*
 *  是否是今天
 */
//@property (nonatomic,assign,readonly) BOOL isToday;




/*
 *  是否是昨天
 */
@property (nonatomic,assign,readonly) BOOL isYesToday;




/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;






@end
