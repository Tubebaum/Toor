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
	_stopDict = [[NSMutableDictionary alloc] init];
	_triggeredPin = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (_triggeredPin) {
		PFObject *stop = [_stopDict objectForKey:[NSValue valueWithNonretainedObject:_triggeredPin]];
		if ([stop[@"name"] isEqualToString:@""]) {
			[_triggeredPin setTitle:[NSString stringWithFormat:@"Stop %d", [_stops count] - 1]];
		} else {
			[_triggeredPin setTitle:stop[@"name"]];
		}
		[_triggeredPin setSubtitle:stop[@"description"]];
		[_mapView removeAnnotation:_triggeredPin];
		[_mapView addAnnotation:_triggeredPin];
		[_mapView selectAnnotation:_triggeredPin animated:YES];
	}
}

- (void)longPressed:(UILongPressGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		[_navigation setPrompt:nil];
		CLLocationCoordinate2D location = [_mapView convertPoint:[sender locationInView:_mapView] toCoordinateFromView:_mapView];
		MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
		[point setTitle:[NSString stringWithFormat:@"Stop %d", [_stops count]]];
		[point setCoordinate:location];
		[_stops addObject:point];
		PFObject *stop = [PFObject objectWithClassName:@"Stop"];
		stop[@"name"] = @"";
		stop[@"description"] = @"";
		[_stopDict setObject:stop forKey:[NSValue valueWithNonretainedObject:point]];
		[_mapView addAnnotation:point];
		[_mapView selectAnnotation:point animated:YES];
	}
}

- (IBAction)toorDone:(UIBarButtonItem *)sender {
	if ([_stops count] == 0) {
		return;
	}
	PFObject *toor = [PFObject objectWithClassName:@"Toor"];
	toor[@"user"] = [[PFUser currentUser] username];
	PFGeoPoint *geopoint = nil;
	for (MKPointAnnotation *point in _stops) {
		PFObject *stop = [_stopDict objectForKey:[NSValue valueWithNonretainedObject:point]];
		stop[@"location"] = [PFGeoPoint geoPointWithLatitude:[point coordinate].latitude longitude:[point coordinate].longitude];
		if (geopoint == nil) {
			geopoint = stop[@"location"];
		}
		[toor addObject:stop forKey:@"stops"];
	}
	toor[@"location"] = [PFGeoPoint geoPointWithLatitude:[geopoint latitude] longitude:[geopoint longitude]];
	[self performSegueWithIdentifier:@"toorSegue" sender:toor];
}

- (void)editStop {
	PFObject *stop = [_stopDict objectForKey:[NSValue valueWithNonretainedObject:_triggeredPin]];
	[self performSegueWithIdentifier:@"stopSegue" sender:stop];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"toorSegue"]) {
		FinalizeToorViewController *finalize = [segue destinationViewController];
		[finalize setToor:sender];
	} else if ([[segue identifier] isEqualToString:@"stopSegue"]) {
		EditStopTableViewController *stop = [segue destinationViewController];
		[stop setStop:sender];
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
		_triggeredPin = annotation;
		[informationButton addTarget:self action:@selector(editStop) forControlEvents:UIControlEventTouchUpInside];
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
