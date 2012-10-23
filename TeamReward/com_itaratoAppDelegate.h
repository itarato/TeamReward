//
//  com_itaratoAppDelegate.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class TRNetworkIndicatorViewController;

@interface com_itaratoAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, RKRequestQueueDelegate> {
    // Network progress indicator.
    TRNetworkIndicatorViewController *networkIndicator;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

// Makes the necessary networing setup.
- (void)setUpRestKit;

@end
