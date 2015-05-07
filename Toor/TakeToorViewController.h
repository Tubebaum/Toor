//
//  TakeToorViewController.h
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewStopTableViewController.h"

@interface TakeToorViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property (strong ,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *triggeredPin;
@property (strong, nonatomic) PFObject *toor;
@property (strong, nonatomic) NSMutableDictionary *stops;
@property (strong, nonatomic) NSMutableArray *pointArray;

@end
