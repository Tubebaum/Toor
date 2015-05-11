//
//  AddMediaViewController.m
//  Toor
//
//  Created by Thomas Huzij on 5/7/15.
//  Copyright (c) 2015 Tubebaum. All rights reserved.
//

#import "AddMediaViewController.h"

@interface AddMediaViewController ()

@end

@implementation AddMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[_segment setSelectedSegmentIndex:1];
	[self segmented:_segment];
}

- (IBAction)segmented:(id)sender {
	UISegmentedControl *segment = sender;
	_session = [[AVCaptureSession alloc] init];
	switch ([segment selectedSegmentIndex]) {
		case 0:
			_input = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
			if ([_session canAddInput:_input]) {
				[_session addInput:_input];
				AVCaptureAudioDataOutput *output = [[AVCaptureAudioDataOutput alloc] init];
				if ([_session canAddOutput:output]) {
					[_session addOutput:output];
				} else {
					NSLog(@"Can't add audio output");
				}
			} else {
				NSLog(@"Can't add microphone");
			}
			break;
		case 1:
			if ([_session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
				[_session setSessionPreset:AVCaptureSessionPresetPhoto];
				AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
				[captureVideoPreviewLayer setFrame:[_preView bounds]];
				[[_preView layer] addSublayer:captureVideoPreviewLayer];
				AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
				_input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
				if ([_session canAddInput:_input]) {
					[_session addInput:_input];
					_imageOutput = [[AVCaptureStillImageOutput alloc] init];
					[_imageOutput setOutputSettings:@{AVVideoCodecKey: AVVideoCodecJPEG}];
					if ([_session canAddOutput:_imageOutput]) {
						[_session addOutput:_imageOutput];
						[_session startRunning];
					}
				}
			}
			break;
		case 2:
			if ([_session canSetSessionPreset:AVCaptureSessionPresetLow]) {
				[_session setSessionPreset:AVCaptureSessionPresetLow];
				_input = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
				if ([_session canAddInput:_input]) {
					[_session addInput:_input];
					AVCaptureMovieFileOutput *output = [[AVCaptureMovieFileOutput alloc] init];
					[output setMaxRecordedFileSize:(5 * pow(10.0, 20.0))];
					if ([_session canAddOutput:output]) {
						[_session addOutput:output];
					} else {
						NSLog(@"Can't add video output");
					}
				} else {
					NSLog(@"Can't add camera");
				}
			} else {
				NSLog(@"Can't set video preset");
			}
			break;
		default:
			break;
	}
}

- (IBAction)captureButton:(id)sender {
	AVCaptureConnection *connection = nil;
	switch ([_segment selectedSegmentIndex]) {
		case 0: {
			break;
		}
		case 1: {
			for (AVCaptureConnection *captureConnection in [_imageOutput connections]) {
				for (AVCaptureInputPort *port in [captureConnection inputPorts]) {
					if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
						connection = captureConnection;
						break;
					}
				}
				if (connection) {
					break;
				}
			}
			[_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef buffer, NSError *error) {
				[_session stopRunning];
				NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buffer];
				PFFile *file = [PFFile fileWithData:data];
				[_stop addObject:file forKey:@"media"];
				[_stop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
					[[self navigationController] popViewControllerAnimated:NO];
				}];
			}];
			break;
		}
		default: {
			break;
		}
	}
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
