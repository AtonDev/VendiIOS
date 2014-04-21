//
//  ImageTakingViewController.h
//  VendiMobile
//
//  Created by APG on 04/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "InfoSubmitViewController.h"

@interface ImageTakingViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>
- (IBAction)takePicture:(UIButton *)sender;
@property (nonatomic) NSMutableArray *capturedImages;
@end
