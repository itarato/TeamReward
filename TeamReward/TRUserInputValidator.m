//
//  TRUserInputValidator.m
//  TeamReward
//
//  Created by Peter Arato on 11/11/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRUserInputValidator.h"

@implementation TRUserInputValidator

+ (BOOL)validateValue:(id)value against:(u_int)validateFlasgs {
    @try {
        if (validateFlasgs | kTRUserInputValidatorValueExist &&
            (value == nil || value == NULL)) {
            return NO;
        }
        
        if (validateFlasgs | kTRUserInputValidatorIsEmail) {
            NSError *error = NULL;
            NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$" options:NSRegularExpressionCaseInsensitive error:&error];
            if (![regexp numberOfMatchesInString:value options:0 range:NSMakeRange(0, [value length])]) {
                return NO;
            }
        }
        
        if (validateFlasgs | kTRUserInputValidatorNonEmptyString) {
            if (![[value class] isSubclassOfClass:[NSString class]] || [value length] == 0) {
                return NO;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"User input validation error: %@", exception);
        return NO;
    }
    
    return YES;
}

@end
