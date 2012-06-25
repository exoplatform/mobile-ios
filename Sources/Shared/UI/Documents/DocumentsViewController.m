//
//  DocumentsViewController.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 29/08/11.
//  Copyright 2011 eXo Platform. All rights reserved.
//

#import "DocumentsViewController.h"
#import "CustomBackgroundForCell_iPhone.h"
#import "FileFolderActionsViewController_iPhone.h"
#import "LanguageHelper.h"
#import "NSString+HTML.h"
#import "DataProcess.h"
#import "EmptyView.h"
#import "defines.h"
#import "AppDelegate_iPhone.h"


#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


#pragma mark - Constants
static NSString *PERSONAL_GROUP = @"personal";
static NSString *SHARED_GROUP = @"group";
static NSString *PUBLIC_DRIVE = @"Public";
static NSString *PRIVATE_GROUP = @"Private";

#pragma mark -
#pragma mark Private

// =================================
// = Interface for private methods
// =================================
@interface DocumentsViewController (PrivateMethods)

- (void)startRetrieveDirectoryContent;
- (void)setTitleForFilesViewController;
- (void)contentDirectoryIsRetrieved;
- (void)hideActionsPanel;
- (void)hideFileFolderActionsController;

@end



#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for FilesViewController_iPhone
// ================================
@implementation DocumentsViewController

@synthesize parentController = _parentController, isRoot;
@synthesize actionVisibleOnFolder = _actionVisibleOnFolder;
@synthesize popoverPhotoLibraryController = _popoverPhotoLibraryController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isRoot = NO;
        stop = NO;
        
    }
    return self;
}



- (id) initWithRootFile:(File *)rootFile withNibName:(NSString *)nibName  {
    if ((self = [self initWithNibName:nibName bundle:nil])) {
        //Set the rootFile 
        _rootFile = [rootFile retain];
    }
    return self;
}

- (void)createTableViewWithStyle:(UITableViewStyle)style {

    CGRect rectOfSelf = self.view.frame;
    CGRect rectForTableView = CGRectMake(0, 0, rectOfSelf.size.width, rectOfSelf.size.height - 44);

    _tblFiles = [[UITableView alloc] initWithFrame:rectForTableView style:style];
    _tblFiles.delegate = self;
    _tblFiles.dataSource = self;
    _tblFiles.backgroundColor = EXO_BACKGROUND_COLOR;
    [_tblFiles setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tblFiles];
}

-(void)stopRetrieveData{
    stop = YES;
}

// =====================================
// = Implementation of private methods
// =====================================

-(void)startRetrieveDirectoryContent {
    
    NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
//    
    if (_filesProxy == nil) _filesProxy = [FilesProxy sharedInstance];
    [_dicContentOfFolder removeAllObjects];
    
    if (_rootFile == nil) {
        
        NSArray *personalDrives = [_filesProxy getDrives:PERSONAL_GROUP];
        NSArray *sharedDrives = [_filesProxy getDrives:SHARED_GROUP];
        
        if([personalDrives count] > 0)
            [_dicContentOfFolder setValue:[personalDrives copy] forKey:PERSONAL_GROUP];
        
        if([sharedDrives count] > 0)
            [_dicContentOfFolder setValue:[sharedDrives copy] forKey:SHARED_GROUP];
        
    }
    else {
                
        NSArray *folderContet = [_filesProxy getContentOfFolder:_rootFile];
        if([folderContet count] > 0)
            [_dicContentOfFolder setValue:[folderContet copy] forKey:_rootFile.name];
    }
    
    [pool release];
    
    if(stop){
        return;
    }
    
    //Call in the main thread update method
    [self performSelectorOnMainThread:@selector(contentDirectoryIsRetrieved) withObject:nil waitUntilDone:NO];
}

- (void)contentDirectoryIsRetrieved {
    _tblFiles.scrollEnabled = YES;
    //Add the "Actions" button
    
    
    //if the empty is, remove it
    EmptyView *emptyview = (EmptyView *)[self.view viewWithTag:TAG_EMPTY];
    if(emptyview != nil){
        [emptyview removeFromSuperview];
    }
    
    [self hideLoader:YES];
    
    //check if no data
    if([_dicContentOfFolder count] == 0){
        [self performSelector:@selector(emptyState) withObject:nil afterDelay:1.0];
    }
    //And finally reload the content of the tableView
    [_tblFiles reloadData];
}

