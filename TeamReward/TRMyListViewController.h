//
//  TRMyListViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRewardTableViewCellDelegate.h"
#import "EGORefreshTableHeaderView.h"
#import "TRGetRewardIntroViewController.h"

@interface TRMyListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate, TRRewardTableViewCellDelegate, EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _refreshHeaderIsRefreshing;
    TRGetRewardIntroViewController *getRewardIntroViewController;
}

@property (nonatomic, retain) NSMutableArray *rewards;
@property (nonatomic, retain) IBOutlet UITableView *table;

- (void)synchronizeData;

@end
