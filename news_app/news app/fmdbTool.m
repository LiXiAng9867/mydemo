//
//  fmdbTool.m
//  news app
//
//  Created by 李希昂 on 2017/5/25.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "fmdbTool.h"
#import "newsFrame.h"
@implementation fmdbTool
static FMDatabase *_db;
+ (void)initialize
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"statuses.sqlite"];
    
    _db = [FMDatabase databaseWithPath:path];
    
    if([_db open]){
        NSLog(@"db ok");
    }
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS NewsDB (id integer PRIMARY KEY, status blob NOT NULL, channelname text NOT NULL);"];
}

+ (void)deleteDB{
    [_db executeUpdate:@"DROP TABLE IF EXISTS NewsDB"];
}

+ (void)saveStatuses:(NSArray *)totalArray
{
    
    NSMutableArray *newsDataArray = [[NSMutableArray alloc]init];
    NSInteger i;
    for( i=0 ; i < totalArray.count ; i++ ){
        newsFrame *tempFrame = totalArray[i];
        [newsDataArray addObject:tempFrame.newsData];
    }
    for (NSDictionary *model in newsDataArray) {
        // NSDictionary --> NSData
        newsData* tempData =(newsData*)model;
        NSDictionary *newsDict =tempData.dic;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newsDict];
        [_db executeUpdateWithFormat:@"INSERT INTO NewsDB(status, channelname) VALUES (%@, %@);", data, newsDict[@"channelname"]];
        
    }
}

+ (NSArray *)statusesWithParams:(NSString*)presentContent
{
    
    [_db open];
    NSString *sql = nil;
    
    
    sql = [NSString stringWithFormat:@"SELECT * FROM NewsDB WHERE channelname is '%@';",presentContent];
    //channelname like '%@*';",presentContent];
    //怎么改
    FMResultSet *set = [_db executeQuery:sql];
    NSMutableArray *newsArray = [NSMutableArray array];
    while (set.next) {
        NSData *newsData = [set objectForColumnName:@"status"];
        NSDictionary *newsDict = [NSKeyedUnarchiver unarchiveObjectWithData:newsData];
        [newsArray addObject:newsDict];
    }
   
    return newsArray;
   
}

+ (void)count{
    [_db open];
    NSUInteger count = [_db intForQuery:@"select count(*) from NewsDB"];
    
    NSLog(@"%lu",(unsigned long)count);
}

@end
