//
//  KDWheel.m
//  MCManual
//
//  Created by Kyle on 15/10/20.
//  Copyright © 2015年 Kyle. All rights reserved.
//


#define CURSOR_HEIGHT 14
#define CURSOR_WIDTH 18

//#define ITEM_WIDTH 75
#define OFFSET_COUNT self.offsetCount

#define TAG_OFFSET 1000


#import "KDWheel.h"

#pragma mark - KDWheelCursor


///////////////////////////////////////
///		KDWheel
///////////////////////////////////////

#pragma mark - KDWheel
@interface KDWheel() <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, assign) NSInteger count;
@end

@implementation KDWheel

#pragma mark - life-cycle
- (instancetype)init
{
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.backgroundColor = [UIColor whiteColor];
	self.showsHorizontalScrollIndicator = NO;
	self.decelerationRate = 0.6;
	self.delegate = self;
	
	self.highlightColor = HEXRGBCOLOR(0xF86446);
	self.markColor = HEXRGBCOLOR(0xEEEEEE);
	self.markTextColor = HEXRGBCOLOR(0x666666);
	self.itemWidth = 75;
	
	_centerIndex = -1;
	self.offsetCount = 5;
	
	CGFloat cursorWidth = 18;
	CGFloat cursorHeight = 14;
	self.cursor = [[KDWheelCursor alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.f - cursorWidth / 2.f, 0, cursorWidth, cursorHeight)];
	self.cursor.highlightColor = self.highlightColor;
	[self addSubview:self.cursor];
}

#pragma mark - Getter Setter
- (NSMutableArray *)itemViews {
	if (!_itemViews) {
		_itemViews = [NSMutableArray array];
	}
	return _itemViews;
}

- (void)setAdditionalMark:(NSString *)additionalMark {
	_additionalMark = additionalMark;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.additionMark = _additionalMark;
		}
	}
}

- (void)setHighlightColor:(UIColor *)highlightColor {
	_highlightColor = highlightColor;
	self.cursor.highlightColor = _highlightColor;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.highlightColor = _highlightColor;
		}
	}
}

- (void)setMarkColor:(UIColor *)markColor {
	_markColor = markColor;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.markColor = _markColor;
		}
	}
}

- (void)setMarkTextColor:(UIColor *)markTextColor {
	_markTextColor = markTextColor;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.markTextColor = _markTextColor;
		}
	}
}

- (void)setItems:(NSArray<NSString *> *)items {
	_items = items;
	self.count = _items.count;
	[self createItems];
}

- (void)setItemWidth:(CGFloat)itemWidth {
	_itemWidth = itemWidth;
	if (self.itemViews.count) {
		for (int i = 0; i < self.itemViews.count; i++) {
			NSInteger index = i - OFFSET_COUNT;
			((KDWheelItem *) self.itemViews[i]).frame = CGRectMake(index * _itemWidth + self.frame.size.width / 2.f - _itemWidth / 2.f, 0, _itemWidth, self.frame.size.height);
		}
	}
}

- (void)setOffsetCount:(NSInteger)offsetCount {
	_offsetCount = offsetCount;
	if (self.itemViews.count) {
		// recreate views if needed
		[self createItems];
	}
}

- (void)setMarkHeight:(CGFloat)markHeight {
	_markHeight = markHeight;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.markHeight = _markHeight;
		}
	}
}

- (void)setMarkShrink:(CGFloat)markShrink {
	_markShrink = markShrink;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.markShrink = _markShrink;
		}
	}
}

#pragma mark - items

