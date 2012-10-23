//
//  TRSystemConnect.m
//  TeamReward
//
//  Created by Peter Arato on 10/5/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRSystemConnect.h"
#import "TRUser.h"

@implementation TRSystemConnect

@synthesize sessid;
@synthesize user;

- (NSString *)description {
    return [NSString stringWithFormat:@"TRSystemConnect [sessid: %@ user: %@]", self.sessid, self.user];
}

- (BOOL)isLoggedIn {
    return self.user.uid != nil && [self.user.uid intValue] > 0;
}

@end
