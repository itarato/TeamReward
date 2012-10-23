//
//  TRAddRewardViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>

@interface TRAddRewardViewController : UIViewController <RKObjectLoaderDelegate, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UITextField *emailField;
@property (nonatomic, retain) IBOutlet UITextField *rewardTextField;

- (IBAction)onClickSend:(id)sender;
- (IBAction)onClickAddContact:(id)sender;
- (IBAction)onHitDoneKey:(id)sender;

@end
