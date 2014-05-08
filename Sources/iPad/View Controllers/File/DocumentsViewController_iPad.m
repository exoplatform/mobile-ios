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

#import "DocumentsViewController_iPad.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "FileActionsViewController.h"
#import "FileFolderActionsViewController_iPad.h"
#import "DocumentDisplayViewController_iPad.h"
#import "ExoStackScrollViewController.h"
#import "LanguageHelper.h"
#import "EmptyView.h"
#import "RoundRectView.h"
#import "UIBarButtonItem+WEPopover.h"

@implementation DocumentsViewController_iPad



#pragma mark - UIViewController methods

- (void)createTableViewWithStyle:(UITableViewStyle)style {
    
    CGRect rectOfSelf = self.view.frame;
    CGRect rectForTableView = CGRectMake(0, 44, rectOfSelf.size.width, rectOfSelf.size.height - 44);

    _tblFiles = [[UITableView alloc] initWithFrame:rectForTableView style:style];
    _tblFiles.delegate = self;
    _tblFiles.dataSource = self;
    _tblFiles.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tblFiles.backgroundColor = EXO_BACKGROUND_COLOR;
    [_tblFiles setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [((RoundRectView *) [[self.view subviews] objectAtIndex:0]) addSubview:_tblFiles];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    //Add the UIBarButtonItem for actions on the NavigationBar of the Controller
    if (_rootFile) {
        _navigation.topItem.title = _rootFile.name;
    } else {
        _navigation.topItem.title = Localize(@"Documents") ;
        ((RoundRectView *) [[self.view subviews] objectAtIndex:0]).squareCorners = NO;
    }
    _navigation.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
}

- (CGRect)rectOfHeader:(int)width
{
    return CGRectMake(50.0, 11.0, width, kHeightForSectionHeader);
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
        [_navigation.topItem setRightBarButtonItem:actionButton];
        
        [actionButton release];
    }
}

- (void)deleteCurentFileView {
    // This method will remove this view and reload its parent view. 
    ExoStackScrollViewController *stackScrollVC = [AppDelegate_iPad instance].rootViewController.stackScrollViewController;
    int viewIndex = [stackScrollVC.viewControllersStack indexOfObject:self];
    if (viewIndex != NSNotFound) {
        DocumentsViewController *parentController = viewIndex > 0 ? [[stackScrollVC.viewControllersStack objectAtIndex:viewIndex - 1] retain] : nil;
        [stackScrollVC removeViewFromController:parentController];
        // Reload the content of the parent view.
        [parentController startRetrieveDirectoryContent];
        [parentController release];
        
    }
}

- (void)removeFileViewsFromMe {
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:self];
}

