//
//  TrailView.m
//  centerD
//
//  Created by 李希昂 on 2018/7/13.
//  Copyright © 2018年 李希昂. All rights reserved.
//

#import "TrailView.h"

@implementation TrailView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    self.locations = [[NSMutableArray alloc]init];
    return self;
}
-(void)reloadData{
    [self setNeedsDisplay];
}
-(void)updateLocation:(coordinate) l{
    self.preLoc = self.presentLoc;
    self.presentLoc = l;
    if(fabs(self.preLoc.radius-self.presentLoc.radius)>=1||fabs(self.preLoc.angle-self.presentLoc.angle)>=0.17){
         NSValue *customValue = [NSValue valueWithBytes:&l objCType:@encode(struct coordinate)];
        [self.locations addObject:customValue];
    }
    [self setNeedsDisplay];
}
-(void)resetLocation{
    
    coordinate temp = self.preLoc;
    [self.locations removeAllObjects];
    temp.angle = 0;
    temp.radius = 0;
    self.preLoc = temp;
    self.presentLoc = temp;
    [self setNeedsDisplay];
}
-(void)setup{
//    self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
//    [self addSubview:self.scrollView];
    [self resetLocation];
}

- (void)drawRect:(CGRect)rect {
    UIColor *color = [UIColor redColor];
    [color set]; //设置线条颜色
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    
    if([self.locations count]>0){
    for (int i = 0; i<[self.locations count]; i++) {
        coordinate preLoc;
        coordinate presentLoc;
        if (i==0) {
            preLoc.radius = 0;
            preLoc.angle = 0;
             [self.locations[i] getValue:&presentLoc];
        }
        else{
            [self.locations[i-1] getValue:&preLoc];
            [self.locations[i] getValue:&presentLoc];
        }
        [path moveToPoint:CGPointMake(preLoc.radius*cos(preLoc.angle)+405/4, preLoc.radius*sin(preLoc.angle)+667/6)];
        [path addLineToPoint:CGPointMake(presentLoc.radius*cos(presentLoc.angle)+405/4, presentLoc.radius*sin(presentLoc.angle)+667/6)];
      }
    }
    else{
        coordinate preLoc;
        coordinate presentLoc;
        preLoc.radius = 0;
        preLoc.angle = 0;
        presentLoc.radius = 0;
        presentLoc.angle = 0;
        [path moveToPoint:CGPointMake(preLoc.radius*cos(preLoc.angle)+405/4, preLoc.radius*sin(preLoc.angle)+667/6)];
        [path addLineToPoint:CGPointMake(presentLoc.radius*cos(presentLoc.angle)+405/4, presentLoc.radius*sin(presentLoc.angle)+667/6)];
        rect = CGRectMake(0, 0, 0, 0);
    }
    
    path.lineWidth = 5.0;
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineJoinRound; //终点处理
    [path stroke];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
