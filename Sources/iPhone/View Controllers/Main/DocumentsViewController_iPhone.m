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

-(void)viewDidLoad {
    [super viewDidLoad];
    //Try setting this to UIPopoverController to use the iPad popover. The API is exactly the same!
	//popoverClass = [WEPopoverController class];
    currentPopoverCellIndex = -1;
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
        [self.navigationItem setRightBarButtonItem:actionButton];
        
        [actionButton release];
    }
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
        [self.navigationController pushViewController:newViewControllerForFilesBrowsing animated:YES];
        [newViewControllerForFilesBrowsing release];
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
        
		[self.navigationController pushViewController:fileWebViewController animated:YES];    
        
        [fileWebViewController release];
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
                                            inView:self.view 
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
    self.popoverClass.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
    
    [self.popoverClass presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem 
                                   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
                                                   animated:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    _fileFolderActionsController = [[FileFolderActionsViewController_iPhone alloc] initWithNibName:@"FileFolderActionsViewController_iPhone" bundle:nil];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.fileToApplyAction = fileToApplyAction;
    _fileFolderActionsController.delegate = self;
    
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
    
    [self.navigationController pushViewController:_fileFolderActionsController animated:YES];
}



-(void) hideActionsPanel {
    [super hideActionsPanel];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
}


- (void)hideFileFolderActionsController {
    [super hideFileFolderActionsController];
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

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex < 2)
//    {
//        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
//        thePicker.delegate = self;
//        thePicker.allowsEditing = YES;
//        
//        if(buttonIndex == 0)//Take a photo
//        {
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
//            {  
//                thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                [self presentModalViewController:thePicker animated:YES];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Take a picture" message:@"Camera is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//                [alert release];
//            }
//        }
//        else
//        {
//            thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self presentModalViewController:thePicker animated:YES];
//        }
//        [thePicker release];
//    }
//        
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo  
//{
//	UIImage* selectedImage = image;
//	NSData* imageData = UIImagePNGRepresentation(selectedImage);
//	
//	
//	if ([imageData length] > 0) 
//	{
//        NSString *imageName = [[editingInfo objectForKey:@"UIImagePickerControllerReferenceURL"] lastPathComponent];
//		
//        if(imageName == nil) {
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
//            NSString* tmp = [dateFormatter stringFromDate:[NSDate date]];
//            
//            //release the date formatter because, not needed after that piece of code
//            [dateFormatter release];
//            imageName = [NSString stringWithFormat:@"MobileImage_%@.png", tmp];
//            
//        }
//		
//		_stringForUploadPhoto = [_stringForUploadPhoto stringByAppendingFormat:@"/%@", imageName];
//		
//        //TODO Localize this string
//        [self showHUDWithMessage:Localize(@"SendImageToFolder")];
//        
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
//                                    [self methodSignatureForSelector:@selector(sendImageInBackgroundForDirectory:data:)]];
//        [invocation setTarget:self];
//        [invocation setSelector:@selector(sendImageInBackgroundForDirectory:data:)];
//        [invocation setArgument:&_stringForUploadPhoto atIndex:2];
//        [invocation setArgument:&imageData atIndex:3];
//        [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
//        
//	}
//    
//    [picker dismissModalViewControllerAnimated:YES];
//    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
//    
//}  

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];  
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

@end
