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

#import "DocumentsViewController_iPhone.h"
#import "DocumentDisplayViewController_iPhone.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "FileFolderActionsViewController_iPhone.h"
#import "UIBarButtonItem+WEPopover.h"
#import "LanguageHelper.h"
#import "FileActionsViewController.h"
#import "AppDelegate_iPhone.h"
#import "eXoViewController.h"
#import "defines.h"
#import "UIImage+BlankImage.h"

#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for DocumentsViewController_iPhone
// ================================
@implementation DocumentsViewController_iPhone

@synthesize popoverController;
@synthesize popoverClass;

- (void)dealloc
{
//    [_actionsViewController release];
//    _actionsViewController = nil;
    [super dealloc];
}


-(void)setView:(UIView *)view {
    [super setView:view];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
    //Set the back indicator image to blank image with transparent color(Using custom function from Category UIImage(Blank))
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.backIndicatorImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(21, 41)];
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.backIndicatorTransitionMaskImage = [UIImage imageWithColor:[UIColor clearColor] andSize:CGSizeMake(21, 41)];
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    //Try setting this to UIPopoverController to use the iPad popover. The API is exactly the same!
	//popoverClass = [WEPopoverController class];
    currentPopoverCellIndex = -1;
    
    self.view.title = self.title;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    if (self.actionVisibleOnFolder) {
        [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    } else {
        [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationItem.rightBarButtonItem = nil;
    }

    CGRect tmpFrame = [[UIScreen mainScreen] bounds];
    tmpFrame.size.height -= 44; // navigation bar size. 
    self.tblFiles.frame = tmpFrame;
}

- (void)viewDidAppear:(BOOL)animated {
    // Unselect the selected row if any
    NSIndexPath*	selection = [_tblFiles indexPathForSelectedRow];
    if (selection)
        [_tblFiles deselectRowAtIndexPath:selection animated:YES];

}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:NO];
    self.popoverClass = nil;
}

-(void)viewDidUnload{
    [self.popoverController dismissPopoverAnimated:NO];
	self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:NO];
    self.popoverClass = nil;
    [super viewDidUnload];
}

//- (void)setHudPosition {
//    NSArray *visibleCells  = [_tblFiles visibleCells];
//    CGRect rect = CGRectZero;
//    for (int n = 0; n < [visibleCells count]; n ++){
//        UITableViewCell *cell = [visibleCells objectAtIndex:n];
//        if(n == 0){
//            rect.origin.y = cell.frame.origin.y;
//            rect.size.width = cell.frame.size.width;
//        }
//        rect.size.height += cell.frame.size.height;
//    }
//    _hudFolder.center = CGPointMake(self.view.frame.size.width/2, (((rect.size.width)/2 + rect.origin.y) <= self.view.frame.size.height) ? self.view.frame.size.height/2 : ((rect.size.height)/2 + rect.origin.y));
//    NSLog(@"%@", NSStringFromCGPoint(_hudFolder.center));
//}

#pragma mark - UINavigationBar Management

- (void)setTitleForFilesViewController {
    if (_rootFile) {
        self.title = _rootFile.naturalName;
    } else {
        self.title = Localize(@"Documents");
    }
}

- (void)contentDirectoryIsRetrieved{
    [super contentDirectoryIsRetrieved];
    // not the root level
    if(!isRoot && self.actionVisibleOnFolder) {
        UIImage *image = [UIImage imageNamed:@"NavbarDocumentActionButton.png"];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setImage:image forState:UIControlStateNormal];
        bt.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [bt addTarget:self action:@selector(showActionsPanelFromNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
        actionButton.width = image.size.width;
        //[self.view.navigationItem setRightBarButtonItem:actionButton];
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem setRightBarButtonItem:actionButton];        
        [actionButton release];
    }
}

- (void)deleteCurentFileView {
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar popNavigationItemAnimated:YES];
    [_parentController startRetrieveDirectoryContent];

}

- (void)showImagePickerForAddPhotoAction:(UIImagePickerController *)picker {
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone presentViewController:picker animated:YES completion:nil];
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem.rightBarButtonItem.enabled = YES;
	self.popoverController = nil;
    self.popoverClass = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Retrieve the File corresponding to the selected Cell

	File *fileToBrowse = [_dicContentOfFolder allValues][indexPath.section][indexPath.row];
	
	if(fileToBrowse.isFolder)
	{
        //Create a new FilesViewController_iPhone to push it into the navigationController
        DocumentsViewController_iPhone *newViewControllerForFilesBrowsing = [[DocumentsViewController_iPhone alloc] initWithRootFile:fileToBrowse withNibName:@"DocumentsViewController_iPhone"];
        
        // Check the folder can be supported actions or not.
        if (!_rootFile) {
            // if the view is first document view.
            NSString *driveGroup = [_dicContentOfFolder allKeys][indexPath.section];
            newViewControllerForFilesBrowsing.actionVisibleOnFolder = [newViewControllerForFilesBrowsing supportActionsForItem:fileToBrowse ofGroup:driveGroup];
        } else {
            // support action for every folder which is not a drive.
            newViewControllerForFilesBrowsing.actionVisibleOnFolder = YES;
        }
        
        newViewControllerForFilesBrowsing.parentController = self;
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:newViewControllerForFilesBrowsing animated:YES];
        //[self.navigationController pushViewController:newViewControllerForFilesBrowsing animated:YES];
        [newViewControllerForFilesBrowsing release];
	}
	else
	{
		
        NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[fileToBrowse.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
		DocumentDisplayViewController_iPhone* fileWebViewController = [[DocumentDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"DocumentDisplayViewController_iPhone"
                                                                                  bundle:nil 
                                                                                    url:urlOfTheFileToOpen
                                                                                fileName:fileToBrowse.naturalName];
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone pushViewController:fileWebViewController animated:YES];
		//[self.navigationController pushViewController:fileWebViewController animated:YES];    
        
        //[fileWebViewController release];
	}
	
}

