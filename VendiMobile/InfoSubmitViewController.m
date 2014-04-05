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
@property (strong, nonatomic) IBOutlet UITextField *itemDescription;
@property (strong) NSMutableData * data;

- (BOOL) sendItemDataToVendi;
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
    _ownerName.delegate = self;
    _ownerEmail.delegate = self;
    _itemTitle.delegate = self;
    _itemCondition.delegate = self;
    _itemDescription.delegate = self;
    _data = [[NSMutableData alloc]init];

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
    if ([self sendItemDataToVendi]) {
        //do something
    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong." delegate:self cancelButtonTitle:@"dismiss" otherButtonTitles:nil];
        [theAlert show];
    }

}


- (BOOL) sendItemDataToVendi {
    NSDictionary *params = @{
                             @"name" : _ownerName.text,
                             @"email" : _ownerEmail.text,
                             @"title" : _itemTitle.text,
                             @"condition" : _itemCondition.text,
                             @"description" : _itemDescription.text
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
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [body length]];
    
    NSMutableURLRequest *complexRequest = [[NSMutableURLRequest alloc] init];
    [complexRequest setURL:[NSURL URLWithString:@"https://vendistaging.herokuapp.com/api/add_image"]];
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
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(responseText);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(error.description);
}
@end