- (void)showImagePickerForAddPhotoAction:(UIImagePickerController *)picker {
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    self.popoverPhotoLibraryController = [[[UIPopoverController alloc] initWithContentViewController:picker] autorelease];
    self.popoverPhotoLibraryController.delegate = self;
    
    if(displayActionDialogAtRect.size.width == 0) {
        //present the popover from the rightBarButtonItem of the navigationBar
//        [self.popoverPhotoLibraryController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        CGRect rect = [_navigation.topItem.rightBarButtonItem frameInView:self.view];
        rect.origin.x += 10;
        rect.origin.y += 20;
        rect.size.width = 0;
        rect.size.height = 0;
        [self.popoverPhotoLibraryController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    } else {
        [self.popoverPhotoLibraryController presentPopoverFromRect:displayActionDialogAtRect inView:_currentCell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    }
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)dealloc {
    if(_actionPopoverController != nil){
        [_actionPopoverController release];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:EXO_NOTIFICATION_CHANGE_LANGUAGE object:nil];
    [super dealloc];
}


#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    UIButton *bt = (UIButton *)sender;
    //Retrieve in the button, the tag with information corresponding to the indexPath of the touched cell
    //Use Modulo to retrieve the section information.
    NSIndexPath *indexPath = [self indexPathFromTagNumber:bt.tag];
    
    NSArray *arrFileFolder = [[_dicContentOfFolder allValues] objectAtIndex:indexPath.section];
    fileToApplyAction = [arrFileFolder objectAtIndex:indexPath.row];
    
    FileActionsViewController *fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" bundle:nil file:fileToApplyAction enableDeleteThisFolder:YES enableCreateFolder:NO enableRenameFile:(_rootFile.canAddChild && fileToApplyAction.canRemove) delegate:self];
    
    UITableViewCell *cell = [_tblFiles cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.accessoryView.frame;
    frame.origin.x += 20;
    
    displayActionDialogAtRect = frame;
    _currentCell = cell;
    
    //Display the UIPopoverController
    [_actionPopoverController dismissPopoverAnimated:NO];
    [_actionPopoverController release];
	_actionPopoverController = [[WEPopoverController alloc] initWithContentViewController:fileActionsViewController];
    _actionPopoverController.delegate = self;
//	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
	[_actionPopoverController presentPopoverFromRect:frame inView:cell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    [fileActionsViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Retrieve the File corresponding to the selected Cell
	File *fileToBrowse = [[[_dicContentOfFolder allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    [[AppDelegate_iPad instance].rootViewController.stackScrollViewController removeViewFromController:self];
	
	if(fileToBrowse.isFolder)
	{
        //Create a new FilesViewController_iPad to push it into the navigationController
        DocumentsViewController_iPad *newViewControllerForFilesBrowsing = [[DocumentsViewController_iPad alloc] initWithRootFile:fileToBrowse withNibName:@"DocumentsViewController_iPad"];
        
        // Check the folder can be supported actions or not.
        if (!_rootFile) {
            // if the view is first document view.
            NSString *driveGroup = [[_dicContentOfFolder allKeys] objectAtIndex:indexPath.section];
            newViewControllerForFilesBrowsing.actionVisibleOnFolder = [newViewControllerForFilesBrowsing supportActionsForItem:fileToBrowse ofGroup:driveGroup];
        } else {
            // support action for every folder which is not a drive.
            newViewControllerForFilesBrowsing.actionVisibleOnFolder = YES;
        }
        newViewControllerForFilesBrowsing.title = fileToBrowse.name;
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:newViewControllerForFilesBrowsing invokeByController:self isStackStartView:FALSE];
        
        [newViewControllerForFilesBrowsing release];
	}
	else
	{
         NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[fileToBrowse.path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
		DocumentDisplayViewController_iPad* contentViewController = [[DocumentDisplayViewController_iPad alloc] initWithNibAndUrl:@"DocumentDisplayViewController_iPad"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen
                                                                                             fileName:fileToBrowse.name];
		
        [[AppDelegate_iPad instance].rootViewController.stackScrollViewController addViewInSlider:contentViewController invokeByController:self isStackStartView:FALSE];
        
        [contentViewController release];
        
    }
}



#pragma mark - Panel Actions
-(void) showActionsPanelFromNavigationBarButton:(id)sender {
    if (_actionPopoverController.popoverVisible) {
        [_actionPopoverController dismissPopoverAnimated:YES];
        [_actionPopoverController release];
        _actionPopoverController = nil;
        return;
    }
    displayActionDialogAtRect = CGRectZero;
    
    //Create the fileActionsView controller
    FileActionsViewController* fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                            bundle:nil 
                                                            file:_rootFile 
                                                            enableDeleteThisFolder:YES
                                                            enableCreateFolder:YES
                                                            enableRenameFile:NO
                                                            delegate:self];
    
    fileToApplyAction = _rootFile;
    //Create the Popover to display potential actions to the user
    [_actionPopoverController dismissPopoverAnimated:NO];
    [_actionPopoverController release];
    _actionPopoverController = [[WEPopoverController alloc] initWithContentViewController:fileActionsViewController];
    //set its size
//	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
    //set its delegate
    _actionPopoverController.delegate = self;
    //present the popover from the rightBarButtonItem of the navigationBar
	[_actionPopoverController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem 
                                     permittedArrowDirections:UIPopoverArrowDirectionUp 
                                                     animated:YES];
    
    //Release the useless controller
    [fileActionsViewController release];
    
    //Prevent any new tap on the button
//    _navigation.topItem.rightBarButtonItem.enabled = YES;
}

-(void) hideActionsPanel {
    [super hideActionsPanel];
    //Enable the button on the navigationBar
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
    //Dismiss the popover
    [_actionPopoverController dismissPopoverAnimated:YES];
}


//SLM Temporary
-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    [super askToMakeFolderActions:createNewFolder];
    [_actionPopoverController dismissPopoverAnimated:YES];
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
    FileFolderActionsViewController_iPad *fileFolderActionsController = [[[FileFolderActionsViewController_iPad alloc] initWithNibName:@"FileFolderActionsViewController_iPad" bundle:nil] autorelease];
    //[_optionsViewController setDelegate:self];
    [fileFolderActionsController setIsNewFolder:createNewFolder];
    [fileFolderActionsController setNameInputStr:@""];
    [fileFolderActionsController setFocusOnTextFieldName];
    fileFolderActionsController.fileToApplyAction = fileToApplyAction;
    fileFolderActionsController.delegate = self;
    
    //Display the UIPopoverController
    if (!_fileFolderActionsPopoverController) {
        _fileFolderActionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileFolderActionsController];
        _fileFolderActionsPopoverController.delegate = self;
        [_fileFolderActionsPopoverController setPopoverContentSize:CGSizeMake(320, 140) animated:YES];        
    }
    _fileFolderActionsPopoverController.contentViewController = fileFolderActionsController;
    if(displayActionDialogAtRect.size.width == 0)
        [_fileFolderActionsPopoverController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    else
		[_fileFolderActionsPopoverController presentPopoverFromRect:displayActionDialogAtRect inView:_currentCell permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}



- (void)hideFileFolderActionsController {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [_fileFolderActionsPopoverController dismissPopoverAnimated:YES];
}


#pragma - UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    //Enable the button on the navigationBar
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
    
    //Release the _actionPopoverController
    [_actionPopoverController release];
    _actionPopoverController = nil;

}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}
 
- (void)showActionSheetForPhotoAttachment
{
    [_actionPopoverController dismissPopoverAnimated:YES];
 
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Localize(@"AddAPhoto")
                                                             delegate:self 
                                                    cancelButtonTitle:nil 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:Localize(@"TakeAPicture"), 
                                  Localize(@"PhotoLibrary"), nil];
    

    if(displayActionDialogAtRect.size.width == 0) {
        
        //present the popover from the rightBarButtonItem of the navigationBar        
//        [actionSheet showFromBarButtonItem:_navigation.topItem.rightBarButtonItem animated:YES];
        
        CGRect rect = [_navigation.topItem.rightBarButtonItem frameInView:self.view];
        rect.origin.x += 10;
        rect.origin.y += 20;
        rect.size.width = 0;
        rect.size.height = 0;
        NSLog(@"rect info %f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
        
        [actionSheet showFromRect:rect inView:self.view animated:YES];
    }
    else {
        [actionSheet showFromRect:displayActionDialogAtRect inView:_currentCell animated:YES];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];  
    [self.popoverPhotoLibraryController dismissPopoverAnimated:YES];
    _navigation.topItem.rightBarButtonItem.enabled = YES;
    
}

- (void)dismissAddPhotoPopOver:(BOOL)animation
{
    _navigation.topItem.rightBarButtonItem.enabled = YES;
}

//Test for rotation management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    //if the empty is, change rotate it
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview changeOrientation];
    }
}

# pragma mark - change language management
- (void) updateLabelsWithNewLanguage{
    [super updateLabelsWithNewLanguage];
    // Title of the view
    _navigation.topItem.title = Localize(@"Documents") ;
}

@end
