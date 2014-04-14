//
//  VendiViewController.m
//  VendiMobile
//
//  Created by APG on 06/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import "VendiViewController.h"

@interface VendiViewController ()
- (void) startLocationMonitoring;
- (void) handleLocationServicesFail;
@property (strong, nonatomic) CLLocationManager *cllmanager;
@end

@implementation VendiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ios-linen.jpg"] forBarMetrics:UIBarMetricsDefault];
    
  
}
 - (void)viewDidAppear:(BOOL)animated
{
    [self startLocationMonitoring];
    NSLog(@"view did appear");
}


- (void) handleLocationServicesFail {
    NSLog(@"handle location services fail");
    _landingPageText.text = @"To enable location services go to Settings > Privacy > Location Services, and enable the service for Vendi. \n Press 'Retry' to retrieve yor location.";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                   message:@"Locations services need to be enabled in order to use this app"
                                                  delegate:self
                                         cancelButtonTitle:@"Dismiss"
                                         otherButtonTitles: nil];
    [alert show];
    _startButton.hidden  = YES;
    _activityIndicator.hidden = YES;
    _retryButton.hidden = NO;
    
}

- (IBAction)retry:(UIButton *)sender {
    [self startLocationMonitoring];
}


- (void) startLocationMonitoring {
    NSLog(@"start locaiton monitoring");
    _startButton.hidden = YES;
    _retryButton.hidden = YES;
    _landingPageText.text = @"One moment, we are checking your location.";
    _activityIndicator.hidden = NO;
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self handleLocationServicesFail];
        return;
    }
    
    _cllmanager = [[CLLocationManager alloc] init];
    _cllmanager.delegate = self;
    CLLocationCoordinate2D chezPanisseCoordinate = CLLocationCoordinate2DMake(37.882157, -122.270639);
    CLLocationDistance radius = 3060;
    CLCircularRegion *region = [[CLCircularRegion alloc]initWithCenter:chezPanisseCoordinate radius:radius identifier:@"berkeley"];
    
    if(![CLLocationManager isMonitoringAvailableForClass: region.class]) {
        _landingPageText.text = @"I am sorry, this app requires region monitoring features which are unavailable on this device.";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"warning" message:@"This app requires region monitoring features which are unavailable on this device." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
        return;
    }

    [_cllmanager startMonitoringForRegion:region];
    [_cllmanager requestStateForRegion:region];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"did change autorization");
    if (status == kCLAuthorizationStatusDenied) {
        [self handleLocationServicesFail];
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        //[self startLocationMonitoring];
    }
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    NSLog(@"error%@",error);
    [manager stopUpdatingLocation];
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"please check your network connection or that you are not in airplane mode"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                            message:@"You need to enable location services to use this app"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Unknown network error"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}



- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    NSLog(@"didDetermineState");
    _activityIndicator.hidden = YES;
    if (state == CLRegionStateInside) {
        _retryButton.hidden = YES;
        _startButton.hidden = NO;
        _landingPageText.text = @"Vendi sells your stuff so you don’t have to.\n\nYou approve the price. Vendi picks up the item from your front door.";
    } else if (state == CLRegionStateOutside) {
        _retryButton.hidden = NO;
        _startButton.hidden = YES;
        _landingPageText.text = @"You need to be near Berkeley to use this app.";
    } else {
        _retryButton.hidden = NO;
        _startButton.hidden = YES;
        _landingPageText.text = @"We are unable to retrieve your location. Please check your network connection or that you are not in airplane mode.";
    }
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    _retryButton.hidden = YES;
    _startButton.hidden = NO;
    _landingPageText.text = @"Vendi sells your stuff so you don’t have to.\nYou approve the price. Vendi picks up the item from your front door.";
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Great" message:@"You are back in the region in which this app works." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"warning" message:@"You are exiting the region in which this app works. Go back" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
