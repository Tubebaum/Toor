//
//  LoginViewController.m
//  Toor
//
//  Created by Thomas Huzij on 4/2/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_username setDelegate:self];
	[_password setDelegate:self];
	[_email setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[_username setText:nil];
	[_password setText:nil];
	[_email setText:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	if ([PFUser currentUser]) {
		[self performSegueWithIdentifier:@"signupSegue" sender:nil];
	} else {
		[_username becomeFirstResponder];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _username) {
		[_password becomeFirstResponder];
	} else if (textField == _password) {
		[_email becomeFirstResponder];
	} else if (textField == _email) {
		[self performSignup];
	}
	return YES;
}

- (void)performSignup {
	if (![[_username text] length]) {
		return;
	} else if (![[_password text] length]) {
		return;
	} else if (![[_email text] length]) {
		return;
	}
	PFUser *user = [PFUser user];
	[user setUsername:[_username text]];
	[user setPassword:[_password text]];
	[user setEmail:[_email text]];
	[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			[self performSegueWithIdentifier:@"signupSegue" sender:nil];
		} else {
			NSString *errorString = [error userInfo][@"error"];
			NSLog(@"%@", errorString);
		}
	}];
}

- (IBAction)signupTouchUp:(id)sender {
	[self performSignup];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
