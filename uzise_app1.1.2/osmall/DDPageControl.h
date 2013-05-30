//
//  DDPageControl.h
//  DDPageControl
//
//  Created by Damien DeVille on 1/14/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>
#import <UIKit/UIKitDefines.h>

typedef enum
{
	DDPageControlTypeOnFullOffFull		= 0,//两个都是实心的选中跟未选中的都是,选中的是高亮的
	DDPageControlTypeOnFullOffEmpty		= 1,//选中的点是实心的,没选中的是空心的
	DDPageControlTypeOnEmptyOffFull		= 2,//选中是空心的,未选中的是实心的
	DDPageControlTypeOnEmptyOffEmpty	= 3,//两个都是空心的,选中那个空心会高亮
}
DDPageControlType ;


@interface DDPageControl : UIControl 
{
	NSInteger numberOfPages ;
	NSInteger currentPage ;
}

// Replicate UIPageControl features
@property(nonatomic) NSInteger numberOfPages ;
@property(nonatomic) NSInteger currentPage ;

@property(nonatomic) BOOL hidesForSinglePage ;

@property(nonatomic) BOOL defersCurrentPageDisplay ;
- (void)updateCurrentPageDisplay ;

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount ;

/*
	DDPageControl add-ons - all these parameters are optional
	Not using any of these parameters produce a page control identical to Apple's UIPage control
 */
- (id)initWithType:(DDPageControlType)theType ;

@property (nonatomic) DDPageControlType type ;

@property (nonatomic,retain) UIColor *onColor ;
@property (nonatomic,retain) UIColor *offColor ;

@property (nonatomic) CGFloat indicatorDiameter ;
@property (nonatomic) CGFloat indicatorSpace ;

@end

