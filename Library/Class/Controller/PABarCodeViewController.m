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
    <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
//iOS7 system barcode service
@property (nonatomic, assign) AVCaptureDevice *captureDevice;
@property (nonatomic, assign) UIView *videoPreviewView;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (atomic, assign) BOOL isReading;

@end

@implementation PABarCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    UIBarButtonItem *flashBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(switchFlash:)];
    self.navigationItem.rightBarButtonItem = flashBarButton;
    
    UIView *videoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:videoView];
    videoView.backgroundColor = [UIColor blackColor];
    videoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.videoPreviewView = videoView;
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(videoView);
    NSDictionary *metrics = @{@"Padding":@0};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Padding-[videoView]-Padding-|" options:0 metrics:metrics views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Padding-[videoView]-Padding-|" options:0 metrics:metrics views:viewDict]];
    
    
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

- (void)switchFlash:(id)sender
{
    if (self.captureDevice && self.captureDevice.hasTorch && self.captureDevice.isTorchAvailable) {
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
            NSLog(@"%@",info);
            self.isReading = NO;
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:YES];
            
            if (self.audioPlayer) {
                [self.audioPlayer play];
            }
            [self performSelectorOnMainThread:@selector(displayinfo:) withObject:info waitUntilDone:YES];
        }
    }
}

- (void)displayinfo:(NSString *)info
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self back:nil];
}

@end
