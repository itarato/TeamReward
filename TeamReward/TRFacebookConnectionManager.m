//
//  TRFacebookConnectionManager.m
//  TeamReward
//
//  Created by Peter Arato on 10/23/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRFacebookConnectionManager.h"

static TRFacebookConnectionManager *_sharedManager = nil;

@implementation TRFacebookConnectionManager

+ (TRFacebookConnectionManager *)sharedManager {
    if (_sharedManager == nil) {
        _sharedManager = [[TRFacebookConnectionManager alloc] init];
    }
    
    return _sharedManager;
}

@end
