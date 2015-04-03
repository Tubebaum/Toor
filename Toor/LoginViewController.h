//
//  LoginViewController.h
//  Toor
//
//  Created by Thomas Huzij on 4/2/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *signup;
@property (strong, nonatomic) CLLocationManager *locationManager;
- (void)performSignup;
@end
