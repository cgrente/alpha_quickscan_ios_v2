#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@interface FirstViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationBarDelegate, UIActionSheetDelegate> {
    UIImagePickerController* pickLib;
    UIPopoverController *popoverController;
}

@property (nonatomic, retain) UIPopoverController *popoverController;

-(IBAction)selectCamera:(id)sender;
-(IBAction)selectLib:(id)sender;

@end
