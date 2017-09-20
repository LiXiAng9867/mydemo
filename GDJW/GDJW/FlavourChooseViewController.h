//
//  FlavourChooseViewController.h
//  GDJW
//
//  Created by 李希昂 on 2017/7/4.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlavourChooseViewController : UIViewController
@property(strong,nonatomic) UINavigationController *nav;
- (void) importTag:(NSInteger) tag;
- (void) setNav:(UINavigationController*)nav;
@end
