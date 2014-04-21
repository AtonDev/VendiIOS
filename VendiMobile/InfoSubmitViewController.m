//
//  InfoSubmitViewController.m
//  VendiMobile
//
//  Created by APG on 04/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import "InfoSubmitViewController.h"


@interface InfoSubmitViewController ()
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

    _itemTitle.delegate = self;
    _itemCondition.delegate = self;
    _itemDescription.delegate = self;
    _itemDescription.clipsToBounds = YES;
    _itemDescription.layer.cornerRadius = 10.0f;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toLastStep"]){
        VendiSubmitViewController *controller = (VendiSubmitViewController *)segue.destinationViewController;
        controller.capturedImages = self.capturedImages;
        controller.itemTitle = self.itemTitle.text;
        controller.itemDescription = self.itemDescription.text;
        controller.itemCondition = self.itemCondition.text;
        controller.coordinate = self.coordinate;
    }
}

- (IBAction)lastStepButton:(UIButton *)sender{
    if ([self inputFieldsNotEmpty]) {
        [self performSegueWithIdentifier:@"toLastStep" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please don't leave any of the input fields empty."
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL) inputFieldsNotEmpty {
    return _itemTitle.text && _itemTitle.text.length > 0 &&
    _itemCondition.text && _itemCondition.text.length > 0 &&
    _itemDescription.text && _itemDescription.text.length > 0;
}





@end













