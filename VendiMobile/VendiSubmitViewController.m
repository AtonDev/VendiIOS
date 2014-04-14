//
//  VendiSubmitViewController.m
//  VendiMobile
//
//  Created by APG on 06/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import "VendiSubmitViewController.h"

@interface VendiSubmitViewController ()
@property (strong, nonatomic) IBOutlet UITextField *ownerName;
@property (strong, nonatomic) IBOutlet UITextField *ownerEmail;
@property (strong) NSMutableData * data;
- (BOOL) sendItemDataToVendi;
- (BOOL) hasValidEmail: (NSString *)email;
@end

@implementation VendiSubmitViewController

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
    _ownerName.delegate = self;
    _ownerEmail.delegate = self;
    _data = [[NSMutableData alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)submitForm:(UIButton *)sender {
    if (_ownerName.text && _ownerName.text.length > 0 && [self hasValidEmail: _ownerEmail.text]) {
        [self sendItemDataToVendi];
    } else {
        NSString *message;
        if ([self hasValidEmail: _ownerEmail.text])
            message = @"Please don't leave the name field empty.";
        else
            message = @"Please enter a valid email adress. It is important that we are able to contact you.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles: nil];
        [alert show];
            
    }
    
}

- (BOOL) hasValidEmail: (NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return email && [emailTest evaluateWithObject:email];
}

- (BOOL) sendItemDataToVendi {
    NSDictionary *params = @{
                             @"name" : _ownerName.text,
                             @"email" : _ownerEmail.text,
                             @"title" : _itemTitle,
                             @"condition" : _itemCondition,
                             @"description" : _itemDescription
                             };
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"asdf9876adf9876xvb9876a89d9a8f7a6";
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    int imgCounter = 0;
    for (UIImage *image in _capturedImages) {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"images[image%d]\"; filename=\"image%d.jpg\"\r\n", imgCounter, imgCounter] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            imgCounter += 1;
        }
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *bodyLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    
    NSMutableURLRequest *complexRequest = [[NSMutableURLRequest alloc] init];
    [complexRequest setURL:[NSURL URLWithString:@"https://vendistaging.herokuapp.com/api/add_item"]];
    [complexRequest setHTTPMethod:@"POST"];
    [complexRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [complexRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [complexRequest setHTTPBody:body];
    
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:complexRequest delegate:self];
    [connection start];
    return YES;
}

#pragma mark - NSURLConnectionData Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"did receive response");
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self performSegueWithIdentifier: @"toThankYou" sender: self];
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(responseText);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"An error occured. Make sure that the internet connection is online and try again"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    NSLog(error.description);
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
