//
//  ThankYouViewController.m
//  Vendi
//
//  Created by APG on 07/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import "ThankYouViewController.h"

@interface ThankYouViewController ()

@end

@implementation ThankYouViewController

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
    [NSTimer scheduledTimerWithTimeInterval:8.0
                                     target:self
                                   selector:@selector(goToHome)
                                   userInfo:nil
                                    repeats:NO];
}

- (void) goToHome {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"firstView"];
    [self.navigationController pushViewController:vc animated:YES];
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
