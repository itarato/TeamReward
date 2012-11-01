//
//  TRRewardTableViewCell.h
//  TeamReward
//
//  Created by Peter Arato on 10/17/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRewardTableViewCellDelegate.h"

@class TRNode;

@interface TRRewardTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *senderName;
@property (nonatomic, retain) IBOutlet UILabel *rewardMessageField;
@property (nonatomic, retain) IBOutlet UILabel *dateOfRewardField;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) TRNode *rewardNode;

@property (nonatomic, retain) id <TRRewardTableViewCellDelegate> delegate;

- (IBAction)onClickFacebookShare:(id)sender;
- (IBAction)onClickTwitterShare:(id)sender;
- (void)onSwipe;
- (void)onSwipeBack;

@end
