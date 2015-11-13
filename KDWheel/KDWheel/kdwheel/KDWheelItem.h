//
//  KDWheelItem.h
//  MCManual
//
//  Created by Kyle on 15/10/20.
//  Copyright © 2015年 Kyle. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HEXRGBCOLOR(h) RGBCOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF))
#define HEXRGBACOLOR(h,a) RGBACOLOR(((h>>16)&0xFF), ((h>>8)&0xFF), (h&0xFF), a)

@interface KDWheelItem : UIControl

// top space for cursor
@property (nonatomic, assign) CGFloat topOffset;

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, strong) UIColor *markColor;
@property (nonatomic, strong) UIColor *markTextColor;
@property (nonatomic, copy) NSString *additionMark;
@property (nonatomic, assign) CGFloat markHeight;
@property (nonatomic, assign) CGFloat markShrink;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL highlight;

@end
