//
//  XmlDataParser.m
//  ParserXml
//
//  Created by zengraoli on 13-11-6.
//  Copyright (c) 2013年 zeng. All rights reserved.
//

#import "XmlDataParser.h"
#import "Province.h"
#import "City.h"

@implementation XmlDataParser

@synthesize proviceArray = _proviceArray;
@synthesize cityArray = _cityArray;

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _proviceArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    for(int i=0;i<[_proviceArray count];i++){
        Province *province = [_proviceArray objectAtIndex:i];
        //NSLog(@"%@",province.name);
        for(int j=0;j<[province.cityArray count];j++){
            City *city = [province.cityArray objectAtIndex:j];
            if([city.name intValue]!=1997){
                [_cityArray addObject: city];
            }
            //NSLog(@"  %@",city.name);
        }
    }
    //NSLog(@"城市数量%d",[_cityArray count]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"HotelGeo"])
    {
        NSString *ProvinceName = [attributeDict objectForKey:@"ProvinceName"];
        int provinceIndex = [self getProvice:ProvinceName];
        if(provinceIndex==-1){
            City *city = [[City alloc] init];
            city.name = [attributeDict objectForKey:@"CityName"];
            city.cID = [attributeDict objectForKey:@"CityCode"];
            Province *province = [[Province alloc] init];
            province.name = [attributeDict objectForKey:@"ProvinceName"];
            province.pID = [attributeDict objectForKey:@"ProvinceId"];
            [province addCity:city];
            [_proviceArray addObject:province];
        }else{
            City *city = [[City alloc] init];
            city.name = [attributeDict objectForKey:@"CityName"];
            city.cID = [attributeDict objectForKey:@"CityCode"];
            [((Province*)[_proviceArray objectAtIndex:provinceIndex]) addCity:city];
        }
    }
}

-(int)getProvice:(NSString*)provinceName{
    for(int i=0;i<[_proviceArray count];i++){
        Province *province = [_proviceArray objectAtIndex:i];
        if ([province.name isEqualToString:provinceName]){
            return i;
        }
    }
    return -1;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""])
    {
        return;
    }
}

-(void)StartParse:(NSString *)filePath isWebXmlLink:(BOOL)isWebXmlLink
{
    NSXMLParser *parser;
    
    // 本地读取xml文件
    if (!isWebXmlLink)
    {
        NSString *localFilePath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"xml"];
        NSURL *fileUrl = [NSURL fileURLWithPath:localFilePath];
        
        parser = [[NSXMLParser alloc] initWithContentsOfURL:fileUrl];
    }
    else
    {
        NSURL *fileUrl = [NSURL URLWithString:filePath];
        NSData *webData = [NSData dataWithContentsOfURL:fileUrl];
        
        parser = [[NSXMLParser alloc] initWithData:webData];
    }
    
    parser.delegate = self;
    [parser parse];
}

@end
