//
//  XmlDataParser.h
//  ParserXml
//
//  Created by zengraoli on 13-11-6.
//  Copyright (c) 2013年 zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlDataParser : NSObject<NSXMLParserDelegate>

@property(strong, nonatomic) NSMutableArray *proviceArray;
@property(strong, nonatomic) NSMutableArray *cityArray;

-(void)StartParse:(NSString *)filePath isWebXmlLink:(BOOL)isWebXmlLink;

@end
