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
	NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:4];
	int point = 0;
	for (float i = 0.00125; i > -0.00375; i -= 0.00250) {
		for (float j = 0.00125; j > -0.00375; j -= 0.00250) {
			points[point] = [[MKPointAnnotation alloc] init];
			[points[point++] setCoordinate:CLLocationCoordinate2DMake([[_locationManager location] coordinate].latitude + i, [[_locationManager location] coordinate].longitude + j)];
		}
	}
	[_mapView addAnnotations:points];
	/*
	for (int i = 0; i < 4; ++i) {
		points[i] = [[MKPointAnnotation alloc] init];
		switch (i) {
			case 0:
				[points[i] setTitle:@"North"];
				[points[i] setCoordinate:CLLocationCoordinate2DMake([[_locationManager location] coordinate].latitude + 0.00125, [[_locationManager location] coordinate].longitude)];
				break;
			case 1:
				[points[i] setTitle:@"East"];
				[points[i] setCoordinate:CLLocationCoordinate2DMake([[_locationManager location] coordinate].latitude, [[_locationManager location] coordinate].longitude + 0.00125)];
				break;
			case 2:
				[points[i] setTitle:@"South"];
				[points[i] setCoordinate:CLLocationCoordinate2DMake([[_locationManager location] coordinate].latitude - 0.00125, [[_locationManager location] coordinate].longitude)];
				break;
			case 3:
				[points[i] setTitle:@"West"];
				[points[i] setCoordinate:CLLocationCoordinate2DMake([[_locationManager location] coordinate].latitude, [[_locationManager location] coordinate].longitude - 0.00125)];
				break;
			default:
				break;
		}
		[_mapView addAnnotations:points];
	}
	*/
	[_longPress addTarget:self action:@selector(longPressed:)];
}

- (void)longPressed:(UILongPressGestureRecognizer *)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		NSLog(@"uh oh");
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOut:(id)sender {
	[PFUser logOut];
	[self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
