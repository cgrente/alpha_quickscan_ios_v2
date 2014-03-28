#import <UIKit/UIKit.h>
#import "ImproveImageViewController.h"
#import "Draw2D.h"

typedef struct s_coordRect {
    CGPoint* leftUpPixelCoord;
    CGPoint* rightDownPixelCoord;
    float imgHeight;
    float imgWidth;
} t_coordRect;


@interface ImproveResizeImageViewController : UIViewController {
    ImproveImageViewController* _pView;
    FirstViewController* _mView;
    UIImageView* _sImage;
    UIImage* _orignImg;
    UIView *zoomOnSelectedCornerView;
    IBOutlet UIImageView *outPutImage;
    int _x, _y;
    t_coordRect* saveCoord;
    Draw2D* cropImg;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil saveImage:(UIImageView*)sImage originalImg:(UIImage*)orgImg previousView:(ImproveImageViewController*)pView mainView:(FirstViewController*)mView;

-(IBAction)addPhoto:(id)sender;
-(IBAction)backButton:(id)sender;
-(IBAction)saveButton:(id)sender;

-(void)edgeDetectionForResize;
-(void)saveCoordForDraw:(IplImage*)imgDraw;
-(CGPoint*)checkPixelValue:(int)flag:(IplImage*)imgTmp;
- (void)handleLongPress:(UILongPressGestureRecognizer*)sender;

@end
