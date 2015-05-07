//
//  AddToorViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/5/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "AddToorViewController.h"

@interface AddToorViewController ()

@end

@implementation AddToorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_mapView setDelegate:self];
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDelegate:self];
	[_mapView setRegion:MKCoordinateRegionMake([[_locationManager location] coordinate], MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
	[_longPress addTarget:self action:@selector(longPressed:)];
	[_mapView addGestureRecognizer:_longPress];
	_stops = [[NSMutableArray alloc] init];
}

- (void)longPressed:(UILongPressGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		[_navigation setPrompt:NULL];
		CLLocationCoordinate2D location = [_mapView convertPoint:[sender locationInView:_mapView] toCoordinateFromView:_mapView];
		MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
		[point setTitle:[NSString stringWithFormat:@"%f, %f", location.latitude, location.longitude]];
		[point setCoordinate:location];
		[_stops addObject:point];
		[_mapView addAnnotation:point];
	}
}

- (IBAction)toorDone:(UIBarButtonItem *)sender {
	if ([_stops count] == 0) {
		return;
	}
	PFObject *toor = [PFObject objectWithClassName:@"Toor"];
	toor[@"user"] = [[PFUser currentUser] username];
	for (MKPointAnnotation *point in _stops) {
		PFObject *stop = [PFObject objectWithClassName:@"Stop"];
		stop[@"location"] = [PFGeoPoint geoPointWithLatitude:[point coordinate].latitude longitude:[point coordinate].longitude];
		[toor addObject:stop forKey:@"stops"];
	}
	PFGeoPoint *geopoint = toor[@"stops"][0][@"location"];
	toor[@"location"] = [PFGeoPoint geoPointWithLatitude:[geopoint latitude] longitude:[geopoint longitude]];
	[self performSegueWithIdentifier:@"toorSegue" sender:toor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"toorSegue"]) {
		FinalizeToorViewController *finalize = segue.destinationViewController;
		[finalize setToor:sender];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
	if (!annotationView) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
		[annotationView setAnimatesDrop:YES];
		[annotationView setCanShowCallout:YES];
		UIButton *informationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		[informationButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
		[annotationView setRightCalloutAccessoryView:informationButton];
	} else {
		[annotationView setAnnotation:annotation];
	}
	return annotationView;
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
