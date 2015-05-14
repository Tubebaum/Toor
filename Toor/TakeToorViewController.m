//
//  TakeToorViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "TakeToorViewController.h"

@interface TakeToorViewController ()

@end

@implementation TakeToorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[_mapView setDelegate:self];
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDelegate:self];
	_stops = [[NSMutableDictionary alloc] init];
	_pointArray = [[NSMutableArray alloc] init];
	[_navItem setTitle:_toor[@"name"]];
	_triggeredPin = nil;
	PFGeoPoint *centerpoint = _toor[@"location"];
	[_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([centerpoint latitude], [centerpoint longitude]), MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
	NSMutableArray *points = [[NSMutableArray alloc] init];
	for (PFObject *stop in _toor[@"stops"]) {
		[stop fetchIfNeeded];
		MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
		[point setTitle:stop[@"name"]];
		[point setSubtitle:stop[@"description"]];
		PFGeoPoint *geopoint = stop[@"location"];
		[point setCoordinate: CLLocationCoordinate2DMake([geopoint latitude], [geopoint longitude])];
		if (_triggeredPin == nil) {
			_triggeredPin = point;
		}
		[points addObject:point];
		[_pointArray addObject:point];
		[_stops setObject:stop forKey:[NSValue valueWithNonretainedObject:point]];
		[_mapView addAnnotations:points];
	}
	[_mapView selectAnnotation:_triggeredPin animated:YES];
}

- (IBAction)nextStop:(UIBarButtonItem *)sender {
	int index = [self getNextStop];
	if (index == -1) {
		[_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextStop:)] animated:YES];
		[[self navigationController] popViewControllerAnimated:YES];
	} else if (index + 1 == [_toor[@"stops"] count]) {
		[_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextStop:)] animated:YES];
		_triggeredPin = _pointArray[index];
	} else {
		[_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextStop:)] animated:YES];
		_triggeredPin = _pointArray[index];
	}
	[_mapView selectAnnotation:_triggeredPin animated:YES];
}

- (int)getNextStop {
	int index = -1;
	PFObject *currentStop = [_stops objectForKey:[NSValue valueWithNonretainedObject:_triggeredPin]];
	for (int i = 0; i < [_toor[@"stops"] count]; ++i) {
		if (currentStop == _toor[@"stops"][i]) {
			if (i + 1 == [_toor[@"stops"] count]) {
				break;
			} else {
				index = i + 1;
				break;
			}
		}
	}
	return index;
}

- (void)viewStop {
	PFObject *stop = [_stops objectForKey:[NSValue valueWithNonretainedObject:_triggeredPin]];
	[self performSegueWithIdentifier:@"viewSegue" sender:stop];
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
		[informationButton addTarget:self action:@selector(viewStop) forControlEvents:UIControlEventTouchUpInside];
		[annotationView setRightCalloutAccessoryView:informationButton];
	} else {
		[annotationView setAnnotation:annotation];
	}
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	_triggeredPin = [view annotation];
	int index = [self getNextStop];
	if (index == -1) {
		[_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(nextStop:)] animated:YES];
	} else if (index == 1) {
		[_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(nextStop:)] animated:YES];
	} else {
		[_navItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(nextStop:)] animated:YES];
	}
	[self getDirections];
	double latitudeZoom = fabs([[_locationManager location] coordinate].latitude - [_triggeredPin coordinate].latitude);
	double longitudeZoom = fabs([[_locationManager location] coordinate].longitude - [_triggeredPin coordinate].longitude);
	[_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(([[_locationManager location] coordinate].latitude + [_triggeredPin coordinate].latitude)/2, ([[_locationManager location] coordinate].longitude + [_triggeredPin coordinate].longitude)/2), MKCoordinateSpanMake(1.25 * latitudeZoom, 1.25 * longitudeZoom)) animated:YES];
}

- (void)getDirections {
	MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
	[directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
	[directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[_triggeredPin coordinate] addressDictionary:nil]]];
	[directionsRequest setTransportType:MKDirectionsTransportTypeWalking];
	MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
	[directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *directionsResponse, NSError *error) {
		[_mapView removeOverlays:[_mapView overlays]];
		for (MKRoute *route in [directionsResponse routes]) {
			[_mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
		}
	}];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		MKPolylineRenderer *polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
		[polylineRenderer setLineWidth:3.0];
		[polylineRenderer setStrokeColor:[UIColor greenColor]];
		return polylineRenderer;
	}
	return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"viewSegue"]) {
		ViewStopTableViewController *viewStop = [segue destinationViewController];
		[viewStop setStop:sender];
	}
}

@end
