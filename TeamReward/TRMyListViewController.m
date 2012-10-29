//
//  TRMyListViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRMyListViewController.h"
#import "TRNode.h"
#import "TRRewardTableViewCell.h"
#import "TRRewardFacebookShareViewController.h"
#import "TRFacebookConnectionManager.h"
#import <FacebookSDK/FacebookSDK.h>

@interface TRMyListViewController ()

- (void)openShareViewWithNode:(TRNode *)node;
- (void)showIntroView;
- (void)hideIntroView;

@end

@implementation TRMyListViewController

@synthesize rewards;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Mine";
        [self.tabBarItem setImage:[UIImage imageNamed:@"108-badge.png"]];
        
        self.rewards = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synchronizeData) name:kTRNotificationDataRefresh object:nil];
        
        [self.table setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self->_refreshHeaderView == nil) {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.table.bounds.size.height, self.view.frame.size.width, self.table.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        [self.table addSubview:_refreshHeaderView];
    }
    
    // Do any additional setup after loading the view from its nib.
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rewards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TRRewardTableViewCell";
    TRRewardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TRRewardTableViewCell" owner:nil options:nil];
        for (id item in nibObjects) {
            if ([item isKindOfClass:[TRRewardTableViewCell class]]) {
                cell = (TRRewardTableViewCell *)item;
                break;
            }
        }
    }
    
    // Configure the cell...
    TRNode *node = (TRNode *)[self.rewards objectAtIndex:[indexPath row]];
    cell.senderName.text = node.sender_name ? node.sender_name : node.sender_mail;
    cell.dateOfRewardField.text = [node shortCreatedDateFormat];
    cell.rewardMessageField.text = node.title;
    cell.rewardNode = node;
    cell.delegate = self;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

#pragma mark -
#pragma mark Custom actions

- (void)synchronizeData {
    NSLog(@"%s", __FUNCTION__);
    self->_refreshHeaderIsRefreshing = YES;
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathViewsMyReceivedRewards usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.delegate = self;
    }];
}

- (void)openShareViewWithNode:(TRNode *)node {
    [TRRewardFacebookShareViewController openSharingViewControllerOn:self withText:[NSString stringWithFormat:@"I've got a Thank You! from %@.", node.sender_name ? node.sender_name : node.sender_mail]];
}

- (void)showIntroView {
    if (self->getRewardIntroViewController == nil) {
        self->getRewardIntroViewController = [[TRGetRewardIntroViewController alloc] initWithNibName:@"TRGetRewardIntroViewController" bundle:nil];
        [self.view addSubview:self->getRewardIntroViewController.view];
    }
    
    [self->getRewardIntroViewController.view setHidden:NO];
}

- (void)hideIntroView {
    [self->getRewardIntroViewController.view setHidden:YES];
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    [self->_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    self->_refreshHeaderIsRefreshing = NO;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"%s", __FUNCTION__);
    self->_refreshHeaderIsRefreshing = NO;
    [self->_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    
    if ([objects count] > 0) {
        self.rewards = [NSMutableArray arrayWithArray:objects];
        [self.table reloadData];
        [self hideIntroView];
        [self.table setHidden:NO];
    }
    else {
        [self showIntroView];
        [self.table setHidden:YES];
    }
}

#pragma mark TRRewardTableViewCellDelegate

- (void)TRRewardTableViewCell:(TRRewardTableViewCell *)withCell DidClickedFacebookOnNode:(TRNode *)node {
    NSLog(@"Here I am. %@", node);
    if (![[FBSession activeSession] isOpen]) {
        TRFacebookConnectionManager *facebookManager = [TRFacebookConnectionManager sharedManager];
        [facebookManager setCallback:^(FBSessionState state, NSError *error) {
            NSLog(@"Yay it's back.");
            [self openShareViewWithNode:node];
        }];
        [facebookManager openFacebookSessionWithAllowLoginUI:YES];
    }
    else {
        NSLog(@"Already connected to FB.");
        [self openShareViewWithNode:node];
    }
}

#pragma mark EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    [self synchronizeData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return self->_refreshHeaderIsRefreshing;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self->_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self->_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
