#import "ImproveResizeImageViewController.h"
#import "ImproveImageViewController.h"
#import "ShareFunction.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"

@implementation ImproveResizeImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil saveImage:(UIImageView*)sImage originalImg:(UIImage*)orgImg previousView:(ImproveImageViewController*)pView mainView:(FirstViewController*)mView
{
    NSLog(@"init - improveResizeImage");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pView = pView;
        _mView = mView;
        _sImage = sImage;
        _orignImg = orgImg;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self 
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.1;
    [[self view] addGestureRecognizer:longPress];
    [longPress release];
    
    [self edgeDetectionForResize];
    
    cropImg = [[Draw2D alloc]initWithFrame:CGRectMake(outPutImage.frame.origin.x, outPutImage.frame.origin.y,outPutImage.frame.size.width, outPutImage.frame.size.height):saveCoord];
    
    NSLog(@"outPutImage frame size width ==== %f", outPutImage.frame.size.width);
    NSLog(@"outPutImage frame size height ==== %f", outPutImage.frame.size.height);
    
    [cropImg setOpaque:NO];
    
    [[self view]addSubview:cropImg];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - touchResize

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pos = [sender locationInView:[self view]];
        
        UIImageView *zoomedView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 90, 90)];
        [zoomedView setOpaque:YES];

        UIImage* newImage = [outPutImage image];
        UIImage *retImg = [newImage imageWithAlpha];
        CGFloat pointToCropX = pos.x - outPutImage.frame.origin.x;
        CGFloat pointToCropY = pos.y - outPutImage.frame.origin.y;
        [zoomedView setImage:[retImg croppedImage:CGRectMake(pointToCropX, pointToCropY, outPutImage.frame.size.width, outPutImage.frame.size.height)]];
        
        zoomOnSelectedCornerView = [[UIView alloc]initWithFrame:CGRectMake(20,20, 50, 25)];
        [zoomOnSelectedCornerView setBackgroundColor:[UIColor redColor]];
        [zoomOnSelectedCornerView addSubview:zoomedView];
        [[self view]addSubview:zoomOnSelectedCornerView];

        NSLog(@"Press - tu touches");
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        
        [cropImg removeFromSuperview];
        [cropImg release];
        
        cropImg = [[Draw2D alloc]initWithFrame:CGRectMake(outPutImage.frame.origin.x, outPutImage.frame.origin.y,outPutImage.frame.size.width, outPutImage.frame.size.height):saveCoord];
        
        [cropImg setOpaque:NO];
        [[self view]addSubview:cropImg];
        
        [zoomOnSelectedCornerView removeFromSuperview];
        [zoomOnSelectedCornerView release];
        
        CGPoint pos = [sender locationInView:[self view]];
        
        UIImageView *zoomedView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 90, 90)];
        [zoomedView setOpaque:YES];
        
        UIImage* newImage = [outPutImage image];
        UIImage *retImg = [newImage imageWithAlpha];
        CGFloat pointToCropX = pos.x - outPutImage.frame.origin.x;
        CGFloat pointToCropY = pos.y - outPutImage.frame.origin.y;
        [zoomedView setImage:[retImg croppedImage:CGRectMake(pointToCropX, pointToCropY, outPutImage.frame.size.width, outPutImage.frame.size.height)]];
        
        zoomOnSelectedCornerView = [[UIView alloc]initWithFrame:CGRectMake(20,20, 50, 25)];
        [zoomOnSelectedCornerView setBackgroundColor:[UIColor redColor]];
        [zoomOnSelectedCornerView addSubview:zoomedView];
        [[self view]addSubview:zoomOnSelectedCornerView];
        
        NSLog(@"Press - tu bouges");
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
    
        CGPoint position = [sender locationInView:[self view]];
        NSLog(@"Long press Ended : %f/%f",position.x, position.y);
        
        // enlève l'ancien cropRectangle
        [cropImg removeFromSuperview];
        [cropImg release];
        // dessine le nouveau crop Rectangle
        cropImg = [[Draw2D alloc]initWithFrame:CGRectMake(outPutImage.frame.origin.x, outPutImage.frame.origin.y,outPutImage.frame.size.width, outPutImage.frame.size.height):saveCoord];
        [cropImg setOpaque:NO];
        [[self view]addSubview:cropImg];
        
        //enlève la vue de départ
        [zoomOnSelectedCornerView removeFromSuperview];
        [zoomOnSelectedCornerView release];
        
        NSLog(@"Press - tu as fini");
    }
}

#pragma mark - switch view

-(IBAction)addPhoto:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
    
    UIView *newView = _mView.view;
    
    UIView *currentView = self.view;
    UIView *displayedView = [currentView superview];
    
    
    // remove the current view and replace with myView1
    [currentView removeFromSuperview];
    [displayedView addSubview:newView];
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.6];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[displayedView layer] addAnimation:animation forKey:@"SwitchToImproveImage"];
}

