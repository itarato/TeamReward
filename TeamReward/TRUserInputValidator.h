//
//  TRUserInputValidator.h
//  TeamReward
//
//  Created by Peter Arato on 11/11/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTRUserInputValidatorValueExist 1
#define kTRUserInputValidatorIsEmail    2
#define kTRUserInputValidatorNonEmptyString 4

@interface TRUserInputValidator : NSObject

+ (BOOL)validateValue:(id)value against:(u_int)validateFlasgs;

@end
