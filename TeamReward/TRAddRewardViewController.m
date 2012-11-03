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
#import <QuartzCore/QuartzCore.h>

@interface TRAddRewardViewController ()

@end

@implementation TRAddRewardViewController

@synthesize rewardTextField;
@synthesize emailField;
@synthesize sendButton;
@synthesize contactsButton;

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
    
    UIImage *buttonImg = [UIImage imageNamed:@"btn.png"];
    UIImage *buttonBgr = [buttonImg stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self.sendButton setBackgroundImage:buttonBgr forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)onHitDoneKey:(id)sender {}

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
    
    if (self->shareViewController == nil) {
        self->shareViewController = [[TRShareAddingRewardViewController alloc] initWithNibName:@"TRShareAddingRewardViewController" bundle:nil];
    }
    
    [self presentModalViewController:self->shareViewController animated:YES];
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

#pragma mark - 
#pragma mark TRShareAddingRewardDelegate

- (void)shareAddingRewardDidHitFacebook {
    
}

- (void)shareAddingRewardDidHitTwitter {
    
}

@end
