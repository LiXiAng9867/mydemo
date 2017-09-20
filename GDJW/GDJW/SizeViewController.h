//
//  SizeViewController.h
//  GDJW
//
//  Created by 李希昂 on 2017/7/3.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlavourChooseViewController.h"
@interface SizeViewController : UIViewController
@property(strong,nonatomic)UIButton *bigSizeButton;
@property(strong,nonatomic)UIButton *smallSizeButton;
- (void) importTag:(NSInteger) tag;
- (void) setNav:(UINavigationController*)nav;
@end
