//
//  InfoSubmitViewController.h
//  VendiMobile
//
//  Created by APG on 04/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoSubmitViewController : UIViewController
@property (nonatomic) NSMutableArray *capturedImages;
- (IBAction)submitInfo:(UIButton *)sender;
@end
