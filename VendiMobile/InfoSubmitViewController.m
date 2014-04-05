//
//  InfoSubmitViewController.m
//  VendiMobile
//
//  Created by APG on 04/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import "InfoSubmitViewController.h"

@interface InfoSubmitViewController ()
@property (strong, nonatomic) IBOutlet UITextField *ownerName;
@property (strong, nonatomic) IBOutlet UITextField *ownerEmail;
@property (strong, nonatomic) IBOutlet UITextField *itemTitle;
@property (strong, nonatomic) IBOutlet UITextField *itemCondition;
@property (strong, nonatomic) IBOutlet UITextView *itemDescription;

@end

@implementation InfoSubmitViewController

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

- (IBAction)submitInfo:(UIButton *)sender {
    if ([self isValidForm]){
        
    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"No text box should be empty"
                                                          delegate:self
                                                 cancelButtonTitle:@"dismiss"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}

- (BOOL) isValidForm {
    return !_ownerName && !_ownerEmail && !_itemTitle && !_itemCondition && !_itemDescription;
}
@end
