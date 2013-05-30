//
//  DrawPicView.m
//  osmall
//
//  Created by 刘 鑫华 on 12-8-8.
//  Copyright (c) 2012年 COSDocument.org. All rights reserved.
//

#import "DrawPicView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DrawPicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.*/
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Drawing code
    // Drawing lines with a white stroke color
    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 1.0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    //线条粗度
    CGContextSetLineWidth(context, 2.0);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, self.frame.origin.x-5, self.frame.origin.y);
    CGContextAddLineToPoint(context, 275.0, self.frame.origin.y);
    CGContextStrokePath(context);
}


@end
