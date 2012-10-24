//
//  TRNode.h
//  TeamReward
//
//  Created by Peter Arato on 10/7/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRNode : NSObject

@property (nonatomic, retain) NSNumber *nid;
@property (nonatomic, retain) NSString *title;
@property BOOL status;
@property (nonatomic, retain) NSNumber *authorUid;
@property NSTimeInterval created_at;
@property (nonatomic, retain) NSString *sender_name;
@property (nonatomic, retain) NSString *sender_mail;
@property (nonatomic, retain) NSString *recipient_name;
@property (nonatomic, retain) NSString *recipient_mail;

- (NSString *)shortCreatedDateFormat;

@end
