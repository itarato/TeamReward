//
//  TRShareAddingRewardDelegate.h
//  TeamReward
//
//  Created by Peter Arato on 11/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TRShareAddingRewardDelegate <NSObject>

@optional

- (void)shareAddingRewardDidHitTwitter;
- (void)shareAddingRewardDidHitFacebook;

@end
