//
//  PABarCodeViewController.m
//  Library
//
//  Created by 薛 迎松 on 14/11/2.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PABarCodeViewController.h"
#import "PALibraryDAL.h"

@interface PABarCodeViewController ()
<AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate>
//iOS7 system barcode service
@property (nonatomic, assign) AVCaptureDevice *captureDevice;
@property (nonatomic, assign) UIView *videoPreviewView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *scanedResultArr;

@property (atomic, assign) BOOL isReading;

@end

@implementation PABarCodeViewController

- (void)dealloc
{
    [self stopReading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scanedResultArr = [NSMutableArray new];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UIBarButtonItem *flashBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(switchFlash:)];
    self.navigationItem.rightBarButtonItem = flashBarButton;
    
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectZero];
    videoView.backgroundColor = [UIColor blueColor];
    videoView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:videoView];
    self.videoPreviewView = videoView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(videoView, tableView);
    NSDictionary *metrics = @{@"Padding":@0};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Padding-[videoView]-5-[tableView]-Padding-|" options:0 metrics:metrics views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Padding-[videoView]-Padding-|" options:0 metrics:metrics views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Padding-[tableView]-Padding-|" options:0 metrics:metrics views:viewDict]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:videoView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:videoView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    
    [self loadBeepSound];
//    [self startReading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startReading];
}

- (void)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Actions
- (void)switchFlash:(id)sender
{
    if (self.captureDevice && self.captureDevice.hasTorch && self.captureDevice.isTorchAvailable)
    {
        [self.captureDevice lockForConfiguration:nil];
        self.captureDevice.torchMode = self.captureDevice.torchMode == AVCaptureTorchModeOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
        [self.captureDevice unlockForConfiguration];
    }
}

#pragma mark iOS7 or Higher AVCapture
- (BOOL)startReading
{
    if (self.captureDevice) {
        return YES;
    }
    
    NSError *error = nil;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    self.captureDevice = captureDevice;
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:input];
    self.captureSession = captureSession;
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("barcodeQuene", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    NSArray *supportedMetaData = captureMetadataOutput.availableMetadataObjectTypes;
    captureMetadataOutput.metadataObjectTypes = [NSArray arrayWithArray:supportedMetaData];
//    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeUPCECode, nil]];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayer setFrame:self.videoPreviewView.layer.bounds];
    self.videoPreviewView.layer.masksToBounds = YES;
    [self.videoPreviewView.layer addSublayer:previewLayer];
    self.videoPreviewLayer = previewLayer;
    
    [self.captureSession startRunning];
    self.isReading = YES;
    
    return YES;
}

-(void)stopReading
{
    self.isReading = NO;
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.videoPreviewLayer removeFromSuperlayer];
    self.videoPreviewLayer = nil;
}

-(void)loadBeepSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"scanner" ofType:@"wav"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    self.audioPlayer = audioPlayer;
    
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [self.audioPlayer prepareToPlay];
    }
}

#pragma mark AVCapture Delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!self.isReading) {
        return;
    }
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        NSString *metaType = [metadataObj type];
        NSArray *filterArr =  @[AVMetadataObjectTypeEAN13Code];
        if ([filterArr containsObject:metaType])
        {
            NSString *info = [NSString stringWithFormat:@"%@ Code:%@",metaType,[metadataObj stringValue]];
         
//            if ([metaType isEqualToString:AVMetadataObjectTypeEAN13Code]) {
//                [[PALibraryDAL sharedIntance] Log:[metadataObj stringValue]];
//            }
            
//            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:YES];
            
            if (![self.scanedResultArr containsObject:info])
            {
                if (self.audioPlayer) {
                    [self.audioPlayer play];
                }
                [self.scanedResultArr addObject:info];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }
    }
}

- (void)displayinfo:(NSString *)info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Add",nil];
    [alert show];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 0:
//            [self back:nil];
//            break;
//        case 1:
//        {
//            [[PALibraryDAL sharedIntance].bookDAO insertBooks:self.scanedStr keyType:PABookKeyTypeISBN13];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scanedResultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.scanedResultArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%@", self.scanedResultArr[indexPath.row]);
}

@end
