//
//  fmdbTool.h
//  news app
//
//  Created by 李希昂 on 2017/5/25.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "FMDB.h"
@interface fmdbTool : NSObject
+ (NSArray *)statusesWithParams:(NSString*)presentContent;
+ (void)saveStatuses:(NSArray *)statuses;
+(void)count;
+ (void)deleteDB;
@end
