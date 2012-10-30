//
//  TRFacebookConnectionManager.h
//  TeamReward
//
//  Created by Peter Arato on 10/23/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@class TRFacebookActionBlock;

#define kTRFacebookMessageLink          @"link"
#define kTRFacebookMessageName          @"name"
#define kTRFacebookMessageCaption       @"caption"
#define kTRFacebookMessageDescription   @"description"

@interface TRFacebookConnectionManager : NSObject {
//    TRFacebookActionBlock *actionToCall;
    void (^callback)(void);
}

- (void)publishToWall:(NSDictionary *)params withCompletion:(void(^)(void))block;

// Singleton instance.
+ (TRFacebookConnectionManager *)sharedManager;

@end
