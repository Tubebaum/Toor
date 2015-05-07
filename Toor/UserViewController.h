//
//  UserViewController.h
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UINavigationItem *userNav;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSMutableArray *toors;

@end
