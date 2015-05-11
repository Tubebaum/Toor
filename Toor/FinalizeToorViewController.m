//
//  FinalizeToorViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/6/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "FinalizeToorViewController.h"

@interface FinalizeToorViewController ()

@end

@implementation FinalizeToorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_nameField	setDelegate:self];
	[_descriptionField setDelegate:self];
	[_nameField becomeFirstResponder];
}

- (IBAction)doneToor:(id)sender {
	_toor[@"name"] = [_nameField text];
	_toor[@"description"] = [_descriptionField text];
	[_toor saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			[self.navigationController popToRootViewControllerAnimated:YES];
		} else {
			NSLog(@"%@", [error description]);
		}
	}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _nameField) {
		[_descriptionField becomeFirstResponder];
	} else if (textField == _descriptionField) {
		[self doneToor:nil];
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
