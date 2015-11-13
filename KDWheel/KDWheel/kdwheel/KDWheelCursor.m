//
//  KDWheelCursor.m
//  KDWheel
//
//  Created by Kyle on 15/11/13.
//  Copyright © 2015年 lantouzi. All rights reserved.
//

#import "KDWheelCursor.h"

@interface KDWheelCursor()

@property (nonatomic, assign) CGFloat cursorWidth;
@property (nonatomic, assign) CGFloat cursorHeight;

@end

@implementation KDWheelCursor

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	self.backgroundColor = [UIColor clearColor];
	self.cursorHeight = self.frame.size.height;
	self.cursorWidth = self.frame.size.width;
}

-(void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	self.cursorHeight = self.frame.size.height;
	self.cursorWidth = self.frame.size.width;
	[self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
	[self drawCursor];
}

- (void)setCursorHeight:(CGFloat)cursorHeight {
	_cursorHeight = cursorHeight;
	[self.superview layoutIfNeeded];
}

- (void)setCursorWidth:(CGFloat)cursorWidth {
	_cursorWidth = cursorWidth;
	[self.superview layoutIfNeeded];
}

- (void)drawCursor {
	CGFloat cx = self.frame.size.width / 2.f;
	
	[self.highlightColor setFill];
	
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointMake(cx + self.cursorWidth / 2, 0)];
	[path addLineToPoint:CGPointMake(cx + self.cursorWidth / 2, self.cursorHeight / 2)];
	[path addLineToPoint:CGPointMake(cx, self.cursorHeight)];
	[path addLineToPoint:CGPointMake(cx - self.cursorWidth / 2, self.cursorHeight / 2)];
	[path addLineToPoint:CGPointMake(cx - self.cursorWidth / 2, 0)];
	[path closePath];
	[path fill];
}


@end