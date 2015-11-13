//
//  ViewController.m
//  KDWheel
//
//  Created by Kyle on 15/11/13.
//  Copyright © 2015年 lantouzi. All rights reserved.
//

#import "ViewController.h"
#import "KDWheel.h"

@interface ViewController () <KDWheelDelegate>

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.navigationItem.title = @"KDWheel";
	
	
	KDWheel *wheel = [[KDWheel alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 75)];
	wheel.backgroundColor = HEXRGBCOLOR(0xFAFAFA);
	NSMutableArray<NSString *> *m = [[NSMutableArray alloc] init];
	for (int i = 1; i < 20; i++) {
		[m addObject:[NSString stringWithFormat:@"%d", i * 100]];
	}
	wheel.additionalMark = @"元";
	wheel.items = m;
	[self.view addSubview:wheel];
	[wheel selectIndex:7 animated:NO];
	
	
	KDWheel *wheel2 = [[KDWheel alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 60)];
	wheel2.backgroundColor = HEXRGBCOLOR(0x444444);
	NSMutableArray<NSString *> *m2 = [[NSMutableArray alloc] init];
	for (int i = 1; i < 20; i++) {
		[m2 addObject:[NSString stringWithFormat:@"%d", i]];
	}
	wheel2.additionalMark = @"m";
	wheel2.items = m2;
	wheel2.wheelDelegate = self;
	[self.view addSubview:wheel2];
	wheel2.itemWidth = 45;
	wheel2.offsetCount = 8;
	[wheel2 setCursorFrame:CGRectMake(0, 0, 14, 10)];
	wheel2.highlightColor = HEXRGBCOLOR(0x7CD717);
	wheel2.markHeight = 14;
	wheel2.markShrink = 3;
	wheel2.markColor = HEXRGBACOLOR(0x7CD717, 0.1f);
	wheel2.markTextColor = HEXRGBCOLOR(0xEEEEEE);
	
	self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 60)];
	self.textLabel.textAlignment = NSTextAlignmentCenter;
	[self.view addSubview:self.textLabel];
	
	[self refreshSelect:wheel2.centerIndex];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void)KDWheel:(KDWheel *)wheel didSelectItemAtIndex:(NSInteger)index {
	[self refreshSelect:index];
}

- (void)refreshSelect: (NSInteger)selectedIndex {
	self.textLabel.text = [NSString stringWithFormat:@"Select index: %d", (int)selectedIndex];
}

@end
