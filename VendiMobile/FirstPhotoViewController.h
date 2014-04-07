//
//  FirstPhotoViewController.h
//  VendiMobile
//
//  Created by APG on 06/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTakingViewController.h"

@interface FirstPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)takeFirstPic:(UIButton *)sender;

@end
