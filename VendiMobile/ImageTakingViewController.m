//
//  ImageTakingViewController.m
//  VendiMobile
//
//  Created by APG on 04/04/14.
//  Copyright (c) 2014 Vendi. All rights reserved.
//

#import "ImageTakingViewController.h"

@interface ImageTakingViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *imgCollectionView;
@property (strong, nonatomic) IBOutlet UITextView *photoDirections;
@property NSArray *directionsArray;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property  CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) CLLocationManager *cllmanager;

- (void)startLocationMonitoring;
@end

@implementation ImageTakingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-title.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.capturedImages == nil)
        self.capturedImages = [[NSMutableArray alloc]init];
    self.imgCollectionView.delegate = self;
    self.imgCollectionView.dataSource = self;
    [self.imgCollectionView reloadData];
    _directionsArray = [[NSArray alloc] initWithObjects: @"Take a photo of the side", @"Now of the barcode or tag or model number",  @"Take any other relevant photo", nil];
    _nextButton.hidden = YES;
    _takePhotoButton.hidden = NO;
    _photoDirections.text = [_directionsArray objectAtIndex:0];
    _cllmanager = [[CLLocationManager alloc]init];
    _cllmanager.delegate = self;
    [self startLocationMonitoring];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toInfoForm"]){
        InfoSubmitViewController *controller = (InfoSubmitViewController *)segue.destinationViewController;
        controller.capturedImages = self.capturedImages;
        controller.coordinate = self.coordinate;
    }
}


#pragma mark - Location Manager Events

- (void)startLocationMonitoring {
    [_cllmanager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * location = [locations lastObject];
    _coordinate = location.coordinate;
}

#pragma mark - Image Picker

- (IBAction)takePicture:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
 
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    [self.capturedImages addObject:img];
    [self.imgCollectionView reloadData];
    self.photoDirections.text = [_directionsArray objectAtIndex: MIN(_capturedImages.count, _directionsArray.count) - 1];
    if (_capturedImages.count >= 3)
        _nextButton.hidden = NO;
    if (_capturedImages.count >= 6)
        _takePhotoButton.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.capturedImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:100];
    itemImageView.image = [self.capturedImages objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
}
@end
