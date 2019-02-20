//
//  NSDate+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSDate+Extend.h"

@interface NSDate ()


/*
 *  清空时分秒，保留年月日
 */
@property (nonatomic,strong,readonly) NSDate *ymdDate;


@end




@implementation NSDate (Extend)





/*
 *  时间戳
 */
-(NSString *)timestamp{

    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}





/*
 *  时间成分
 */
-(NSDateComponents *)components{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    return [calendar components:unit fromDate:self];
}





/*
 *  是否是今年
 */
-(BOOL)isThisYear{
    
    //取出给定时间的components
    NSDateComponents *dateComponents=self.components;
    
    //取出当前时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    //直接对比年成分是否一致即可
    BOOL res = dateComponents.year==nowComponents.year;
    
    return res;
}





/*
 *  是否是今天
 */
//-(BOOL)isToday{
//
//    //差值为0天
//    return [self calWithValue:0];
//}





/*
 *  是否是昨天
 */
-(BOOL)isYesToday{
    
    //差值为1天
    return [self calWithValue:1];
}


-(BOOL)calWithValue:(NSInteger)value{
    
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].ymdDate.components;
    
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day;
    
    return res;
}



/*
 *  清空时分秒，保留年月日
 */
-(NSDate *)ymdDate{
    
    //定义fmt
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    //设置格式:去除时分秒
    fmt.dateFormat=@"yyyy-MM-dd";
    
    //得到字符串格式的时间
    NSString *dateString=[fmt stringFromDate:self];
    
    //再转为date
    NSDate *date=[fmt dateFromString:dateString];
    
    return date;
}












/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    return components;
}

- (BOOL)isToday
{
    return [[NSDate dateStartOfDay:self] isEqualToDate:[NSDate dateStartOfDay:[NSDate date]]];
}

+ (NSDate *)dateStartOfDay:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components =
    [gregorian               components:(NSCalendarUnitYear | NSCalendarUnitMonth |
                                         NSCalendarUnitDay) fromDate:date];
    return [gregorian dateFromComponents:components];
}

+ (BOOL)isSameDayWithTime:(NSTimeInterval )firstTime andTime:(NSTimeInterval )secondTime{
    NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:firstTime];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:secondTime];
    return [firstDate isSameDayWithDate:secondDate];
}

+ (BOOL)isSameDayWithDate:(NSDate *)firstDate andDate:(NSDate *)secondDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:firstDate];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:secondDate];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year] == [comp2 year];
}

- (BOOL)isSameDayWithDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date];
    
    return [comp1 day] == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year] == [comp2 year];
}

+ (NSDate*)acquireTimeFromDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    NSDate* result = [calendar dateFromComponents:comps];
    return result;
}

+ (NSInteger)acquireWeekDayFromDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitWeekday;
    NSDateComponents* comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday];
}


- (NSInteger)day {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitDay fromDate:self];
    return [components day];
}

- (NSInteger)month {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth fromDate:self];
    return [components month];
}

- (NSInteger)year {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear fromDate:self];
    return [components year];
}

+(NSString *)stringWithTimestamp:(NSTimeInterval)tt format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tt];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}
































@end
