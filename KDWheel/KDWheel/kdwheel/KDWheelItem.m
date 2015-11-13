//
//  KDWheelItem.m
//  MCManual
//
//  Created by Kyle on 15/10/20.
//  Copyright © 2015年 Kyle. All rights reserved.
//

#import "KDWheelItem.h"

#define PO(x, y) CGPointMake(x, y)

//#define CURSOR_HEIGHT 15
#define SCALE_LINE_HEIGHT self.markHeight
#define SCALE_MARK_TEXT_HEIGHT 16
#define DIVIDER 5


//#define MARK_UNIT @"元"

#define MARK_SPACE_FONT_SIZE 22
#define MARK_FONT_SIZE_HIGHLIGHT 18
#define MARK_FONT_SIZE 16

typedef enum {
	KDWVScaleTypeNormal,
	KDWVScaleTypeNormalMain,
	KDWVScaleTypeFade,
	KDWVScaleTypeHighlightMain,
} KDWVScaleType;

typedef enum {
	KDWVMarkTypeNormal,
	KDWVMarkTypeHighlight,
} KDWVMarkType;

@interface KDWheelItem ()
@property (nonatomic, strong) UIColor *fadeColor;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat subInterval;
@end

@implementation KDWheelItem
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
	self.backgroundColor = [UIColor clearColor];
	self.markHeight = 20;
	self.markShrink = 3;
}

#pragma mark - Getter & Setter
-(void)setHighlight:(BOOL)highlight {
	_highlight = highlight;
	[self setNeedsDisplay];
}

- (void)setHighlightColor:(UIColor *)highlightColor {
	_highlightColor = highlightColor;
	self.fadeColor = [_highlightColor colorWithAlphaComponent:0.3];
	[self setNeedsDisplay];
}


- (void)setMarkHeight:(CGFloat)markHeight {
	_markHeight = markHeight;
	[self setNeedsDisplay];
}

- (void)setMarkShrink:(CGFloat)markShrink {
	_markShrink = markShrink;
	[self setNeedsDisplay];
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect {
	self.subInterval = self.frame.size.width / 5.f;
	self.centerX = self.frame.size.width / 2.f;
	for (int j = -2; j <= 2; j++) {
		KDWVScaleType scaleType = KDWVScaleTypeNormal;
		if (self.highlight) {
			if (j == 0) {
				scaleType = KDWVScaleTypeHighlightMain;
			} else if (abs(j) == 1){
				scaleType = KDWVScaleTypeFade;
			}
		} else {
			if (j == 0) {
				scaleType = KDWVScaleTypeNormalMain;
			}
		}
		
		[self drawScaleLine:j * _subInterval type:scaleType];
	}
	
	if (self.text != nil && self.text.length > 0) {
		if (self.highlight) {
			[self drawMark:self.text x:self.centerX type:KDWVMarkTypeHighlight];
		} else {
			[self drawMark:self.text x:self.centerX type:KDWVMarkTypeNormal];
		}
	}
}

#define MARK_Y_START self.topOffset + DIVIDER
#define MARK_Y_END MARK_Y_START + SCALE_LINE_HEIGHT

- (void)drawScaleLine: (CGFloat)x type: (KDWVScaleType)type {
	switch (type) {
		case KDWVScaleTypeHighlightMain:
			[self drawLineFrom:PO(x + self.centerX, MARK_Y_START) to:PO(x + self.centerX, MARK_Y_END) lineWidth:2 color:self.highlightColor];
			break;
		case KDWVScaleTypeFade:
			[self drawLineFrom:PO(x + self.centerX, MARK_Y_START + self.markShrink) to:PO(x + self.centerX, MARK_Y_END - self.markShrink) color:self.fadeColor];
			break;
		case KDWVScaleTypeNormalMain:
			[self drawLineFrom:PO(x + self.centerX, MARK_Y_START) to:PO(x + self.centerX, MARK_Y_END) lineWidth:2 color:self.markColor];
			break;
		case KDWVScaleTypeNormal:
		default:
			[self drawLineFrom:PO(x + self.centerX, MARK_Y_START + self.markShrink) to:PO(x + self.centerX, MARK_Y_END - self.markShrink) color:self.markColor];
			break;
	}
}

- (void)drawLineFrom: (CGPoint)startPoint to: (CGPoint)endPoint color: (UIColor *)color {
	[self drawLineFrom:startPoint to:endPoint lineWidth:1 color:color];
}

- (void)drawLineFrom: (CGPoint)startPoint to: (CGPoint)endPoint lineWidth: (CGFloat)lineWidth color: (UIColor *)color {
	[color setStroke];
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path setLineWidth:lineWidth];
	[path moveToPoint:startPoint];
	[path addLineToPoint:endPoint];
	[path stroke];
}


- (void)drawMark: (NSString *)mark x:(CGFloat)x type: (KDWVMarkType)type {
	UIFont *largeFont = [UIFont boldSystemFontOfSize: MARK_SPACE_FONT_SIZE];
	
	UIFont *font = [UIFont boldSystemFontOfSize:type == KDWVMarkTypeHighlight ? MARK_FONT_SIZE_HIGHLIGHT : MARK_FONT_SIZE];
	
	CGSize fontSize = [mark sizeWithAttributes:@{NSFontAttributeName : font}];
	CGFloat textOffset = fontSize.width / 2.f;

	
	CGFloat vPos = [mark sizeWithAttributes:@{NSFontAttributeName : largeFont}].height;
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	style.alignment = NSTextAlignmentCenter;
	
	if (type == KDWVMarkTypeHighlight) {
		UIFont *unitFont = [UIFont boldSystemFontOfSize:MARK_FONT_SIZE];
		CGSize unitSize = self.additionMark.length == 0 ? CGSizeZero : [self.additionMark sizeWithAttributes:@{NSFontAttributeName : unitFont}];
		
		[mark drawAtPoint:PO(x - textOffset - unitSize.width / 2.f, self.topOffset + DIVIDER + SCALE_LINE_HEIGHT + vPos - fontSize.height) withAttributes:@{NSFontAttributeName : font,
																												  NSForegroundColorAttributeName : self.highlightColor,
																												  NSParagraphStyleAttributeName : style}];
		
		if (unitSize.width != 0) {
			[self.additionMark drawAtPoint:PO(x + textOffset - unitSize.width / 2.f, self.topOffset + DIVIDER + SCALE_LINE_HEIGHT + vPos - unitSize.height) withAttributes:@{NSFontAttributeName : unitFont,
																																						   NSForegroundColorAttributeName : self.highlightColor,
																																						   NSParagraphStyleAttributeName : style}];
		}
	} else {
		[mark drawAtPoint:PO(x - textOffset, self.topOffset + DIVIDER + SCALE_LINE_HEIGHT + vPos - fontSize.height) withAttributes:@{NSFontAttributeName : font,
																												  NSForegroundColorAttributeName : self.markTextColor,
																												  NSParagraphStyleAttributeName : style}];
	}
}

@end
