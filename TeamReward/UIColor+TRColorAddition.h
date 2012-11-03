//
//  UIColor+TRColorAddition.h
//  TeamReward
//
//  Created by Peter Arato on 11/1/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TRColorAddition)

+ (UIColor *)colorWith255Red:(int)red green:(int)green blue:(int)blue;
+ (UIColor *)colorWith255Red:(int)red green:(int)green blue:(int)blue darkened:(CGFloat)percentage;
+ (UIColor *)colorWith255Red:(int)red green:(int)green blue:(int)blue lightened:(CGFloat)percentage;

@end
