//
//  EditStopTableViewController.h
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AddMediaViewController.h"
#import "FinalizeStopViewController.h"

@interface EditStopTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) PFObject *stop;
@property (nonatomic) Boolean completed;
@property (nonatomic) int previousCount;

@end
