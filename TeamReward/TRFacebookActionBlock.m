//
//  TRFacebookActionBlock.m
//  TeamReward
//
//  Created by Peter Arato on 10/30/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRFacebookActionBlock.h"

@implementation TRFacebookActionBlock

- (void)executeAction {
    self->action();
}

- (void)executeCompletion {
    self->completion();
}

+ (TRFacebookActionBlock *)actionBlockWith:(void (^)(void))action isWritePermissionRequired:(BOOL)required withCompletion:(void (^)(void))completion {
    TRFacebookActionBlock *facebookActionBlock = [[TRFacebookActionBlock alloc] init];
    
    facebookActionBlock->action = action;
    facebookActionBlock->completion = completion;
    facebookActionBlock->isWritePermissionRequired = required;
    
    return facebookActionBlock;
}

@end
