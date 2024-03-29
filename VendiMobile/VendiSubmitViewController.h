//
//  VendiSubmitViewController.h
//  VendiMobile
//
//  Created by APG on 06/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VendiSubmitViewController : UIViewController <NSURLConnectionDataDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) NSString *itemTitle;
@property (strong, nonatomic) NSString *itemCondition;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSMutableArray *capturedImages;
- (IBAction)submitForm:(UIButton *)sender;

@end
