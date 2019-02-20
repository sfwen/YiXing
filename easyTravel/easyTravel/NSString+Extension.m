//
//  NSString+ExtensionViewController.m
//  easyTravel
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString(extension)




+(NSString *)encodeURL:(NSString *)string
{
    NSString *outputStr = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (__bridge CFStringRef)string,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}

+(NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}





@end