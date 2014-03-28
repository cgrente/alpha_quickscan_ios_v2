#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#include <opencv/cv.h>

#import "FirstViewController.h"

@interface ImproveImageViewController : UIViewController {
    FirstViewController* pView;
    UIImage* picture;
    UIImageView* imageView;
}

-(IBAction)nextButton:(id)sender;   
-(IBAction)backButton:(id)sender;
-(IBAction)weakButton:(id)sender;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageView:(UIImage*)image primaryView:(FirstViewController*)firstView;

@end