// Empty State
-(void)emptyState {
    //disable scroll in tableview
    _tblFiles.scrollEnabled = NO;
    //add empty view to the view    
    EmptyView *emptyView = [[EmptyView alloc] initWithFrame:self.view.bounds withImageName:@"IconForEmptyFolder.png" andContent:Localize(@"EmptyFolder")];
    emptyView.tag = TAG_EMPTY;
    [_tblFiles addSubview:emptyView];
    [emptyView release];
}

- (void)hideActionsPanel{
    _tblFiles.scrollEnabled = NO;
}

- (void)setTitleForFilesViewController{
    
}

- (void)hideFileFolderActionsController {
    [_fileFolderActionsController release]; _fileFolderActionsController = nil;
}

- (BOOL)supportActionsForItem:(File *)item ofGroup:(NSString *)driveGroup {
    /*
     This method is installed as a workaround for bug about action buttons on drive folders. 
     A folder is not action-able if: 
        + Its currentFolder is empty or nil.
     */
    NSMutableArray *exceptDrives = [NSMutableArray array];
    if ([driveGroup isEqualToString:PERSONAL_GROUP] && !isRoot) {
        // For public drive of personal group, action is supported when view its detail.
        [exceptDrives addObject:PUBLIC_DRIVE];
    }
    if ([item isFolder]) {
        NSString *currentfolder = [item currentFolder];
        if (!currentfolder || [currentfolder length] == 0) {
            if ([exceptDrives containsObject:[item name]]) {
                return YES;
            }
            return NO; 
        } else {
            return YES;
        }
    } else {
        // actions are always supported for files.
        return YES;
    }
    return NO;
}

