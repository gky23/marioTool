//
//  ReaderSampleViewController.m
//  ReaderSample
//
//  Created by spadix on 4/14/11.
//

#import "ReaderSampleViewController.h"
#import "GkyCommon.h"
#import "QRCode.h"
#import "ScanHistoryViewController.h"

@implementation ReaderSampleViewController

@synthesize resultImage, resultText;

-(void)viewDidLoad{
    UIBarButtonItem * left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanButtonTapped)];
    self.navigationItem.leftBarButtonItem=left;
    
    UIBarButtonItem * right= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(scanHistory)];
    self.navigationItem.rightBarButtonItem=right;
    
    self.title=@"二维码扫描";
}

-(void)scanHistory{
    ScanHistoryViewController *scanHistory = [[ScanHistoryViewController alloc]init];
    
    [self.navigationController pushViewController:scanHistory animated:YES];
    [scanHistory release];
}

- (IBAction) scanButtonTapped
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        NSLog(@"没有摄像头，不支持二维码扫描！");
        [GkyCommon showAlert:nil :@"没有摄像头，不支持二维码扫描！"];
        return;
    }

    float statusBarWidth = [UIApplication sharedApplication].statusBarFrame.size.width;

    
       // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;


        UIView *overlayView = [[UIView alloc]initWithFrame:CGRectMake(statusBarWidth/2-70, 120, 140, 140)];
        overlayView.backgroundColor=[UIColor blackColor];
        overlayView.alpha=0.7f;
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qr_mask.png"]];
        imageView.frame=overlayView.frame;
    imageView.center=overlayView.center;
    
        [overlayView addSubview:imageView];
    
    [imageView release];

//===================================
    [reader.readerView setZoom:10];
    reader.videoQuality=UIImagePickerControllerQualityTypeHigh;
    reader.showsZBarControls=YES;
        reader.cameraOverlayView=overlayView;
    reader.scanCrop=CGRectMake(0,0, 140, 140);
    [overlayView release];
       
    ZBarImageScanner *scanner = reader.scanner;
  
    // TODO: (optional) additional reader configuration here

    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];

    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;

    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    
    QRCode *qrCode = [[QRCode alloc]init];
    if ([GkyCommon looksLikeAURI:symbol.data]) {
        qrCode.codeType=@"URL";
    }
    else {
        qrCode.codeType=@"TEXT";
    }

    // EXAMPLE: do something useful with the barcode image

    
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];

    NSData *imageData =  UIImageJPEGRepresentation(resultImage.image, 0);
    qrCode.image=imageData;
    qrCode.content=symbol.data;
    qrCode.createTime=[GkyCommon getTimeStamp];
    
    [qrCode save];
    [qrCode release];
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
   
}

//- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
//{
//    return(YES);
//}

- (void) dealloc {
    self.resultImage = nil;
    self.resultText = nil;
    [super dealloc];
}

@end
