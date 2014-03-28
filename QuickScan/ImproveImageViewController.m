#import "ImproveImageViewController.h"
#import "ImproveResizeImageViewController.h"
#import "ShareFunction.h"

#import <opencv/highgui.h>
#import <math.h>

@implementation ImproveImageViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageView:(UIImage*)image primaryView:(FirstViewController*) firstView {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        picture = image;
        pView = firstView;
    }
    return self;
}

-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    imageView = [[UIImageView alloc]initWithImage:picture];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [imageView setFrame:CGRectMake(60, 50, 210, 297)];
    else
        [imageView setFrame:CGRectMake(166, 54, 420, 594)];

    [[self view]addSubview:imageView];
}

// release all memory allocate

-(void)viewDidUnload {
    [super viewDidUnload];
    [picture release];
    [pView release];
    [imageView setImage:nil];
    [imageView release];
}

#pragma mark - gestion retouche

// apply grayscale fitler on picture

-(IBAction)weakButton:(id)sender {
    NSLog(@"improve image");
    
    UIImage* imgStart = [[ShareFunction sFunction]rotate:picture :90];
    UIImage* grayImg = [[ShareFunction sFunction]filterImgGray:imgStart];
    imageView.image = grayImg;
    [[self view]addSubview:imageView];
}

#pragma mark - action divers

// manage the next view and changes it

-(IBAction)nextButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    ImproveResizeImageViewController* nView;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nView = [[ImproveResizeImageViewController alloc] 
                 initWithNibName:@"ImproveResizeImageView_iPhone" 
                 bundle:nil 
                 saveImage:imageView
                 originalImg:picture
                 previousView:self
                 mainView:pView
                 ];
    } else {
        nView = [[ImproveResizeImageViewController alloc] 
                 initWithNibName:@"ImproveResizeImageView_iPad" 
                 bundle:nil
                 saveImage:imageView
                 originalImg:picture
                 previousView:self
                 mainView:pView
                 ];
    }
    [nView dismissModalViewControllerAnimated:YES];
    //call singleton's function to configure how to pass to the third view
    [[ShareFunction sFunction]nextView:nView.view currentView:self.view];
}

-(IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];    
    [[ShareFunction sFunction]previousView:pView.view currentView:self.view];    
}

-(IBAction)quitButton:(id)sender {
    NSLog(@"quit");
    exit(EXIT_SUCCESS);
}

@end
