#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ImproveResizeImageViewController.h"
#import "Draw2D.h"

@interface ShareFunction : NSObject {

}

+(ShareFunction*) sFunction;

-(void)nextView:(id)nView currentView:(id)currView;
-(void)previousView:(id)pView currentView:(id)currView;

-(UIImage*)filterImgBrightness:(UIImage*)picture;
-(UIImage*)rotate:(UIImage*)src:(UIImageOrientation)orientation;
-(UIImage *)UIImageFromIplImage:(IplImage *)image;
-(IplImage *)CreateIplImageFromUIImage:(UIImage *)image;
-(UIImage *)resizeImage:(UIImage *)image;
-(UIImage*)filterImgGray:(UIImage*)picture;

@end
