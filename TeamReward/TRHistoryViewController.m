//
//  TRHistoryViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRHistoryViewController.h"
#import "TRNode.h"

@interface TRHistoryViewController ()

@end

@implementation TRHistoryViewController

@synthesize table;
@synthesize history;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"History";
        [self.tabBarItem setImage:[UIImage imageNamed:@"44-shoebox.png"]];
        
        self.history = [[NSMutableArray alloc] init];
        
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
    return [self.history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    TRNode *node = [self.history objectAtIndex:[indexPath row]];
    cell.textLabel.text = node.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"On %@ to %@.", [node shortCreatedDateFormat], node.recipient_name ? node.recipient_name : node.recipient_mail];
    
    return cell;
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"%s", __FUNCTION__);

    self.history = [NSMutableArray arrayWithArray:objects];
    [self.table reloadData];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark Custom action

- (void)synchronizeData {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathViewsMyRewards usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodGET;
        loader.delegate = self;
    }];
}

@end
