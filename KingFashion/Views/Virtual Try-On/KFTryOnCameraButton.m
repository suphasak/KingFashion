//
//  KFTryOnCameraButton.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/19/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFTryOnCameraButton.h"

@implementation KFTryOnCameraButton

//-------------------------------------------------------------------------------------------------
#pragma mark - Constants
//-------------------------------------------------------------------------------------------------
static CGFloat const RING_WIDTH_DEFAULT = 4;
#define RING_COLOR_DEFAULT [UIColor whiteColor]

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _ringWidth = RING_WIDTH_DEFAULT;
        _ringColor = RING_COLOR_DEFAULT;
    }

    return self;
}

//-------------------------------------------------------------------------------------------------
#pragma mark - Rendering
//-------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    UIBezierPath *outerCircle = [UIBezierPath bezierPathWithOvalInRect:rect];
    UIEdgeInsets innerCircleInsets = UIEdgeInsetsMake(self.ringWidth, self.ringWidth, self.ringWidth, self.ringWidth);
    CGRect innerCircleRect = UIEdgeInsetsInsetRect(rect, innerCircleInsets);
    UIBezierPath *innerCircle = [UIBezierPath bezierPathWithOvalInRect:innerCircleRect];

    [outerCircle appendPath:[innerCircle bezierPathByReversingPath]];
    [self.ringColor setFill];
    [outerCircle fill];
}

- (void)setRingWidth:(CGFloat)ringWidth {
    _ringWidth = ringWidth;
    [self setNeedsDisplay];
}

- (void)setRingColor:(UIColor *)ringColor {
    _ringColor = ringColor;
    [self setNeedsDisplay];
}

@end
