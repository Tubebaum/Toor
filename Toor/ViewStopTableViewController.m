//
//  ViewStopTableViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "ViewStopTableViewController.h"

@interface ViewStopTableViewController ()

@end

@implementation ViewStopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[_navItem setTitle:_stop[@"name"]];
	[_table setRowHeight:([_table frame].size.height - [[[self tabBarController] tabBar] frame].size.height - [[[self navigationController] navigationBar] frame].size.height)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_table reloadData];
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

@end
