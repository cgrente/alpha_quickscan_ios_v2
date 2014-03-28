#import <math.h>
#import <opencv/highgui.h>
#import <opencv/cv.h>

#import "ImproveImageViewController.h"
#import "ImproveResizeImageViewController.h"
#import "ShareFunction.h"
#import "Draw2D.h"

@implementation ShareFunction

static ShareFunction* sfunc;

+(ShareFunction*)sFunction {
    if (sfunc == nil)
        sfunc = [[super allocWithZone:NULL] init];
    return sfunc;
}

+(id)allocWithZone:(NSZone *)zone {
    return [[self sFunction] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease {
    return self;
}

#pragma mark - retouche image

static inline double radians (double degrees) {return degrees * M_PI/180;}

// make IplImage with UIImage

- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    CGImageRef imageRef = image.CGImage;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
													iplimage->depth, iplimage->widthStep,
													colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
    
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
	cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
// make UIImage with IplImage

- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
	CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGImageRef imageRef = CGImageCreate(image->width, image->height,
										image->depth, image->depth * image->nChannels, image->widthStep,
										colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
										provider, NULL, false, kCGRenderingIntentDefault);
	UIImage *ret = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGColorSpaceRelease(colorSpace);
	return ret;
}


-(UIImage *)resizeImage:(UIImage *)image {
    CGImageRef imageRef = [image CGImage];
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
    
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    int width, height;
    width = 960;
    height = 680;
    CGContextRef bitmap;
    if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown)
        bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
    else
        bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
    CGContextRotateCTM (bitmap, radians(-90));
    CGContextTranslateCTM (bitmap, -width, 0);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    CGColorSpaceRelease(colorSpaceInfo);
    return result;	
}

// function to switch with the next view

-(void)nextView:(id)nView currentView:(id)currView {
    UIView *displayedView = [currView superview];
    
    // remove the current view and replace with myView1
    [currView removeFromSuperview];
    [displayedView addSubview:nView];
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[displayedView layer] addAnimation:animation forKey:@"SwitchToImproveImage"];
}

// function to switch with the previous view

-(void)previousView:(id)pView currentView:(id)currView {
    UIView *displayedView = [currView superview];
    
    // remove the current view and replace with myView1
    [currView removeFromSuperview];
    [displayedView addSubview:pView];
    
    // set up an animation for the transition between the views
    CATransition *animation = [CATransition animation];
    
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [[displayedView layer] addAnimation:animation forKey:@"SwitchToImproveImage"];
}

// function to rotate the UIImage

- (UIImage*)rotate:(UIImage*)src:(UIImageOrientation)orientation
{
        UIGraphicsBeginImageContext(src.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (orientation == UIImageOrientationRight) {
            CGContextRotateCTM (context, radians(90));
        } else if (orientation == UIImageOrientationLeft) {
            CGContextRotateCTM (context, radians(-90));
        } else if (orientation == UIImageOrientationDown) {
            // NOTHING
        } else if (orientation == UIImageOrientationUp) {
            CGContextRotateCTM (context, radians(90));
        }
        
        [src drawAtPoint:CGPointMake(0, 0)];
        
        return UIGraphicsGetImageFromCurrentImageContext();
}

// processing to put the image black and white then reduce the noise of the image

-(UIImage*)filterImgGray:(UIImage*)picture {
    IplImage* imgOpencv = [self CreateIplImageFromUIImage:picture];
    IplImage* newImg = cvCreateImage(cvSize(imgOpencv->width, imgOpencv->height), IPL_DEPTH_8U, 1);
    cvCvtColor(imgOpencv, newImg, CV_BGR2GRAY);
    //cvEqualizeHist(newImg, newImg);  // a voir si use or not
    cvReleaseImage(&imgOpencv);
    IplImage *image = cvCreateImage(cvGetSize(newImg), IPL_DEPTH_8U, 3);    
    int y, x;
    
    for(y=0; y<newImg->height; y++) {
        for(x=0; x<newImg->width; x++) {
            char *p = image->imageData + y * image->widthStep + x * 3;
			*p = *(p+1) = *(p+2) = newImg->imageData[y * newImg->widthStep + x];
        }
    }
    cvThreshold(image, image, 110, 255, CV_THRESH_TOZERO);
    cvThreshold(image, image, 100, 255, CV_THRESH_BINARY);
    
    //cvThreshold(image, image, 0, 255, CV_THRESH_BINARY_INV | CV_THRESH_OTSU); // a voir
    UIImage* retImg = [self UIImageFromIplImage:image];
    cvReleaseImage(&image);
    NSLog(@"dada");
    return retImg;
}

// traitement image pour eclaircire 

-(UIImage*)filterImgBrightness:(UIImage*)picture {
    // to do
    return picture;
}

@end
