//
//  TRAddRewardViewController.m
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "TRAddRewardViewController.h"
#import "TRUser.h"
#import <AddressBookUI/AddressBookUI.h>

@interface TRAddRewardViewController ()

@end

@implementation TRAddRewardViewController

@synthesize rewardTextField;
@synthesize emailField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"ThankYou";
        [self.tabBarItem setImage:[UIImage imageNamed:@"10-medical.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 44)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    
    self.rewardTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 44)];
    self.rewardTextField.leftViewMode = UITextFieldViewModeAlways;
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

#pragma mark Custom actions

- (void)onClickSend:(id)sender {
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:kTRServicePathNodeCreate usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        loader.additionalHTTPHeaders = [NSDictionary dictionaryWithKeysAndObjects:@"Content-Type", @"application/x-www-form-urlencoded", nil];
        loader.delegate = self;
        loader.params = [NSDictionary dictionaryWithKeysAndObjects:
                         @"type", @"reward",
                         @"uid", [[TRUser activeUser] uid],
                         @"title", [self.rewardTextField text],
                         @"field_reward_recipient_email[und][0][value]", [self.emailField text],
                         @"language", kTRDrupalLanguageUndefined,
                         nil];
    }];
    [self.rewardTextField resignFirstResponder];
    [self.emailField resignFirstResponder];
}

- (void)onClickAddContact:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}

- (void)onHitDoneKey:(id)sender {
    
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"%s", __FUNCTION__);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
    NSLog(@"%s", __FUNCTION__);
    [[NSNotificationCenter defaultCenter] postNotificationName:kTRNotificationDataRefresh object:nil];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    if (property != kABPersonEmailProperty) {
        return NO;
    }
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%d", property);
    ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (ABMultiValueGetCount(emails) > 0) {
        NSUInteger propertyIndex = ABMultiValueGetIndexForIdentifier(emails, identifier);
        NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, propertyIndex);
        self.emailField.text = email;
    }
    [self dismissModalViewControllerAnimated:YES];
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    NSLog(@"%s", __FUNCTION__);
    [self dismissModalViewControllerAnimated:YES];
}

@end
