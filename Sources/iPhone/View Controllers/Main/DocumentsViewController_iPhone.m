//
//  DocumentsViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController_iPhone.h"
#import "DocumentDisplayViewController_iPhone.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "FileFolderActionsViewController_iPhone.h"
#import "UIBarButtonItem+WEPopover.h"
#import "LanguageHelper.h"
#import "FileActionsViewController.h"
#import "AppDelegate_iPhone.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"

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

-(void)viewDidLoad {
    [super viewDidLoad];
    //Try setting this to UIPopoverController to use the iPad popover. The API is exactly the same!
	//popoverClass = [WEPopoverController class];
    currentPopoverCellIndex = -1;
    
    self.view.title = self.title;
    
    
    //self.view.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;

    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationItem.rightBarButtonItem = self.navigationItem.rightBarButtonItem;
    
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
        self.title = _rootFile.fileName;
    } else {
        self.title = Localize(@"Documents");
    }
}

- (void)contentDirectoryIsRetrieved{
    [super contentDirectoryIsRetrieved];
    // not the root level
    if(![self.title isEqualToString:Localize(@"Documents")]){
        UIImage *image = [UIImage imageNamed:@"DocumentNavigationBarActionButton.png"];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bt setImage:image forState:UIControlStateNormal];
        bt.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [bt addTarget:self action:@selector(showActionsPanelFromNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithCustomView:bt];
        actionButton.width = image.size.width;
        //[self.view.navigationItem setRightBarButtonItem:actionButton];
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem setRightBarButtonItem:actionButton];        
        [actionButton release];
    }
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem.rightBarButtonItem.enabled = YES;
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
	File *fileToBrowse = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
	
	if(fileToBrowse.isFolder)
	{
        //Create a new FilesViewController_iPhone to push it into the navigationController
        DocumentsViewController_iPhone *newViewControllerForFilesBrowsing = [[DocumentsViewController_iPhone alloc] initWithRootFile:fileToBrowse withNibName:@"DocumentsViewController_iPhone"];
        
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView pushView:newViewControllerForFilesBrowsing.view animated:YES];
        //[self.navigationController pushViewController:newViewControllerForFilesBrowsing animated:YES];
        //[newViewControllerForFilesBrowsing release];
	}
	else
	{
		
        NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[URLAnalyzer enCodeURL:fileToBrowse.urlStr]];
		DocumentDisplayViewController_iPhone* fileWebViewController = [[DocumentDisplayViewController_iPhone alloc] 
                                                                       initWithNibAndUrl:@"DocumentDisplayViewController_iPhone"
                                                                                  bundle:nil 
                                                                                    url:urlOfTheFileToOpen
                                                                                fileName:fileToBrowse.fileName];
        
        [_hudFolder release];
        _hudFolder = nil;
        
        
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView pushView:fileWebViewController.view animated:YES];
		//[self.navigationController pushViewController:fileWebViewController animated:YES];    
        
        //[fileWebViewController release];
	}
	
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    UIButton *bt = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bt.tag inSection:0];
    if (self.popoverController) {
        self.popoverController = nil;
    } 
    
        FileActionsViewController *_actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                bundle:nil 
                                                file:[_arrayContentOfRootFile objectAtIndex:indexPath.row] 
                                                enableDeleteThisFolder:YES
                                                enableCreateFolder:NO
                                                enableRenameFile:YES
                                                delegate:self];
    
    fileToApplyAction = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
    

    CGRect frame = [_tblFiles cellForRowAtIndexPath:indexPath].frame;
    frame.origin.x += 300;
    NSLog(@"%@", NSStringFromCGRect(frame));
    
    //frame = [_tblFiles convertRect:_tblFiles.frame toView:self.view];
    self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:_actionsViewController] autorelease];
    
    [self.popoverController presentPopoverFromRect:frame 
                                            inView:_tblFiles 
                          permittedArrowDirections:UIPopoverArrowDirectionUp |UIPopoverArrowDirectionDown
                                          animated:YES];
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
        
        
    
    _actionsViewController.fileToApplyAction = _rootFile ;
    
    self.popoverClass = [[[WEPopoverController alloc] initWithContentViewController:_actionsViewController] autorelease];
    [_actionsViewController release];
    self.popoverClass.delegate = self;
    //self.popoverClass.passthroughViews = [NSArray arrayWithObject:[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView];
    
    [self.popoverClass presentPopoverFromBarButtonItem:[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem.rightBarButtonItem
                                   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
                                                   animated:YES];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem.rightBarButtonItem.enabled = NO;
}

-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    
    _fileFolderActionsController = [[FileFolderActionsViewController_iPhone alloc] initWithNibName:@"FileFolderActionsViewController_iPhone" bundle:nil];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.fileToApplyAction = fileToApplyAction;
    _fileFolderActionsController.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:_fileFolderActionsController];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:YES animated:YES];

    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone presentModalViewController:navController animated:YES];
    [navController release];
    
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}



-(void) hideActionsPanel {
    [super hideActionsPanel];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
}


- (void)hideFileFolderActionsController {
    [super hideFileFolderActionsController];
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone dismissModalViewControllerAnimated:YES];
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem.rightBarButtonItem.enabled = YES;
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:NO animated:YES];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<2) {
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
        thePicker.delegate = self;
            
        if(buttonIndex == 0)//Take a photo
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {  
                [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:YES animated:YES];

                UINavigationController *modalNavigationSettingViewController = [[UINavigationController alloc] initWithRootViewController:thePicker];
                modalNavigationSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone presentModalViewController:modalNavigationSettingViewController animated:YES];
                [modalNavigationSettingViewController release];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take a picture" message:@"Camera is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
        else
        {
            [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:YES animated:YES];
            
            thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone presentModalViewController:thePicker animated:YES];
        }
        [thePicker release];
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];  
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    
    [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView setNavigationBarHidden:NO animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = YES;

    //Dismiss all popover
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
    
    [AppDelegate_iPhone instance].homeSidebarViewController_iPhone.revealView.contentView.navigationBar.topItem.rightBarButtonItem.enabled = YES;

}




@end
