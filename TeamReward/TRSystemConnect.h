//
//  TRSystemConnect.h
//  TeamReward
//
//  Created by Peter Arato on 10/5/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRUser;

@interface TRSystemConnect : NSObject

@property (nonatomic, retain) NSString *sessid;
@property (nonatomic, retain) TRUser *user;

- (BOOL)isLoggedIn;

@end