#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    UIButton *bt = (UIButton *)sender;
    //Retrieve in the button, the tag with information corresponding to the indexPath of the touched cell
    //Use Modulo to retrieve the section information.
    NSIndexPath *indexPath = [self indexPathFromTagNumber:bt.tag];
    if (self.popoverController) {
        self.popoverController = nil;
    } 
    
    NSArray *arrFileFolder = [_dicContentOfFolder allValues][indexPath.section];
    fileToApplyAction = arrFileFolder[indexPath.row];
    
        FileActionsViewController *_actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                bundle:nil 
                                                file:fileToApplyAction 
                                                enableDeleteThisFolder:YES
                                                enableCreateFolder:NO
                                                enableRenameFile:(_rootFile.canAddChild && fileToApplyAction.canRemove)
                                                delegate:self];
    
    
    UITableViewCell *cell = [_tblFiles cellForRowAtIndexPath:indexPath];
    CGRect frame =cell.accessoryView.frame;
    
    // get the position of the Accessory View in the Table View (_tblFiles)
    frame = [cell convertRect:frame toView:_tblFiles];
    

    self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:_actionsViewController] autorelease];
    
    [self.popoverController setContainerViewProperties:self.popoverProperties];
    /*
     The direction of the arrow depend on the position of the accessoryView in the tableView (_tblFiles). Futher more, we preferer the direction Up/Down which allow the title of the cell to be visible
     */

    if (frame.origin.y > kPreferredContentSize.height){
        frame.origin.y +=10;
        [self.popoverController presentPopoverFromRect:frame inView:_tblFiles permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }  else if (_tblFiles.frame.size.height - frame.origin.y - frame.size.height  > kPreferredContentSize.height) {
        frame.origin.y -=10;
        [self.popoverController presentPopoverFromRect:frame inView:_tblFiles permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [self.popoverController presentPopoverFromRect:frame inView:_tblFiles permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    [_actionsViewController release];
}


#pragma mark - Panel Actions

-(void) showActionsPanelFromNavigationBarButton:(id)sender {
    
    displayActionDialogAtRect = CGRectZero;
    
    if (self.popoverClass) {
        [self.popoverClass dismissPopoverAnimated:YES];
        self.popoverClass = nil;

        return;
    } 
    //Check if the _actionsViewController is already created or not
    
    FileActionsViewController *_actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController"
                                                bundle:nil 
                                                file:_rootFile 
                                                enableDeleteThisFolder:YES
                                                enableCreateFolder:YES
                                                enableRenameFile:NO
                                                delegate:self];

    fileToApplyAction = _rootFile;
    
    self.popoverClass = [[[WEPopoverController alloc] initWithContentViewController:_actionsViewController] autorelease];
    [_actionsViewController release];
    self.popoverClass.delegate = self;
    
    [self.popoverClass setContainerViewProperties:self.popoverProperties];
    
    CGRect frame = CGRectMake(290,-5, 0, 0);
    [self.popoverClass presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem.rightBarButtonItem.enabled = NO;
}

-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    
    FileFolderActionsViewController_iPhone *fileFolderActionsController = [[FileFolderActionsViewController_iPhone alloc] initWithNibName:@"FileFolderActionsViewController_iPhone" bundle:nil];
    [fileFolderActionsController setIsNewFolder:createNewFolder];
    [fileFolderActionsController setNameInputStr:@""];
    [fileFolderActionsController setFocusOnTextFieldName];
    fileFolderActionsController.fileToApplyAction = fileToApplyAction;
    fileFolderActionsController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:fileFolderActionsController];
    [fileFolderActionsController release];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:YES animated:YES];

    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone dismissViewControllerAnimated:YES completion:nil];
    
    [navController release];
    
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem.rightBarButtonItem.enabled = YES;
}



-(void) hideActionsPanel {
    [super hideActionsPanel];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem.rightBarButtonItem.enabled = YES;
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
}


- (void)hideFileFolderActionsController {
    [super hideFileFolderActionsController];
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone dismissViewControllerAnimated:YES completion:nil];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem.rightBarButtonItem.enabled = YES;
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
}


- (void)showActionSheetForPhotoAttachment
{    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Localize(@"AddAPhoto") delegate:self cancelButtonTitle:Localize(@"Cancel") destructiveButtonTitle:nil  otherButtonTitles:Localize(@"TakeAPicture"), Localize(@"PhotoLibrary"), nil, nil];
    [actionSheet showInView:self.view];
    
    [actionSheet release];
}
 

#pragma mark - ActionSheet Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];    
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    //Dismiss all popover
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.contentNavigationBar.topItem.rightBarButtonItem.enabled = YES;

}




@end
