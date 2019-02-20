//
//  NSString+ExtensionViewController.h
//  easyTravel
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (extension)
+(NSString*)encodeURL:(NSString *)string;
+(NSString *)decodeFromPercentEscapeString: (NSString *) input;
@end
