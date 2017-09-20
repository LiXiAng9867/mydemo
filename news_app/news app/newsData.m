//
//  newsData.m
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "newsData.h"

@implementation newsData
- (instancetype)initWithDict:(NSMutableDictionary*) dict{
    self = [super init];
    if(self){
    self.imgurl = dict[@"imgurl"];
    self.id = dict[@"id"];
    self.docurl = dict[@"docurl"];
    self.channelname = dict[@"channelname"];
    self.has_content = dict[@"has_content"];
    self.title = dict[@"title"];
    self.time = dict[@"time"];
    self.dic = dict;
    }
    return self;
}

//-(NSDictionary*)turnToDict{
//    NSDictionary *dict = [[NSDictionary alloc]init];
//    [dict setValue:self.imgurl forKey:@"imgurl"];
//    [dict setValue:self.id forKey:@"id"];
//    [dict setValue:self.docurl forKey:@"docurl"];
//    [dict setValue:self.channelname forKey:@"channelname"];
//    [dict setValue:self.has_content forKey:@"has_content"];
//    [dict setValue:self.title forKey:@"title"];
//    [dict setValue:self.time forKey:@"time"];
//    return dict;
//}

@end
