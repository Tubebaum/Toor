//
//  UserViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_table setAllowsMultipleSelectionDuringEditing:NO];
	NSString *user = [[PFUser currentUser] username];
	[_userNav setTitle:user];
	_toors = [[NSMutableArray alloc] init];
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self refreshTable];
}

- (IBAction)signOut:(UIButton *)sender {
	[PFUser logOut];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) refreshTable {
	NSString *user = [[PFUser currentUser] username];
	PFQuery *query = [PFQuery queryWithClassName:@"Toor"];
	[query whereKey:@"user" equalTo:user];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		_toors = [[NSMutableArray alloc] initWithArray:objects];
		NSLog(@"Loaded");
		[_table reloadData];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_toors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toorCell" forIndexPath:indexPath];
	PFObject *toor = _toors[indexPath.row];
	cell.textLabel.text = toor[@"name"];
	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		PFObject *toor = _toors[indexPath.row];
		NSLog(@"%@", toor[@"name"]);
		[_toors removeObject:toor];
		[toor deleteInBackgroundWithBlock:^(BOOL success, NSError * error) {
			if (success) {
				[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			}
		}];

	}
}

@end
