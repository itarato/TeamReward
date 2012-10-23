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
#import "com_itaratoAppDelegate.h"
#import "TRRewardFacebookShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface TRMyListViewController ()

@end

@implementation TRMyListViewController

@synthesize rewards;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"My rewards";
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
    cell.recipientField.text = node.title;
    cell.rewardNode = node;
    cell.delegate = self;
    
    return cell;
}

#pragma mark Custom actions

- (void)synchronizeData {
    NSLog(@"%s", __FUNCTION__);
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathViewsMyRewards usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.delegate = self;
    }];
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
        com_itaratoAppDelegate *appDelegate = (com_itaratoAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate openFacebookSessionWithAllowLoginUI:YES withCompletion:^(FBSessionState state, NSError *error) {
            NSLog(@"Yay it's back.");
            if (![TRRewardFacebookShareViewController isOpen]) {
                [TRRewardFacebookShareViewController openSharingViewControllerOn:self withText:@"Hello world"];
            }
        }];
    }
    else {
        NSLog(@"Already connected to FB.");
        if (![TRRewardFacebookShareViewController isOpen]) {
            [TRRewardFacebookShareViewController openSharingViewControllerOn:self withText:@"Hello world"];
        }
    }
}

@end
