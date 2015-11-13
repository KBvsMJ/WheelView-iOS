//
//  KDWheel.h
//  MCManual
//
//  Created by Kyle on 15/10/20.
//  Copyright © 2015年 Kyle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDWheelItem.h"
#import "KDWheelCursor.h"

@class KDWheel;

@protocol KDWheelDelegate <NSObject>

@required
/**
 * Use INDEX from params to query specific value of DATASOURCE;
 **/
- (void)KDWheel: (KDWheel *)wheel didSelectItemAtIndex: (NSInteger)index;

@end

@interface KDWheel : UIScrollView

@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) NSInteger offsetCount;
@property (nonatomic, copy) NSString *additionalMark;
@property (nonatomic, strong) UIColor *markColor;
@property (nonatomic, strong) UIColor *markTextColor;
@property (nonatomic, strong) KDWheelCursor *cursor;
@property (nonatomic, assign) CGFloat markHeight;
@property (nonatomic, assign) CGFloat markShrink;

@property (nonatomic, copy) NSArray<NSString *> *items;
@property (nonatomic, readonly, assign) NSInteger centerIndex;
@property (nonatomic, strong) id<KDWheelDelegate> wheelDelegate;

/**
 * select an item at given INDEX, with animation or not.
 **/
- (void)selectIndex: (NSInteger)index animated: (BOOL)animated;

- (void)setCursorFrame: (CGRect)frame;

@end
