//
//  GradientView.m
//  FlicrTest2
//
//  Created by Ivashin Dmitry on 10/21/16.
//  Copyright © 2016 Ivashin Dmitry. All rights reserved.
//

#import "GradientView.h"

#define UIViewAutoresizingFlexibleMargins\
            UIViewAutoresizingFlexibleWidth|\
            UIViewAutoresizingFlexibleHeight


@implementation GradientView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleMargins;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleMargins;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[8] = { 0, 0, 0, 0.3, 0, 0, 0, 0.7 };
    CGFloat locations[2] = { 0.0, 1.0 };

    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    CGPoint point = CGPointMake(x, y);
    CGFloat radius = MAX(x, y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, point, 0.0, point, radius, kCGGradientDrawsAfterEndLocation);
}

@end