- (void)dealloc
{
     
    [_dicContentOfFolder release];
    _dicContentOfFolder = nil;
    
    //Release the FileProxy of the Controller.
    _filesProxy = nil;
    
    //Release the rootFile
    [_rootFile release];
    _rootFile = nil;
    
    //Release the content of rootFile
    [_arrayContentOfRootFile release];
    _arrayContentOfRootFile = nil;
    
    _stringForUploadPhoto = nil;
    
    [_tblFiles release];
    _tblFiles = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - HUD Management

-(void)updateHudPosition {
    //default implementation
    //do nothing
    NSArray *visibleCells  = [_tblFiles visibleCells];
    CGRect rect = CGRectZero;
    for (int n = 0; n < [visibleCells count]; n ++){
        UITableViewCell *cell = [visibleCells objectAtIndex:n];
        if(n == 0){
            rect.origin.y = cell.frame.origin.y;
            rect.size.width = cell.frame.size.width;
        }
        rect.size.height += cell.frame.size.height;
    }
    self.hudLoadWaiting.center = CGPointMake(self.view.frame.size.width/2, (((rect.size.width)/2 + rect.origin.y) <= self.view.frame.size.height) ? self.view.frame.size.height/2 : ((rect.size.height)/2 + rect.origin.y));
}


- (void)showActionSheetForPhotoAttachment {
    
}

- (UINavigationBar *)navigationBar
{
    return _navigation;    
}

- (NSString *)stringForUploadPhoto
{
    return _stringForUploadPhoto;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_rootFile == nil)
        [self createTableViewWithStyle:UITableViewStyleGrouped];
    else
        [self createTableViewWithStyle:UITableViewStylePlain];
    
    _dicContentOfFolder = [[NSMutableDictionary alloc] init];
    
	[self.view addSubview:self.hudLoadWaiting.view];
    
    //Set the background Color of the view
    //_tblFiles.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgGlobal.png"]] autorelease];
    //_tblFiles.backgroundColor = EXO_BACKGROUND_COLOR;
    /*
    UIView *background = [[UIView alloc] initWithFrame:self.view.frame];
    background.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgGlobal.png"]];
    _tblFiles.backgroundView = background;
    [background release];
     */  

//  [[NSNotificationCenter defaultCenter] addObserver:self 
//                                           selector:@selector(updateData:)        
//                                               name:@"updateData" 
//                                             object:nil];
    
    
    //Hack for the tableview backgroung
    [_tblFiles setBackgroundView:nil];
    [_tblFiles setBackgroundView:[[[UIView alloc] init] autorelease]];
  
    if (_rootFile) {
        self.title = _rootFile.name;
    } else {
        self.title = Localize(@"Documents");
    }
    
    //Set the title of the view controller
    [self setTitleForFilesViewController];
    
    if (_arrayContentOfRootFile == nil) {
        //TODO Localize this string
        [self displayHudLoader];
        
        //Start the request to load file content
        [self performSelectorInBackground:@selector(startRetrieveDirectoryContent) withObject:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    //Release the loader
//    [_hudFolder hide];
//    _hudFolder = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGRect)rectOfHeader:(int)width
{
    return CGRectMake(25.0, 11.0, width, kHeightForSectionHeader);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_dicContentOfFolder) {
        return [_dicContentOfFolder count];
    }
    
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([_dicContentOfFolder count] > 1)
        return kHeightForSectionHeader;
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([_dicContentOfFolder count] <= 1)
        return nil;
        
    // create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 10.0, _tblFiles.frame.size.width-5, kHeightForSectionHeader)];
	
	// create the label object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1];
	headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    headerLabel.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    headerLabel.shadowOffset = CGSizeMake(0,1);
    headerLabel.textAlignment = UITextAlignmentCenter;

    headerLabel.text = [[_dicContentOfFolder allKeys] objectAtIndex:section];
    
    CGSize theSize = [headerLabel.text sizeWithFont:headerLabel.font constrainedToSize:CGSizeMake(_tblFiles.frame.size.width-5, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    if(theSize.width > _tblFiles.frame.size.width - 20)
        theSize.width = _tblFiles.frame.size.width - 50;
    
    headerLabel.frame = [self rectOfHeader:theSize.width];
    
    //Retrieve the image depending of the section
    UIImage *imgForSection = [UIImage imageNamed:@"DashboardTabBackground.png"];
    UIImageView *imgVBackground = [[UIImageView alloc] initWithImage:[imgForSection stretchableImageWithLeftCapWidth:10 topCapHeight:7]];
    imgVBackground.frame = CGRectMake(headerLabel.frame.origin.x - 10, 16.0, theSize.width + 20, kHeightForSectionHeader-15);
    
	[customView addSubview:imgVBackground];
    [imgVBackground release];
    
    [customView addSubview:headerLabel];
    [headerLabel release];
    
	return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[_dicContentOfFolder allValues] objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCellIdentifier = @"CellIdentifierForFiles";
    

    CustomBackgroundForCell_iPhone *cell =  (CustomBackgroundForCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(cell == nil) {
        cell = [[[CustomBackgroundForCell_iPhone alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        
        //Configure font for the cell
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        //cell.textLabel.contentMode = UIViewAutoresizingFlexibleWidth;
    }

    //Customize the cell background
    [cell setBackgroundForRow:indexPath.row inSectionSize:[self tableView:tableView numberOfRowsInSection:indexPath.section]];


    //Retrieve the correct file corresponding to the indexPath
    File *file = [[[_dicContentOfFolder allValues] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *driveGroup = [[_dicContentOfFolder allKeys] objectAtIndex:indexPath.section];
    if ([self supportActionsForItem:file ofGroup:driveGroup]) {
        //Add action button
        UIImage *image = [UIImage imageNamed:@"DocumentDisclosureActionButton"];
        UIButton *buttonAccessory = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonAccessory setImage:image forState:UIControlStateNormal];  
        [buttonAccessory setImage:image forState:UIControlStateHighlighted];
        
        //Provide to the button, the tag corresponding to the indexPath
        //Use Modulo to provide the section information.
        buttonAccessory.tag = 1000 * indexPath.section + indexPath.row;
        
        //Increase the size of the button, to make it easier to touch
        buttonAccessory.frame = CGRectMake(0, 0, 50.0, 50.0);
        
        buttonAccessory.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [buttonAccessory addTarget:self action:@selector(buttonAccessoryClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = buttonAccessory;
    } else {
        // Remove action button if the folder does not have actions for user.
        cell.accessoryView = nil;
    }
    //Configure the cell content
    //Determine and set the correct image for the file
    if(file.isFolder){
        cell.imageView.image = [UIImage imageNamed:@"DocumentIconForFolder"];
    } else{
        cell.imageView.image = [UIImage imageNamed:[File fileType:file.nodeType]];
    }
    
    //Set the file name
    cell.textLabel.text = [URLAnalyzer decodeURL:file.name]; 
    
    
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //Set the background color of the cell, as the tableView is manually created.
    cell.backgroundColor = [UIColor clearColor];
}


#pragma Button Click
- (void)buttonAccessoryClick:(id)sender{
    
}

- (void)deleteCurentFileView {
    
}

- (void)showImagePickerForAddPhotoAction:(UIImagePickerController *)picker {
    
}

#pragma mark - FileAction delegate Methods


- (void)showErrorForFileAction:(NSString *)errorMessage {
    [self hideLoader:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"FileError") message:errorMessage delegate:self 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}

//Use this method to do the delete action in a background thread
-(void)deleteFileInBackground:(NSString *)urlFileToDelete {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForDelete source:urlFileToDelete destination:nil data:nil];
    
    //check the status of the operation
    if (errorMessage) {
        //On main thread, as to send the AlertView
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
        return;
    }
    
    if([urlFileToDelete isEqualToString:_rootFile.path]) {
        [self deleteCurentFileView];
    }
    else
        [self startRetrieveDirectoryContent];
    
}

//Method needed to retrieve the delete action
-(void)deleteFile:(NSString *)urlFileToDelete {
        
    //TODO Localize this string
    [self displayHudLoader];
    
    //Hide the action Panel
    [self hideActionsPanel];
    //NSLog(@"%@", urlFileToDelete);
    [self performSelectorInBackground:@selector(deleteFileInBackground:) withObject:urlFileToDelete];
}

-(void)moveOrCopyActionIsSelected {
    [self hideActionsPanel];
}


//Use this method to do the move action in a background thread
- (void)moveFileInBackgroundSource:(NSString *)urlSource
                     toDestination:(NSString *)urlDestination {
    
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForMove source:urlSource destination:urlDestination data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}


//Method needed to retrieve the action to move a file
- (void)moveFileSource:(NSString *)urlSource
         toDestination:(NSString *)urlDestination {
    //Hide the action Panel
    [self hideActionsPanel];
    
    //TODO Localize this string
    [self displayHudLoader];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(moveFileInBackgroundSource:toDestination:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(moveFileInBackgroundSource:toDestination:)];
    [invocation setArgument:&urlSource atIndex:2];
    [invocation setArgument:&urlDestination atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO];
}

//Use this method to do the copy action in a background thread
- (void)copyFileInBackgroundSource:(NSString *)urlSource
                     toDestination:(NSString *)urlDestination {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForCopy source:urlSource destination:urlDestination data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}


//Method needed to retrieve the action to copy a file
- (void)copyFileSource:(NSString *)urlSource
         toDestination:(NSString *)urlDestination {
    //TODO Localize this string
    [self displayHudLoader];
    
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                [self methodSignatureForSelector:@selector(copyFileInBackgroundSource:toDestination:)]];
    [invocation setTarget:self];
    [invocation setSelector:@selector(copyFileInBackgroundSource:toDestination:)];
    [invocation setArgument:&urlSource atIndex:2];
    [invocation setArgument:&urlDestination atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 
    
}

-(void)askToAddPhoto:(NSString*)url
{
    _stringForUploadPhoto = url;
    [self showActionSheetForPhotoAttachment];
}

- (void)askToAddAPicture:(NSString *)urlDestination photoAlbum:(BOOL)photoAlbum {
    
    _stringForUploadPhoto = urlDestination;
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    
    if (photoAlbum) 
	{  
        thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
	else
	{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakePicture")  message:Localize(@"CameraNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            [thePicker release];
            thePicker = nil;
        }
	}

    if(thePicker) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            //[self.navigationController presentModalViewController:thePicker animated:YES];  
            [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone presentModalViewController:thePicker animated:YES];
        }
        else {
            
            thePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            thePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            thePicker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            self.popoverPhotoLibraryController = [[[UIPopoverController alloc] initWithContentViewController:thePicker] autorelease];
            self.popoverPhotoLibraryController.delegate = self;
            [self.popoverPhotoLibraryController setPopoverContentSize:CGSizeMake(320, 320) animated:YES];
            

            if(displayActionDialogAtRect.size.width == 0) {
                
                //present the popover from the rightBarButtonItem of the navigationBar
                [self.popoverPhotoLibraryController presentPopoverFromBarButtonItem:_navigation.topItem.rightBarButtonItem 
                                                 permittedArrowDirections:UIPopoverArrowDirectionUp 
                                                                 animated:YES];
             

            }
            else {
                [self.popoverPhotoLibraryController presentPopoverFromRect:displayActionDialogAtRect inView:_tblFiles permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];    
                
            }
                
            displayActionDialogAtRect = CGRectZero;
        }
        
        [thePicker release];
        
    }
    
    [self hideActionsPanel];
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}



#pragma mark - FileFolderAction delegate Methods

//Use this method to do the copy action in a background thread
- (void)createNewFolderInBackground:(NSString *)urlSource {
    
    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForCreateFolder source:urlSource destination:@"" data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}

- (BOOL)nameContainSpecialCharacter:(NSString*)str inSet:(NSString *)chars {
    NSCharacterSet *invalidCharSet = [NSCharacterSet characterSetWithCharactersInString:chars];
    
    NSRange range = [str rangeOfCharacterFromSet:invalidCharSet];
    
    return (range.length > 0); 
}

//Method needed to call to create a new folder
-(void)createNewFolder:(NSString *)newFolderName {
    
    [self hideFileFolderActionsController];
    
    BOOL bExist = NO;
    if([newFolderName length] > 0)
    {
        
        //Check if server name or url contains special chars
        if ([self nameContainSpecialCharacter:newFolderName inSet:SPECIAL_CHAR_NAME_SET]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"SpecialCharacters") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return;
        }

        NSArray *arrFileFolder = nil;
        if([[_dicContentOfFolder allValues] count] > 0)
            arrFileFolder = [[_dicContentOfFolder allValues] objectAtIndex:0];
        
        for (File* file in arrFileFolder) {
            if([newFolderName isEqualToString:file.name])
            {
                bExist = YES;
                                
                UIAlertView* alert = [[UIAlertView alloc] 
                                      initWithTitle:Localize(@"Info Message")
                                      message: Localize(@"FolderNameAlreadyExist")
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                break;
            }
        }
        
        if (!bExist) 
        {
            //TODO Localize this string
            [self displayHudLoader];
            if(!_rootFile.isFolder) {
                newFolderName = [newFolderName stringByEncodingHTMLEntities];
                newFolderName = [DataProcess encodeUrl:newFolderName];
            }
            
            NSString* strNewFolderPath = [FilesProxy urlForFileAction:[_rootFile.path stringByAppendingPathComponent:newFolderName]];
            NSLog(@"%@", strNewFolderPath);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(createNewFolderInBackground:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(createNewFolderInBackground:)];
            [invocation setArgument:&strNewFolderPath atIndex:2];
            [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 

        }
    }
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc] 
                              initWithTitle:Localize(@"Info Message")
                              message: Localize(@"FolderNameEmpty")
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

//Method to call the rename action of the proxy
- (void)renameFolderInBackground:(NSString *)newFolderUrl forFolder:(NSString *)folderToRenameUrl {

    NSString *errorMessage = [_filesProxy fileAction:kFileProtocolForMove source:folderToRenameUrl destination:newFolderUrl data:nil];
    
    //Hide the action Panel
    [self hideActionsPanel];
    
    //check the status of the operation
    if (errorMessage) {
        [self performSelectorOnMainThread:@selector(showErrorForFileAction:) withObject:errorMessage waitUntilDone:NO];
    }
    
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
    
}


//Method needed to rename a folder
-(void)renameFolder:(NSString *)newFolderName forFolder:(File *)folderToRename {
    
    [self hideFileFolderActionsController];
    
    
    if([newFolderName length] > 0)
    {
        
        //Check if server name or url contains special chars
        if ([self nameContainSpecialCharacter:newFolderName inSet:SPECIAL_CHAR_NAME_SET]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:Localize(@"MessageInfo") message:Localize(@"SpecialCharacters") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
            return;
        }

        
        BOOL bExist = NO;
        
        NSArray *arrFileFolder = nil;
        if([[_dicContentOfFolder allValues] count] > 0)
            arrFileFolder = [[_dicContentOfFolder allValues] objectAtIndex:0];

        
        for (File* file in arrFileFolder) {
            if([newFolderName isEqualToString:file.name])
            {
                bExist = YES;
                
                UIAlertView* alert = [[UIAlertView alloc] 
                                      initWithTitle:Localize(@"Info Message")
                                      message: Localize(@"FolderNameAlreadyExist")
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];

                
                break;
            }
        }
        if (!bExist) 
        {
            //TODO Localize this string
            [self displayHudLoader];
            if(!_rootFile.isFolder) {
                newFolderName = [newFolderName stringByEncodingHTMLEntities];
                newFolderName = [DataProcess encodeUrl:newFolderName];
            }
            
            NSString *strRenamePath = [FilesProxy urlForFileAction:[_rootFile.path stringByAppendingPathComponent:newFolderName]];
            NSString *strSource = [FilesProxy urlForFileAction:folderToRename.path];

            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [self methodSignatureForSelector:@selector(renameFolderInBackground:forFolder:)]];
            [invocation setTarget:self];
            [invocation setSelector:@selector(renameFolderInBackground:forFolder:)];
            [invocation setArgument:&strRenamePath atIndex:2];
            [invocation setArgument:&strSource atIndex:3];
            [NSTimer scheduledTimerWithTimeInterval:0.1f invocation:invocation repeats:NO]; 
            
        }
    }
    else 
    {
        UIAlertView* alert = [[UIAlertView alloc] 
                              initWithTitle:Localize(@"Info Message")
                              message: Localize(@"FolderNameEmpty")
                              delegate:self 
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}



//Method needed when the Controller must be hidden
-(void)cancelFolderActions {
    
    [self hideFileFolderActionsController];
    
}

-(void)askToMakeFolderActions:(BOOL)createNewFolder{
    //[self showHUDWithMessage:Localize(@"CreateNewFolder")];
}



#pragma mark - Pictures Management


- (void)sendImageInBackgroundForDirectory:(NSString *)directory data:(NSData *)imageData
{
    [_filesProxy fileAction:kFileProtocolForUpload source:directory destination:nil data:imageData];
    //Need to reload the content of the folder
    [self startRetrieveDirectoryContent];
}


#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < 2)
    {
        UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
        thePicker.delegate = self;
//        thePicker.allowsEditing = YES;
        
        if(buttonIndex == 0)//Take a photo
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
            {  
                thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
        }
        
        [self showImagePickerForAddPhotoAction:thePicker];
        [thePicker release];
    }
    
}


#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    [self.popoverPhotoLibraryController dismissPopoverAnimated:YES];
    self.popoverPhotoLibraryController = nil;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [[AppDelegate_iPhone instance].homeSidebarViewController_iPhone setContentNavigationBarHidden:NO animated:YES];
    }
    
    // Display HUD loading
    [self displayHudLoader];
    
    UIImage* selectedImage = image;
    
    dispatch_queue_t uploadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(uploadQueue, ^(void) {
        NSData* imageData = UIImagePNGRepresentation(selectedImage);
        
        if ([imageData length] > 0) 
        {
            NSString *imageName = [[editingInfo objectForKey:UIImagePickerControllerReferenceURL] lastPathComponent];
            
            if(imageName == nil) {
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
                NSString* tmp = [dateFormatter stringFromDate:[NSDate date]];
                
                //release the date formatter because, not needed after that piece of code
                [dateFormatter release];
                imageName = [NSString stringWithFormat:@"MobileImage_%@.png", tmp];
                
            }
            
            _stringForUploadPhoto = [_stringForUploadPhoto stringByAppendingFormat:@"/%@", imageName];
            [self sendImageInBackgroundForDirectory:_stringForUploadPhoto data:imageData];
        }
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self hideLoader:YES]; 
        });
    });
    
    dispatch_release(uploadQueue);
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker  
{  
    [picker dismissModalViewControllerAnimated:YES];  
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

@end
