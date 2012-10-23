//
//  TRSettingsViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRSettingsViewController.h"
#import "TRLoginViewController.h"
#import "TRUser.h"

@interface TRSettingsViewController ()

@end

@implementation TRSettingsViewController

@synthesize nameTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Profile";
        [self.tabBarItem setImage:[UIImage imageNamed:@"20-gear2.png"]];
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

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __FUNCTION__);
    TRUser *activeUser = [TRUser activeUser];
    NSLog(@"Load user full info: %d", [activeUser.uid intValue]);
    [[RKObjectManager sharedManager] getObject:activeUser delegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

#pragma mark Custom actons

- (void)synchronizeData {
    
}

- (void)onClickLogout:(id)sender {
    [TRLoginViewController presentLoginViewControllerOn:self withActionBlock:^(TRLoginViewController *loginViewController) {
        [loginViewController logout];
    }];
    
}

- (void)onClickSave:(id)sender {
    TRUser *activeUser = [TRUser activeUser];
    [[RKObjectManager sharedManager] putObject:activeUser usingBlock:^(RKObjectLoader *loader) {
        loader.delegate = self;
        loader.params = [NSDictionary dictionaryWithKeysAndObjects:
                         @"field_people_name[und][0][value]", self.nameTextField.text,
                         nil];
    }];
    [self.nameTextField resignFirstResponder];
}

- (void)onHitDoneKey:(id)sender {}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"%s", __FUNCTION__);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    NSLog(@"%s - %@", __FUNCTION__, [objectLoader resourcePath]);
    TRUser *user = (TRUser *)object;
    NSLog(@"Got user: %@", user);
    if ([objectLoader method] == RKRequestMethodGET) {
        [TRUser setActiveUser:user];
        self.nameTextField.text = user.name;
    }
}

@end
