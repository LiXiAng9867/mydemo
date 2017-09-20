//
//  newsData.h
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsData : NSObject
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *docurl;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *channelname;
@property (nonatomic,copy) NSString* has_content;
@property (nonatomic,copy) NSDictionary* dic;
- (instancetype)initWithDict:(NSMutableDictionary*) dict;
- (NSDictionary*)turnToDict;
@end
