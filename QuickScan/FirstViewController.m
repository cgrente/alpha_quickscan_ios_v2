#import "FirstViewController.h"
#import "ImproveImageViewController.h"
#import "ShareFunction.h"

@implementation FirstViewController

@synthesize popoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"init - fview");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

//release all allocate object

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[self view]release];
    [popoverController release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

// lock orientation to verticale

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return NO;
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
        return NO;
    return YES;
}

// take a photo

-(IBAction)selectCamera:(id)sender {
    pickLib = [[UIImagePickerController alloc] init];
    
    [pickLib setDelegate:(id)self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error device does not supported" 
                              message:@"You don't have a camera." 
                              delegate:nil 
                              cancelButtonTitle:@"Abort" 
                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        pickLib.sourceType = UIImagePickerControllerSourceTypeCamera ;
        [self presentModalViewController:pickLib animated:YES];
    }
    [pickLib release];
}

// choose into photolibrary

-(IBAction)selectLib:(id)sender {
    pickLib = [[[UIImagePickerController alloc] init]retain];
    [pickLib setDelegate:(id)self];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        pickLib.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:pickLib animated:NO];
    } else {
    UIImagePickerController* picker = [[UIImagePickerController alloc] init]; 
        
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
    picker.delegate = (id)self; 
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
    self.popoverController = popover;          
    popoverController.delegate = (id)self;
    [popoverController presentPopoverFromRect:CGRectMake(100, 100.0, 0.0, 0.0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    [pickLib release];
}

// manage the next view and changes it

-(void)imagePickerController:(UIImagePickerController *)pickCam didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfog {
    [self dismissModalViewControllerAnimated:YES]; 
    [self.popoverController dismissPopoverAnimated:YES];
   
    ImproveImageViewController* improveImageView;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        improveImageView = [[ImproveImageViewController alloc]
                             initWithNibName:@"ImproveImageView_iPhone"
                             bundle:nil 
                             imageView:image
                             primaryView:self
                             ];
    } else {
        improveImageView = [[ImproveImageViewController alloc]
                             initWithNibName:@"ImproveImageView_iPad"
                             bundle:nil 
                             imageView:image
                             primaryView:self
                             ];
    }
    [improveImageView dismissModalViewControllerAnimated:YES];
    [[ShareFunction sFunction]nextView:improveImageView.view currentView:self.view];
    NSLog(@"photo prise");
}

// manage when you cancel your photo

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   [picker dismissModalViewControllerAnimated:YES];
    NSLog(@"prise annuler");
}

@end