- (void)createItems {
	for (UIView *view in self.itemViews) {
		[view removeFromSuperview];
	}
	[self.itemViews removeAllObjects];
	
	NSLog(@"%d", (int)self.offsetCount);
	for (NSInteger i = -OFFSET_COUNT; i < self.count + OFFSET_COUNT; i++) {
		KDWheelItem *item = [[KDWheelItem alloc] initWithFrame:CGRectMake(i * self.itemWidth + self.frame.size.width / 2.f - self.itemWidth / 2.f, 0, self.itemWidth, self.frame.size.height)];
		item.topOffset = self.cursor.frame.size.height + 2;
		item.highlightColor = self.highlightColor;
		item.markColor = self.markColor;
		item.markTextColor = self.markTextColor;
		item.additionMark = self.additionalMark;
		item.tag = TAG_OFFSET + i;
		[item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
		if (i >= 0 && i < self.count) {
			item.text = [self.items objectAtIndex:i];
		}
		[self.itemViews addObject:item];
		[self addSubview:item];
	}
	
	self.contentSize = CGSizeMake((self.count - 1) * self.itemWidth + self.frame.size.width, 0);
	[self bringSubviewToFront:self.cursor];
	
	NSInteger index = self.centerIndex;
	if (index >= 0) {
		_centerIndex = -1;
	}
	[self selectIndex:0 animated:NO];
}

- (void)clickItem: (KDWheelItem *)item {
	NSInteger t = [self limitIndex:item.tag - TAG_OFFSET + OFFSET_COUNT];
	[self selectIndex:t animated:YES];
}

#pragma mark - control
- (NSInteger)calcCenter {
	CGPoint p = self.contentOffset;
	CGFloat off = p.x;
	NSInteger c = 0;
	c = round(off / self.itemWidth);
	c += OFFSET_COUNT;
	
	c = [self limitIndex:c];
	
	return c;
}

/**
 * limit bounds of index
 **/
- (NSInteger)limitIndex: (NSInteger)index {
	NSInteger res = index;
	if (res <= OFFSET_COUNT) {
		res = OFFSET_COUNT;
	} else if (res > self.count - 1 + OFFSET_COUNT) {
		res = self.count - 1 + OFFSET_COUNT;
	}
	return res;
}

- (void)selectIndex: (NSInteger)index animated: (BOOL)animated {
	if (animated) {
		[self settle:index];
	} else {
		CGPoint target = CGPointMake(index * self.itemWidth, 0);
		self.contentOffset = target;
		[self selectItem:index + OFFSET_COUNT];
	}
}

- (void)setCursorFrame: (CGRect)frame {
	self.cursor.frame = frame;
	if (self.itemViews.count) {
		for (KDWheelItem *item in self.itemViews) {
			item.topOffset = self.cursor.frame.size.height + 2;
		}
	}
}

/**
 * inner method. select specific item use CENTER.
 * This means this method is used to update center item.
 **/
- (void)selectItem:(NSInteger)center {
	//	NSLog(@"curr: %d, new: %d", (int)self.centerIndex, (int)center);
	NSInteger realCenter = self.centerIndex + OFFSET_COUNT;
	
	if (realCenter == center) {
		return;
	}
	
	if (realCenter >= 0 && realCenter < self.itemViews.count) {
		KDWheelItem *item = (KDWheelItem *)[self.itemViews objectAtIndex:realCenter];
		item.highlight = NO;
	}
	
	_centerIndex = center - OFFSET_COUNT;
	
	KDWheelItem *item = (KDWheelItem *)[self.itemViews objectAtIndex:center];
	if (item) {
		item.highlight = YES;
	}
	
	// delegate
	if (self.wheelDelegate) {
		[self.wheelDelegate KDWheel:self didSelectItemAtIndex:self.centerIndex];
	}
}

- (void)autoSettle {
	[self settle:[self calcCenter]];
}

- (void)settle: (NSInteger)index {
	[self selectItem:index];
	CGFloat targetX = (index - OFFSET_COUNT) * self.itemWidth;
	CGFloat currX = self.contentOffset.x;
	double time = fmin(0.3f, fabs(targetX - currX) / self.itemWidth / 2.f);
	[UIView animateWithDuration:time animations:^{
		self.contentOffset = CGPointMake(targetX, 0);
	}];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.cursor.frame = CGRectMake(self.frame.size.width / 2.f - self.cursor.frame.size.width / 2.f + self.contentOffset.x, 0, self.cursor.frame.size.width, self.cursor.frame.size.height);
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.x < -self.frame.size.width / 2.f) {
		scrollView.contentOffset = CGPointMake(-self.frame.size.width / 2.f, 0);
	} else if (scrollView.contentOffset.x > self.contentSize.width - self.frame.size.width / 2.f){
		scrollView.contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width / 2.f, 0);
	}
	
	self.cursor.frame = CGRectMake(self.frame.size.width / 2.f - self.cursor.frame.size.width / 2.f + self.contentOffset.x, 0, self.cursor.frame.size.width, self.cursor.frame.size.height);
	
	[self selectItem:[self calcCenter]];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	NSLog(@"stop");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self autoSettle];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (!decelerate) {
		[self autoSettle];
	}
}
@end
