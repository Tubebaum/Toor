//
//  MapViewController.h
//  Toor
//
//  Created by Thomas Huzij on 4/3/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
