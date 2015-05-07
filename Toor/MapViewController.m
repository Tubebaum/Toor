//
//  MapViewController.m
//  Toor
//
//  Created by Thomas Huzij on 4/3/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_mapView setDelegate:self];
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDelegate:self];
	[_mapView setRegion:MKCoordinateRegionMake([[_locationManager location] coordinate], MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
	_toors = [[NSMutableDictionary alloc] init];
	_triggeredPin = nil;
	[self refreshToors:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[self refreshToors:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshToors:(id)sender {
	NSMutableArray *points = [[NSMutableArray alloc] init];
	PFQuery *query = [PFQuery queryWithClassName:@"Toor"];
	[query whereKey:@"location" nearGeoPoint:[PFGeoPoint geoPointWithLocation:[_locationManager location]]];
	[query setLimit:10];
	[query findObjectsInBackgroundWithBlock:^(NSArray *toors, NSError *error) {
		for (PFObject *toor in toors) {
			MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
			[point setTitle:toor[@"name"]];
			[point setSubtitle:toor[@"description"]];
			PFGeoPoint *geopoint = toor[@"location"];
			[point setCoordinate: CLLocationCoordinate2DMake([geopoint latitude], [geopoint longitude])];
			[points addObject:point];
			[_toors setObject:toor forKey:[NSValue valueWithNonretainedObject:point]];
		}
		[_mapView removeAnnotations:[_mapView annotations]];
		[_mapView addAnnotations:points];
	}];
}

- (void)takeToor {
	PFObject *toor = [_toors objectForKey:[NSValue valueWithNonretainedObject:_triggeredPin]];
	[self performSegueWithIdentifier:@"takeSegue" sender:toor];
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
		[informationButton addTarget:self action:@selector(takeToor) forControlEvents:UIControlEventTouchUpInside];
		[annotationView setRightCalloutAccessoryView:informationButton];
	} else {
		[annotationView setAnnotation:annotation];
	}
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	_triggeredPin = [view annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"takeSegue"]) {
		TakeToorViewController *take = [segue destinationViewController];
		[take setToor:sender];
	}
}
@end
