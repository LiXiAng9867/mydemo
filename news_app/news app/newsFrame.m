//
//  newsFrame.m
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "newsFrame.h"

@implementation newsFrame
-(void)setNewData:(newsData *)NewData
{
    _newsData = NewData;
    
    //图片
    CGFloat picurlX = 5;
    CGFloat picurlY = 10;
    CGFloat picurlW = 100;
    CGFloat picurlH = 70;
    _picUrlF = CGRectMake(picurlX, picurlY, picurlW, picurlH);
    
    //title
    CGFloat titleX = CGRectGetMaxX(_picUrlF) + 10;
    CGFloat titleY = picurlY;
    CGFloat titleW = SCREEN_WIDTH - 5 - titleX;
    CGFloat titleH = 45;
    _titleF = CGRectMake(titleX, titleY, titleW, titleH);
    
    
    _cellH = CGRectGetMaxY(_picUrlF) + 10;
    
}

@end
