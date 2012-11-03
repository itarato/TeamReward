//
//  UIColor+TRColorAddition.m
//  TeamReward
//
//  Created by Peter Arato on 11/1/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "UIColor+TRColorAddition.h"

@implementation UIColor (TRColorAddition)

+ (UIColor *)colorWith255Red:(int)red green:(int)green blue:(int)blue {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1.0f];
}

+ (UIColor *)colorWith255Red:(int)red green:(int)green blue:(int)blue darkened:(CGFloat)percentage {
    if (percentage >= 1.0f) {
        return [UIColor blackColor];
    }
    
    if (percentage <= 0.0f) {
        return [UIColor whiteColor];
    }
    
    return [UIColor colorWithRed:red * (1.0f - percentage) / 255.0f
                           green:green * (1.0f - percentage) / 255.0f
                            blue:blue * (1.0f - percentage) / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWith255Red:(int)red green:(int)green blue:(int)blue lightened:(CGFloat)percentage {
    if (percentage >= 1.0f) {
        return [UIColor whiteColor];
    }
    
    if (percentage <= 0.0f) {
        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:red + ((255.0f - red) * percentage) / 255.0f
                           green:green + ((255.0f - green) * percentage) / 255.0f
                            blue:blue + ((255.0f - blue) * percentage) / 255.0f
                           alpha:1.0f];
}

@end
