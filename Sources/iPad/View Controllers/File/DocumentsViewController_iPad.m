//
//  DocumentsViewController_iPad.m
//  eXoMobile
//
//  Created by Tran Hoai Son on 6/15/10.
//  Copyright 2010 home. All rights reserved.
//

#import "DocumentsViewController_iPad.h"
#import "LanguageHelper.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "FileActionsViewController.h"
#import "FileFolderActionsViewController_iPad.h"
#import "DocumentDisplayViewController_iPad.h"
#import "StackScrollViewController.h"
#import "LanguageHelper.h"
#import "EmptyView.h"

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
    [self.view addSubview:_tblFiles];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
    //Add the UIBarButtonItem for actions on the NavigationBar of the Controller
    if (_rootFile) {
        _navigation.topItem.title = _rootFile.name;
    } else {
        _navigation.topItem.title = Localize(@"Documents") ;
    }
}

- (CGRect)rectOfHeader:(int)width
{
    return CGRectMake(50.0, 11.0, width, kHeightForSectionHeader);
}


- (void)contentDirectoryIsRetrieved{
    [super contentDirectoryIsRetrieved];
    // not the root level
    if(!isRoot && self.actionVisibleOnFolder) {
        UIImage *image = [UIImage imageNamed:@"DocumentNavigationBarActionButton.png"];
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
    
    NSMutableArray *viewControllersStack = [AppDelegate_iPad instance].rootViewController.stackScrollViewController.viewControllersStack;
                                            
    int index = [viewControllersStack indexOfObject:self];
    if(index > 0) {
        DocumentsViewController *parentsController = [viewControllersStack objectAtIndex:index - 1];
        
        [self.view removeFromSuperview];
        [viewControllersStack removeObject:self];
        
        [parentsController startRetrieveDirectoryContent];        
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
    [super dealloc];
}


#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    UIButton *bt = (UIButton *)sender;
    //Retrieve in the button, the tag with information corresponding to the indexPath of the touched cell
    //Use Modulo to retrieve the section information.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bt.tag%1000 inSection:bt.tag/1000];
    
    NSArray *arrFileFolder = [[_dicContentOfFolder allValues] objectAtIndex:indexPath.section];
    fileToApplyAction = [arrFileFolder objectAtIndex:indexPath.row];
    
    FileActionsViewController* fileActionsViewController = 
            [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                    bundle:nil 
                                                    file:fileToApplyAction 
                                                    enableDeleteThisFolder:YES
                                                    enableCreateFolder:NO
                                                    enableRenameFile:YES
                                                    delegate:self];
    
    
    
    
    UITableViewCell *cell = [_tblFiles cellForRowAtIndexPath:indexPath];
    CGRect frame = cell.accessoryView.frame;
    frame.origin.x += 20;
    
    displayActionDialogAtRect = frame;

    
    //Display the UIPopoverController
	_actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    _actionPopoverController.delegate = self;
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
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
            newViewControllerForFilesBrowsing.actionVisibleOnFolder = [self supportActionsInFolder:fileToBrowse ofGroup:driveGroup];
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
    
    displayActionDialogAtRect = CGRectZero;
    
    //Create the fileActionsView controller
    FileActionsViewController* fileActionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                            bundle:nil 
                                                            file:_rootFile 
                                                            enableDeleteThisFolder:YES
                                                            enableCreateFolder:YES
                                                            enableRenameFile:NO
                                                            delegate:self];
    
    
    //Create the Popover to display potential actions to the user
    _actionPopoverController = [[UIPopoverController alloc] initWithContentViewController:fileActionsViewController];
    //set its size
	[_actionPopoverController setPopoverContentSize:CGSizeMake(240, 280) animated:YES];
    //set its delegate
    _actionPopoverController.delegate = self;
    //present the popover from the rightBarButtonItem of the navigationBar
	[_actionPopoverController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem 
                                     permittedArrowDirections:UIPopoverArrowDirectionUp 
                                                     animated:YES];
    
    //Release the useless controller
    [fileActionsViewController release];
    
    //Prevent any new tap on the button
    _navigation.topItem.rightBarButtonItem.enabled = NO;
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
    
    _fileFolderActionsController = [[FileFolderActionsViewController_iPad alloc] initWithNibName:@"FileFolderActionsViewController_iPad" bundle:nil];
    //[_optionsViewController setDelegate:self];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.fileToApplyAction = fileToApplyAction;
    _fileFolderActionsController.delegate = self;
    
    //Display the UIPopoverController
	_fileFolderActionsPopoverController = [[UIPopoverController alloc] initWithContentViewController:_fileFolderActionsController];
    _fileFolderActionsPopoverController.delegate = self;
	[_fileFolderActionsPopoverController setPopoverContentSize:CGSizeMake(320, 140) animated:YES];
    
    if(createNewFolder || displayActionDialogAtRect.size.width == 0)
        [_fileFolderActionsPopoverController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    else
		[_fileFolderActionsPopoverController presentPopoverFromRect:displayActionDialogAtRect inView:_tblFiles permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
    [_fileFolderActionsController release];


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
        [actionSheet showFromBarButtonItem:_navigation.topItem.rightBarButtonItem animated:YES];
    }
    else {
        [actionSheet showFromRect:displayActionDialogAtRect inView:_tblFiles animated:YES];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];  
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
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

@end
