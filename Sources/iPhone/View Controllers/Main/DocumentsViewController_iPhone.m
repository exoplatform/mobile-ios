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

#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333

#import "UIBarButtonItem+WEPopover.h"
#import "LanguageHelper.h"

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
    [_actionsViewController release];
    _actionsViewController = nil;
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

#pragma mark - UINavigationBar Management

- (void)setTitleForFilesViewController {
    if (_rootFile) {
        self.title = _rootFile.fileName;
    } else {
        self.title = Localize(@"Documents");
    }
}
/**
 Thanks to Paul Solt for supplying these background images and container view properties
 */
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

#pragma mark -
#pragma mark WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
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


//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    UIButton *bt = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:bt.tag inSection:0];
    if (self.popoverController) {
        self.popoverController = nil;
    } 
    
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                             bundle:nil 
                                                                               file:[_arrayContentOfRootFile objectAtIndex:indexPath.row] 
                                                             enableDeleteThisFolder:YES
                                                                           delegate:self];
    }
    _actionsViewController.fileToApplyAction = [_arrayContentOfRootFile objectAtIndex:indexPath.row] ;
    CGRect frame = [_tblFiles cellForRowAtIndexPath:indexPath].frame;
    frame.origin.x += 300;
    
    self.popoverController = [[[WEPopoverController alloc] initWithContentViewController:_actionsViewController] autorelease];
    [self.popoverController presentPopoverFromRect:frame 
                                            inView:_tblFiles 
                          permittedArrowDirections:UIPopoverArrowDirectionRight|UIPopoverArrowDirectionLeft
                                          animated:YES];
}

#pragma mark - Panel Actions

-(void) showActionsPanelFromNavigationBarButton:(id)sender {
    
    displayActionDialogAtRect = CGRectZero;
    
    if (self.popoverClass) {
        [self.popoverClass dismissPopoverAnimated:YES];
        self.popoverClass = nil;
        _tblFiles.scrollEnabled = NO;
        return;
    } 
    //Check if the _actionsViewController is already created or not
    if (_actionsViewController == nil) {
        
        _actionsViewController = [[FileActionsViewController alloc] initWithNibName:@"FileActionsViewController" 
                                                                             bundle:nil 
                                                                               file:_rootFile 
                                                             enableDeleteThisFolder:YES
                                                                           delegate:self];
        
        
    }
    
    _actionsViewController.fileToApplyAction = _rootFile ;
    
    self.popoverClass = [[[WEPopoverController alloc] initWithContentViewController:_actionsViewController] autorelease];
    self.popoverClass.delegate = self;
    self.popoverClass.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
    
    [self.popoverClass presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem 
                                   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
                                                   animated:YES];
    _tblFiles.scrollEnabled = NO;
}

-(void)askToMakeFolderActions:(BOOL)createNewFolder {
    _fileFolderActionsController = [[FileFolderActionsViewController_iPhone alloc] initWithNibName:@"FileFolderActionsViewController_iPhone" bundle:nil];
    //[_optionsViewController setDelegate:self];
    [_fileFolderActionsController setIsNewFolder:createNewFolder];
    [_fileFolderActionsController setNameInputStr:@""];
    [_fileFolderActionsController setFocusOnTextFieldName];
    _fileFolderActionsController.fileToApplyAction = _actionsViewController.fileToApplyAction;
    _fileFolderActionsController.delegate = self;
    
    //_optionsViewController.view.hidden = YES;
    [self.view addSubview:_fileFolderActionsController.view];
    [_actionsViewController.view removeFromSuperview]; 
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
}



-(void) hideActionsPanel {
    [_actionsViewController.view removeFromSuperview];
    _tblFiles.scrollEnabled = YES;
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    [self.popoverClass dismissPopoverAnimated:YES];
    self.popoverClass = nil;
}


- (void)hideFileFolderActionsController {
    _tblFiles.scrollEnabled = YES;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 2)
    {
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
        thePicker.delegate = self;
        thePicker.allowsEditing = YES;
        
        if(buttonIndex == 0)//Take a photo
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {  
                thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:thePicker animated:YES];
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
            thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentModalViewController:thePicker animated:YES];
        }
        [thePicker release];
    }
        
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo  
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
		
		_stringForUploadPhoto = [_stringForUploadPhoto stringByAppendingFormat:@"/%@", imageName];
		
        //TODO Localize this string
        [self showHUDWithMessage:Localize(@"SendImageToFolder")];
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(sendImageInBackgroundForDirectory:data:)]];
        [invocation setTarget:self];
        [invocation setSelector:@selector(sendImageInBackgroundForDirectory:data:)];
        [invocation setArgument:&_stringForUploadPhoto atIndex:2];
        [invocation setArgument:&imageData atIndex:3];
        [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
        
	}
    
    [picker dismissModalViewControllerAnimated:YES];
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    
}  

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];  
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

@end
