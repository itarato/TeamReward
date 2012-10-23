//
//  TRUser.h
//  TeamReward
//
//  Created by Peter Arato on 10/6/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRUser : NSObject

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, retain) NSString *mail;
// Represents: field_people_name.
@property (nonatomic, retain) NSString *name;

+ (TRUser *)activeUser;
+ (void)setActiveUser:(TRUser *)user;

@end
