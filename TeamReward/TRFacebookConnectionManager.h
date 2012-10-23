//
//  TRFacebookConnectionManager.h
//  TeamReward
//
//  Created by Peter Arato on 10/23/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^TRFacebookCompletionBlock)(FBSessionState state, NSError *error);

@interface TRFacebookConnectionManager : NSObject {
    TRFacebookCompletionBlock callbackBlock;
}

- (void)setCallback:(TRFacebookCompletionBlock)block;

// Facebook state change handler.
- (void)facebookSessionStateChanged:(FBSession *)session
                              state:(FBSessionState)state
                              error:(NSError *)error;

// Action to call the Facebook login and permission provider view.
- (BOOL)openFacebookSessionWithAllowLoginUI:(BOOL)allowLoginUI;

// Singleton instance.
+ (TRFacebookConnectionManager *)sharedManager;

@end
