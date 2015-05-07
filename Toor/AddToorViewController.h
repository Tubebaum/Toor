//
//  AddToorViewController.h
//  Toor
//
//  Created by Thomas Huzij on 5/5/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FinalizeToorViewController.h"
#import "EditStopTableViewController.h"

@interface AddToorViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong ,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigation;
@property (strong, nonatomic) NSMutableArray *stops;
@property (strong, nonatomic) NSMutableDictionary *stopDict;
@property (strong, nonatomic) MKPointAnnotation *triggeredPin;

@end
