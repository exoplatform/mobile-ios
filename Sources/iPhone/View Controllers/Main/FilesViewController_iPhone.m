//
//  FilesViewController_iPhone.m
//  eXo Platform
//
//  Created by Stévan Le Meur on 22/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilesViewController_iPhone.h"
#import "eXoWebViewController.h"

#define kTagForCellSubviewTitleLabel 222
#define kTagForCellSubviewImageView 333


#pragma mark -
#pragma mark Private

// =================================
// = Interface for private methods
// =================================
@interface FilesViewController_iPhone (PrivateMethods)

- (void)startRetrieveDirectoryContent;
- (void)setTitleForFilesViewController;

@end


// =====================================
// = Implementation of private methods
// =====================================

@implementation FilesViewController_iPhone (PrivateMethods)

-(void)startRetrieveDirectoryContent {
    
    if (_filesProxy == nil) _filesProxy = [[FilesProxy alloc] init];
    
    if (_rootFile == nil) _rootFile = [_filesProxy initialFileForRootDirectory];
    
    _arrayContentOfRootFile = [_filesProxy getPersonalDriveContent:_rootFile];
    
    [self.tableView reloadData];
    
}


- (void)setTitleForFilesViewController {
    if (_rootFile) {
        self.title = _rootFile.fileName;
    } else {
        self.title = @"Documents";
    }
}


@end



#pragma mark -
#pragma mark Implementation

// ================================
// = Implementation for FilesViewController_iPhone
// ================================
@implementation FilesViewController_iPhone


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


//Use this method to init the Controller with a root file
- (id) initWithRootFile:(File *)rootFile {
    if ((self = [super initWithNibName:@"FilesViewController_iPhone" bundle:nil])) {
        //Set the rootFile 
        _rootFile = [rootFile retain];
    }
    return self;
}


- (void)dealloc
{
    //Release the FileProxy of the Controller.
    [_filesProxy release];
    _filesProxy = nil;
    
    //Release the rootFile
    [_rootFile release];
    _rootFile = nil;
    
    //Release the content of rootFile
    [_arrayContentOfRootFile release];
    _arrayContentOfRootFile = nil;
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //Set the title of the view controller
    [self setTitleForFilesViewController];
        
    
    //Start the request to load file content
    [self startRetrieveDirectoryContent];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50.0;
}

// tell our table how many rows it will have, in our case the size of our menuList
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [_arrayContentOfRootFile count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *kCellIdentifier = @"CellIdentifierForFiles";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if(cell == nil) {
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kCellIdentifier] autorelease];
            
            UIImageView* imgViewFile = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 40, 40)];
            cell.tag = kTagForCellSubviewImageView;
            [cell addSubview:imgViewFile];
            [imgViewFile release];
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 13.0, 200.0, 20.0)];
            titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            titleLabel.tag = kTagForCellSubviewTitleLabel;
            [cell addSubview:titleLabel];
            [titleLabel release];
            
            UIButton *btnFileAction = [[UIButton alloc] initWithFrame:CGRectMake(285.0, 9, 30, 30)];
            [btnFileAction setBackgroundImage:[UIImage imageNamed:@"action.png"] forState:UIControlStateNormal];
            [btnFileAction addTarget:self action:@selector(fileAction:) forControlEvents:UIControlEventTouchUpInside];
            btnFileAction.tag = indexPath.row;
            [cell addSubview:btnFileAction];
            [btnFileAction release];
            
        }
        
        File *file = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
        
        
        UIImageView* imgViewFile = (UIImageView*)[cell viewWithTag:kTagForCellSubviewImageView];
        if(file.isFolder)
            imgViewFile.image = [UIImage imageNamed:@"folder.png"];
        else
            imgViewFile.image = [UIImage imageNamed:[File fileType:file.fileName]];
        
        
        UILabel *titleLabel = (UILabel*)[cell viewWithTag:kTagForCellSubviewTitleLabel];
        titleLabel.text = file.fileName;
    
    
        
    /*
        
        if (imgViewEmptyPage == nil) {
            imgViewEmptyPage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
            imgViewEmptyPage.image = [UIImage imageNamed:@"emptypage.png"];
            
            labelEmptyPage = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, 320, 40)];
            labelEmptyPage.backgroundColor = [UIColor clearColor];
            labelEmptyPage.textAlignment = UITextAlignmentCenter;
            labelEmptyPage.text = [_delegate._dictLocalize objectForKey:@"EmptyPage"];
            [imgViewEmptyPage addSubview:labelEmptyPage];
            [self addSubview:imgViewEmptyPage];
            
            imgViewEmptyPage.hidden = YES;
        }
      */  
        
        return cell;
    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	//NSThread *startThread = [[NSThread alloc] initWithTarget:self selector:@selector(startInProgress) object:nil];
	//[startThread start];
	
    //Retrieve the File corresponding to the selected Cell
	File *fileToBrowse = [_arrayContentOfRootFile objectAtIndex:indexPath.row];
	
	if(fileToBrowse.isFolder)
	{
        
        //Create a new FilesViewController_iPhone to push it into the navigationController
        
        FilesViewController_iPhone *newViewControllerForFilesBrowsing = [[FilesViewController_iPhone alloc] initWithRootFile:fileToBrowse];
        
        [self.navigationController pushViewController:newViewControllerForFilesBrowsing animated:YES];
        
        
        /*
		_delegate._currenteXoFile = file;
		_delegate._fileNameStackStr = [_delegate._fileNameStackStr stringByAppendingPathComponent:file._fileName];
		_arrDicts = [_delegate getPersonalDriveContent:file];
		
		[self setDriverContent:_arrDicts withDelegate:_delegate];
		_delegate.navigationItem.leftBarButtonItem = _delegate._btnBack;
		
		if([_arrDicts count] == 0) {
			imgViewEmptyPage.hidden = NO;
		}
         */
		
	}
	else
	{
		
		NSURL *urlOfTheFileToOpen = [NSURL URLWithString:[fileToBrowse.urlStr stringByReplacingOccurrencesOfString:@" " 
                                                                                                        withString:@"%20"]];
		eXoWebViewController* fileWebViewController = [[eXoWebViewController alloc] initWithNibAndUrl:@"eXoWebViewController"
                                                                                               bundle:nil 
                                                                                                  url:urlOfTheFileToOpen];
		[self.navigationController pushViewController:fileWebViewController animated:YES];     
	}
	
	//[startThread release];
	//[self performSelectorOnMainThread:@selector(endProgress) withObject:nil waitUntilDone:NO];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

@end
