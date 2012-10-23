//
//  TRRewardTableViewCellDelegate.h
//  TeamReward
//
//  Created by Peter Arato on 10/21/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TRRewardTableViewCell;
@class TRNode;

@protocol TRRewardTableViewCellDelegate <NSObject>

@optional

- (void)TRRewardTableViewCell:(TRRewardTableViewCell *)withCell DidClickedFacebookOnNode:(TRNode *)node;

@end
