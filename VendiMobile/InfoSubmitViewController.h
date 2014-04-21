//
//  InfoSubmitViewController.h
//  VendiMobile
//
//  Created by APG on 04/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendiSubmitViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface InfoSubmitViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate>
@property (nonatomic) NSMutableArray *capturedImages;
@property CLLocation* location;
- (IBAction)lastStepButton:(UIButton *)sender;

@end
