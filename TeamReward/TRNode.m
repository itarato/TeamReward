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
@synthesize sender_mail;
@synthesize sender_name;
@synthesize recipient_mail;
@synthesize recipient_name;

- (NSString *)description {
    return [NSString stringWithFormat:@"TRNode [nid: %d title: %@]", [self.nid intValue], self.title];
}

- (NSString *)shortCreatedDateFormat {
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:self.created_at];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    
    return [formatter stringFromDate:date];
}

@end
