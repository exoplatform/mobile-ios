//
//  ImagePreviewViewController.m
//  eXo Platform
//
//  Created by Le Thanh Quang on 4/2/12.
//  Copyright (c) 2012 eXo Platform. All rights reserved.
//

#import "ImagePreviewViewController.h"
#import "defines.h"
#import "LanguageHelper.h"

#define kZoomScaleFactor 2.0
// content size for view in iPad popover view
#define kPopoverContentSize CGSizeMake(320.0, 480.0)

@interface ImagePreviewViewController () {
    BOOL _navTranslucent;
    BOOL _navbarHidden;
}
@property (nonatomic, copy) image_preview_task changeImageBlock;
@property (nonatomic, copy) image_preview_task removeImageBlock;
@property (nonatomic, copy) image_preview_task selectImageBlock;

- (void)setZoomScalesForCurrentBounds;
- (void)selectImage:(id)sender;
- (void)changeImage:(UIButton *)sender;
- (void)unchangeImage:(UIButton *)sender;
- (void)releaseBlocks;

@end

@implementation ImagePreviewViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize changeImageBlock = _changeImageBlock;
@synthesize removeImageBlock = _removeImageBlock;
@synthesize selectImageBlock = _selectImageBlock;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // navigation bar items: buttons and title
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:Localize(@"OK") style:UIBarButtonItemStyleBordered target:self action:@selector(selectImage:)] autorelease];
        self.navigationItem.title = Localize(@"Image Preview");
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_texture"]];
        
        // image view scroll area
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        // toolbar buttons
        UIBarButtonItem *changeButton = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Change") style:UIBarButtonItemStyleBordered target:self action:@selector(changeImage:)];
        changeButton.tintColor = [UIColor whiteColor];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithTitle:Localize(@"Remove") style:UIBarButtonItemStyleBordered target:self action:@selector(unchangeImage:)];
        removeButton.tintColor = [UIColor whiteColor];
        
        self.toolbarItems = [NSArray arrayWithObjects:changeButton, flexItem, removeButton, nil];
        self.contentSizeForViewInPopover = kPopoverContentSize;
        [changeButton release];
        [removeButton release];
        [flexItem release];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navTranslucent = self.navigationController.navigationBar.translucent;
    _navbarHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES];
    self.navigationController.navigationBar.translucent = _navTranslucent;
    [self.navigationController setNavigationBarHidden:_navbarHidden];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    [self releaseBlocks];
    [scrollView release];
    [imageView release];
    [super dealloc];
}

#pragma mark - implementation

- (void)setZoomScalesForCurrentBounds {
    self.scrollView.zoomScale = 1.0; // Reset zoom to default before execute any zoom action.
    CGSize boundSize = self.scrollView.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat xScale = boundSize.width / imageSize.width;
    CGFloat yScale = boundSize.height / imageSize.height;
    CGFloat startScale = MIN(xScale, yScale); // The zoomScale is calculated so that the image is displayed fully in the view at begining.
    self.scrollView.maximumZoomScale = startScale * kZoomScaleFactor; // The max zoom is 'kZoomScaleFactor' times larger than begining. 
    self.scrollView.minimumZoomScale = startScale / kZoomScaleFactor; // The min zoom is 'kZoomScaleFactor' times smaller than begining.
    self.scrollView.zoomScale = startScale;
}

- (void)displayImage:(UIImage *)image {
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.contentSize = self.imageView.frame.size;
    self.scrollView.scrollEnabled = YES;
    [self setZoomScalesForCurrentBounds];
    
    [self.navigationController setToolbarHidden:NO];
}

- (void)changeImage:(id)sender {
    if (self.changeImageBlock) {
        self.changeImageBlock();
    }
}

- (void)unchangeImage:(id)sender {
    if (self.removeImageBlock) {
        self.removeImageBlock();
    }
}

- (void)selectImage:(id)sender {
    if (self.selectImageBlock) {
        self.selectImageBlock();
    }
}

#pragma mark - execution blocks.
- (void)changeImageWithCompletion:(image_preview_task)block {
    self.changeImageBlock = block;
}

- (void)removeImageWithCompletion:(image_preview_task)block {
    self.removeImageBlock = block;
}

- (void)selectImageWithCompletion:(image_preview_task)block {
    self.selectImageBlock = block;
}

- (void)releaseBlocks {
    self.changeImageBlock = nil;
    self.removeImageBlock = nil;
    self.selectImageBlock = nil;
}

#pragma mark - scroll view delegate 

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
