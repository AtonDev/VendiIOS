//
//  VendiViewController.h
//  VendiMobile
//
//  Created by APG on 06/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface VendiViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UITextView *landingPageText;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
