//
//  FinalizeStopViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "FinalizeStopViewController.h"

@interface FinalizeStopViewController ()

@end

@implementation FinalizeStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	if (![((NSString *)_stop[@"name"]) isEqualToString:@""]) {
		[_nameField setText:_stop[@"name"]];
	}
	if (![_stop[@"description"] isEqualToString:@""]) {
		[_descriptionField setText:_stop[@"description"]];
	}
	[_nameField	setDelegate:self];
	[_descriptionField setDelegate:self];
	[_nameField becomeFirstResponder];
}

- (IBAction)doneToor:(id)sender {
	_stop[@"name"] = [_nameField text];
	_stop[@"description"] = [_descriptionField text];
	[[self navigationController] popViewControllerAnimated:NO];
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
