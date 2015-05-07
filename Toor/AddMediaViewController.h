//
//  AddMediaViewController.h
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

@import AVFoundation;
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EditStopTableViewController.h"

@interface AddMediaViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UIView *preView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *capture;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDeviceInput *input;
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;

@end
