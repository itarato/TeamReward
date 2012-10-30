//
//  TRFacebookActionBlock.h
//  TeamReward
//
//  Created by Peter Arato on 10/30/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRFacebookActionBlock : NSObject {
    void(^action)(void);
    void(^completion)(void);
    BOOL isWritePermissionRequired;
}

- (void)executeAction;
- (void)executeCompletion;
+ (TRFacebookActionBlock *)actionBlockWith:(void(^)(void))action isWritePermissionRequired:(BOOL)required withCompletion:(void(^)(void))completion;

@end
