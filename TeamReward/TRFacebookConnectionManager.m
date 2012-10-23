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

- (void)facebookSessionStateChanged:(FBSession *)session
                              state:(FBSessionState)state
                              error:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    switch (state) {
        case FBSessionStateOpen:
            NSLog(@"FBSessionStateOpen");
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosed/Failed");
            [[FBSession activeSession] closeAndClearTokenInformation];
            break;
        case FBSessionStateOpenTokenExtended:
            NSLog(@"FBSessionStateOpenTokenExtended");
            break;
        default:
            NSLog(@"FBSession state else");
            break;
    }
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }
    
    if (self->callbackBlock != nil) {
        self->callbackBlock(state, error);
        self->callbackBlock = nil;
    }
    else {
        NSLog(@"ERROR - missing block.");
    }
}

- (void)setCallback:(TRFacebookCompletionBlock)block {
    self->callbackBlock = block;
}

- (BOOL)openFacebookSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:nil
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             [self facebookSessionStateChanged:session
                                                                         state:status
                                                                         error:error];
                                         }];
}

@end
