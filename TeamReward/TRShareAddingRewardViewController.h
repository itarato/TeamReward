//
//  TRShareAdingRewardViewController.h
//  TeamReward
//
//  Created by Peter Arato on 11/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRShareAddingRewardDelegate.h"

@interface TRShareAddingRewardViewController : UIViewController

@property (nonatomic, copy) id<TRShareAddingRewardDelegate> delegate;

- (IBAction)onClickFacebook:(id)sender;
- (IBAction)onClickTwitter:(id)sender;
- (IBAction)onClickCancel:(id)sender;

@end
