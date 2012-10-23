//
//  TRNode.m
//  TeamReward
//
//  Created by Peter Arato on 10/7/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRNode.h"

@implementation TRNode

@synthesize nid;
@synthesize authorUid;
@synthesize title;
@synthesize created_at;
@synthesize status;

- (NSString *)description {
    return [NSString stringWithFormat:@"TRNode [nid: %d title: %@]", [self.nid intValue], self.title];
}

@end
