//
// Copyright (C) 2003-2014 eXo Platform SAS.
//
// This is free software; you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as
// published by the Free Software Foundation; either version 3 of
// the License, or (at your option) any later version.
//
// This software is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this software; if not, write to the Free
// Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
// 02110-1301 USA, or see the FSF site: http://www.fsf.org.
//

#import "PhotoActionViewController.h"
#import "MessageComposerViewController_iPad.h"
#import "LanguageHelper.h"
#import "MessageComposerViewController.h"
#import "DocumentsViewController.h"
#import "DocumentsViewController_iPad.h"

@implementation PhotoActionViewController

@synthesize _delegate, _rectForPresentView, _viewForPresent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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

/*
- (IBAction)onBtnTakePhoto:(id)sender
{
    [_delegate onBtnTakePhoto];
}

- (IBAction)onBtnPhotoLibrary:(id)sender
{
    [_delegate onBtnPhotoLibrary];
}

- (IBAction)onBtnCancel:(id)sender
{
    [_delegate onBtnCancel];
}
 */

- (IBAction)onBtnTakePhoto:(id)sender
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {  
        thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:thePicker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakeAPicture")  message:Localize(@"CameraNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [thePicker release];
}

- (IBAction)onBtnPhotoLibrary:(id)sender
{
    
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    thePicker.allowsEditing = YES;
    thePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    thePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    thePicker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (_popoverPhotoLibraryController == nil) 
    {
        _popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:thePicker];
    }
    else
    {
        [_popoverPhotoLibraryController setContentViewController:thePicker];   
    }
    
    [_popoverPhotoLibraryController setPopoverContentSize:CGSizeMake(320, 320) animated:YES];
    
    if(_rectForPresentView.size.width == 0)
    {
        //present the popover from the rightBarButtonItem of the navigationBar
        UINavigationBar *navigationBar = [((DocumentsViewController_iPad *)_delegate) navigationBar];
        [_popoverPhotoLibraryController presentPopoverFromBarButtonItem:navigationBar.topItem.rightBarButtonItem 
                                              permittedArrowDirections:UIPopoverArrowDirectionUp 
                                                              animated:YES];
        
    }
    else
    {
        [_popoverPhotoLibraryController presentPopoverFromRect:_rectForPresentView inView:_viewForPresent permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];        
    }

    _rectForPresentView = CGRectZero;
    
    [thePicker release];
}

//- (IBAction)onBtnCancel:(id)sender
//{
//    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
//    [_delegate dismissAddPhotoPopOver:YES];
//}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    
    if([_delegate respondsToSelector:@selector(dismissAddPhotoPopOver:)])
        [_delegate dismissAddPhotoPopOver:YES];
    
    if([_delegate isKindOfClass:[MessageComposerViewController class]])
    {
        [_delegate addPhotoToView:[editingInfo objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }
    else if([_delegate isKindOfClass:[DocumentsViewController class]])
    {
        UIImage* selectedImage = image;
        NSData* imageData = UIImagePNGRepresentation(selectedImage);
        
        
        if ([imageData length] > 0) 
        {
            NSString *imageName = [[editingInfo objectForKey:@"UIImagePickerControllerReferenceURL"] lastPathComponent];
            
            if(imageName == nil) {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
                NSString* tmp = [dateFormatter stringFromDate:[NSDate date]];
                
                //release the date formatter because, not needed after that piece of code
                [dateFormatter release];
                imageName = [NSString stringWithFormat:@"MobileImage_%@.png", tmp];
                
            }
            NSString *_stringForUploadPhoto = [[((DocumentsViewController *)_delegate) stringForUploadPhoto] stringByAppendingFormat:@"/%@", imageName];
            
            //TODO Localize this string
//            [self showHUDWithMessage:Localize(@"SendImageToFolder")];
            
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(sendImageInBackgroundForDirectory:data:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(sendImageInBackgroundForDirectory:data:)];
            [invocation setArgument:&_stringForUploadPhoto atIndex:2];
            [invocation setArgument:&imageData atIndex:3];
            [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
            
        }
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    [_delegate dismissAddPhotoPopOver:YES];
}

- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    [[FilesProxy sharedInstance] fileAction:kFileProtocolForUpload source:directory destination:nil data:imageData];
    //Need to reload the content of the folder
    [(DocumentsViewController*)_delegate startRetrieveDirectoryContent];
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
