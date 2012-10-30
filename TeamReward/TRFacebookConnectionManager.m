//
//  TRFacebookConnectionManager.m
//  TeamReward
//
//  Created by Peter Arato on 10/23/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRFacebookConnectionManager.h"
#import "TRFacebookActionBlock.h"

static TRFacebookConnectionManager *_sharedManager = nil;

@interface TRFacebookConnectionManager ()

// Facebook state change handler.
- (void)facebookSessionStateChanged:(FBSession *)session
                              state:(FBSessionState)state
                              error:(NSError *)error;

// Action to call the Facebook login and permission provider view.
- (BOOL)openFacebookSessionWithAllowLoginUI:(BOOL)allowLoginUI;

- (void)callActionWithWritePermission:(void (^)(void))action;

@end

@implementation TRFacebookConnectionManager

+ (TRFacebookConnectionManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[TRFacebookConnectionManager alloc] init];
    });
    
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
    else {
        if (self->callback) {
            self->callback();
            self->callback = nil;
        }
    }
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

- (void)callActionWithWritePermission:(void (^)(void))action {
    if ([[[FBSession activeSession] permissions] indexOfObject:@"publish_actions"] == NSNotFound) {
        [[FBSession activeSession] reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                     defaultAudience:FBSessionDefaultAudienceEveryone
                                                   completionHandler:^(FBSession *session, NSError *error) {
                                                       action();
                                                   }];
    }
    else {
        action();
    }
}

- (void)publishToWall:(NSDictionary *)params withCompletion:(void (^)(void))block {
    void (^pushActionBlock)(void) = ^{
        [FBRequestConnection
         startWithGraphPath:@"me/feed"
         parameters:params
         HTTPMethod:@"POST"
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             block();
         }];
    };
    
    if ([[FBSession activeSession] isOpen]) {
        [self callActionWithWritePermission:pushActionBlock];
    }
    else {
        TRFacebookConnectionManager *facebookManager = self;
        self->callback = ^{
            [facebookManager callActionWithWritePermission:pushActionBlock];
        };
        [self openFacebookSessionWithAllowLoginUI:YES];
    }
}

@end
