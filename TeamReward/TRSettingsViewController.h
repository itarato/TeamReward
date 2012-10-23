//
//  TRSettingsViewController.h
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRSettingsViewController : UIViewController <UITextFieldDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;

- (void)synchronizeData;
- (IBAction)onClickSave:(id)sender;
- (IBAction)onClickLogout:(id)sender;
- (IBAction)onHitDoneKey:(id)sender;

@end
