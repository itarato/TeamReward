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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    if (indexPath.row & 1) {
        cell.topView.backgroundColor = [UIColor colorWithRed:252.0f/255.0f green:58.0f/255.0f blue:41.0f/255.0f alpha:1.0f];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

#pragma mark Custom actions

- (void)synchronizeData {
    NSLog(@"%s", __FUNCTION__);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathViewsMyReceivedRewards usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.delegate = self;
    }];
}

- (void)openShareViewWithNode:(TRNode *)node {
    [TRRewardFacebookShareViewController openSharingViewControllerOn:self withText:[NSString stringWithFormat:@"I've got a Thank You! from %@.", node.sender_name ? node.sender_name : node.sender_mail]];
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"%s", __FUNCTION__);
    self.rewards = [NSMutableArray arrayWithArray:objects];
    [self.table reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    NSLog(@"%s", __FUNCTION__);
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

@end
