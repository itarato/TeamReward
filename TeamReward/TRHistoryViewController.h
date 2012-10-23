//
//  TRHistoryViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSMutableArray *history;

- (void)synchronizeData;

@end
