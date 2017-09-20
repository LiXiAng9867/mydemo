//
//  newsFrame.h
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "newsData.h"
@interface newsFrame : NSObject
@property(strong,nonatomic) newsData* newsData;
@property (nonatomic , assign) CGRect descriptionF;
@property (nonatomic , assign) CGRect picUrlF;
@property (nonatomic , assign) CGRect titleF;
@property (nonatomic , assign) CGRect urlF;
@property (nonatomic , assign) CGRect ctimeF;

@property (nonatomic , assign) CGFloat cellH;

@end
