//
//  TRUser.m
//  TeamReward
//
//  Created by Peter Arato on 10/6/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRUser.h"

#define kTRUserUndefined -1

TRUser *_activeUser = nil;

@implementation TRUser

@synthesize uid;
@synthesize mail;
@synthesize name;

- (id)init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.mail = @"";
        self.uid = [NSNumber numberWithInt: kTRUserUndefined];
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TRUser [uid: %d mail: %@ name: %@]", [self->uid intValue], self->mail, self->name];
}

#pragma mark Custom actions

+ (TRUser *)activeUser {
    return _activeUser;
}

+ (void)setActiveUser:(TRUser *)user {
    _activeUser = user;
}

@end
