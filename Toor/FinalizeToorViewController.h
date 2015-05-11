//
//  FinalizeToorViewController.h
//  Toor
//
//  Created by Thomas Huzij on 5/6/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FinalizeToorViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) PFObject *toor;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionField;

@end
