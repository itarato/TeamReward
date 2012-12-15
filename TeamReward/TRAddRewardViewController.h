//
//  TRAddRewardViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import "TRShareAddingRewardViewController.h"
#import "TRShareAddingRewardDelegate.h"

@interface TRAddRewardViewController : UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, TRShareAddingRewardDelegate, UITextViewDelegate, UIAlertViewDelegate> {
    
    TRShareAddingRewardViewController *shareViewController;
    
}

@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextView *rewardTextField;
@property (nonatomic, retain) IBOutlet UIButton *contactsButton;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;

- (IBAction)onClickSend:(id)sender;
- (IBAction)onClickAddContact:(id)sender;
- (IBAction)onHitDoneKey:(id)sender;

@end
