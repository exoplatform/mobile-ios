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

#import "MessageComposerViewController_iPad.h"
#import "ActivityStreamBrowseViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "LanguageHelper.h"

@implementation MessageComposerViewController_iPad


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

- (void)updateHudPosition {
    self.hudLoadWaiting.center = CGPointMake(self.view.center.x, self.view.center.y-70);
}

-(void)dealloc 
{
    [super dealloc];
}

- (void)showActionSheetForPhotoAttachment
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Localize(@"AddAPhoto")
                                                             delegate:self 
                                                    cancelButtonTitle:nil 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:Localize(@"TakeAPicture"), 
                                  Localize(@"PhotoLibrary"), nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showFromRect:_btnAttach.frame inView:self.view animated:YES];
    
}


- (void)onBtnTakePhoto
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakeAPicture")  message:Localize(@"CameraNotAvailable") delegate:self cancelButtonTitle:Localize(@"OK") otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [thePicker release];
}

- (void)onBtnPhotoLibrary
{
    [self editPhoto];
}

- (void)onBtnCancel
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

#pragma mark UIImagePickerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
