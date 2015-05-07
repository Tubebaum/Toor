//
//  EditStopTableViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "EditStopTableViewController.h"

@interface EditStopTableViewController ()

@end

@implementation EditStopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_completed = NO;
	_previousCount = 0;
	[_table setRowHeight:400];
	[_table setAllowsMultipleSelectionDuringEditing:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	if (_completed) {
		[[self navigationController] popViewControllerAnimated:NO];
	}
	[_table reloadData];
}

- (IBAction)addMedia:(id)sender {
	[self performSegueWithIdentifier:@"mediaSegue" sender:_stop];
}

- (IBAction)finalizeStop:(id)sender {
	[self performSegueWithIdentifier:@"finalizeSegue" sender:_stop];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"mediaSegue"]) {
		AddMediaViewController *addMedia = [segue destinationViewController];
		[addMedia setStop:sender];
	} else if ([[segue identifier] isEqualToString:@"finalizeSegue"]) {
		_completed = YES;
		FinalizeStopViewController *finalizeStop = [segue destinationViewController];
		[finalizeStop setStop:sender];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_stop[@"media"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
	UIImageView *imageView = [[UIImageView alloc] init];
	[imageView setFrame:[[cell contentView] bounds]];
	PFFile *file = _stop[@"media"][indexPath.row];
	[imageView setImage:[UIImage imageWithData:[file getData]]];
	[[cell contentView] addSubview:imageView];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		[_stop removeObject:_stop[@"media"][indexPath.row] forKey:@"media"];
		[_stop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}];
    }
}

@end
