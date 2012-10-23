//
//  com_itaratoAppDelegate.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^TRFacebookCompletionBlock)(FBSessionState state, NSError *error);

@class TRNetworkIndicatorViewController;

@interface com_itaratoAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, RKRequestQueueDelegate> {
    // Network progress indicator.
    TRNetworkIndicatorViewController *networkIndicator;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

// Makes the necessary networing setup.
- (void)setUpRestKit;

// Facebook state change handler.
- (void)facebookSessionStateChanged:(FBSession *)session
                              state:(FBSessionState)state
                              error:(NSError *)error
                         completion:(TRFacebookCompletionBlock)block;

// Action to call the Facebook login and permission provider view.
- (BOOL)openFacebookSessionWithAllowLoginUI:(BOOL)allowLoginUI withCompletion:(TRFacebookCompletionBlock)block;

@end