-(IBAction)saveButton:(id)sender {
    UIImage* saveToAlbum = [_sImage image];
    
    NSLog(@"photo save");
    
    UIImageWriteToSavedPhotosAlbum(saveToAlbum, nil, nil, nil);
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Save" 
                          message:@"la photo a été sauvegarder !" 
                          delegate:nil 
                          cancelButtonTitle:@"Quit" 
                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)backButton:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
   
    //[[ShareFunction sFunction]previousView:_pView.view currentView:_mView.view];
    
    UIView *newView = _pView.view;
    
    UIView *currentView = self.view;
    UIView *displayedView = [currentView superview];
    
    // remove the current view and replace with myView1
    [currentView removeFromSuperview];
    [displayedView addSubview:newView];
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.6];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[displayedView layer] addAnimation:animation forKey:@"SwitchToImproveImage"];
}


#pragma mark - draw rect

-(void)saveCoordForDraw:(IplImage*)imgDraw {
    saveCoord = (t_coordRect*)malloc(sizeof(t_coordRect));
    
    //save the coord border of picture
    saveCoord->leftUpPixelCoord = (CGPoint *)malloc(sizeof(CGPoint));
    saveCoord->rightDownPixelCoord = (CGPoint *)malloc(sizeof(CGPoint));
    saveCoord->leftUpPixelCoord = [self checkPixelValue:1 :imgDraw];
    saveCoord->rightDownPixelCoord = [self checkPixelValue:2 :imgDraw];
    
    
    NSLog(@"save the retValue left ==== %f", saveCoord->leftUpPixelCoord->x);
    NSLog(@"save the retValue left ==== %f", saveCoord->leftUpPixelCoord->y);
    NSLog(@"save the retValue right ==== %f", saveCoord->rightDownPixelCoord->x);
    NSLog(@"save the retValue right ==== %f", saveCoord->rightDownPixelCoord->y);
}



-(CGPoint*)checkPixelValue:(int)flag:(IplImage*)imgTmp {
    CGPoint* retValue = (CGPoint *)malloc(sizeof(CGPoint));
    CvScalar scalValue;

    NSLog(@"width image ==== %d", imgTmp->width);
    NSLog(@"height image ==== %d", imgTmp->height);
    
    saveCoord->imgWidth = imgTmp->width - 1;
    saveCoord->imgHeight = imgTmp->height - 1;
    
    //parcours la matrice image pour check la valeur du pixel
    
    if (flag == 1) {
        for(_y = 0;_y < imgTmp->height-1; _y++){
        for (_x = 0;_x < imgTmp->width-1; _x++){
            
                scalValue = cvGet2D(imgTmp, _y, _x);
                if (scalValue.val[0] == 255)
                {
                    NSLog(@"left scale value ==== %f", scalValue.val[0]);
                    
                    NSLog(@"left coord x ==== %d", _x);
                    NSLog(@"left coord y ==== %d", _y);
                    
                    retValue->x = _x;
                    retValue->y = _y;
                    return retValue;
                    }
                    _y++; 
                }
            }
        
        } else if (flag == 2) {
             for(_y = imgTmp->height-1;_y > 0; _y--){
            for (_x = imgTmp->width-1  ;_x > 0; _x--){
                scalValue = cvGet2D(imgTmp, _y, _x);
                if (scalValue.val[0] == 255){
                    NSLog(@"right scale value ==== %f", scalValue.val[0]);
               
                    NSLog(@"right coord x ==== %d", _x );
                    NSLog(@"right coord y ==== %d", _y);
               
                    retValue->x = _x;
                    retValue->y = _y;
                    return retValue;
                }
                _y--;
            }
             }
        }
    return 0;
}

#pragma mark - edge detection

-(void)edgeDetectionForResize {
    UIImage* startImg = [[ShareFunction sFunction]rotate:_sImage.image :90];
    
    // Create grayscale IplImage from UIImage
    IplImage *img_color = [[ShareFunction sFunction]CreateIplImageFromUIImage:startImg];
    IplImage *img = cvCreateImage(cvGetSize(img_color), IPL_DEPTH_8U, 1);
    cvCvtColor(img_color, img, CV_BGR2GRAY);
    cvReleaseImage(&img_color);
    
    // Detect edge
    IplImage *img2 = cvCreateImage(cvGetSize(img), IPL_DEPTH_8U, 1);
    cvCanny(img, img2, 10   , 100, 3);
    cvReleaseImage(&img);
    
    // Convert black and whilte to 24bit image then convert to UIImage to show
    IplImage *image = cvCreateImage(cvGetSize(img2), IPL_DEPTH_8U, 3);
    int x, y;
    for(y=0; y<img2->height; y++) {
        for(x=0; x<img2->width; x++) {
            char *p = image->imageData + y * image->widthStep + x * 3;
            *p = *(p+1) = *(p+2) = img2->imageData[y * img2->widthStep + x];
        }
    }
    cvReleaseImage(&img2);
    [self saveCoordForDraw:image];
    UIImage* retImg = [[ShareFunction sFunction]UIImageFromIplImage:image];
    outPutImage.image = retImg;
    cvReleaseImage(&image);                                                                                                                                                                                                                                                                                                                                             
}

@end
