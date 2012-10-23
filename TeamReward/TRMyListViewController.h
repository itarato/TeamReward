//
//  TRMyListViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRewardTableViewCellDelegate.h"

@interface TRMyListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, TRRewardTableViewCellDelegate>

@property (nonatomic, retain) NSMutableArray *rewards;
@property (nonatomic, retain) IBOutlet UITableView *table;

- (void)synchronizeData;

@end
