//
//  CHMBrowserController.m
//  iChm
//
//  Created by Robin Lu on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CHMBrowserController.h"
#import "ITSSProtocol.h"
#import "CHMDocument.h"
#import "TableOfContentController.h"
#import "IndexController.h"
#import "CHMTableOfContent.h"
#import "iChmAppDelegate.h"

@interface CHMBrowserController (Private)

- (void)resetHistoryNavBar;
- (NSString*)extractPathFromURL:(NSURL*)url;
- (void)updateTOCButton;
- (void)willTerminate;
@end

@implementation CHMBrowserController

@synthesize currentItem;

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
-(id)init
{
    if (self = [super initWithNibName:@"CHMBrowser" bundle:nil]) {
		// setup notification
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateTOCButton) name:CHMDocumentTOCReady object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateTOCButton) name:CHMDocumentIDXReady object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(willTerminate) name:UIApplicationWillTerminateNotification object:nil];
		rightBarControl = nil;
    }
	
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
 */

- (void) updateTOCButton {
	if (!rightBarControl)
	{
		rightBarControl = [[UISegmentedControl alloc] initWithItems:
														[NSArray arrayWithObjects:
														   [UIImage imageNamed:@"toc.png"],
														   [UIImage imageNamed:@"idx.png"],
														   nil]];
		[rightBarControl addTarget:self action:@selector(toTocOrIdx:) forControlEvents:UIControlEventValueChanged];
		rightBarControl.frame = CGRectMake(0, 0, 80, 30);
		rightBarControl.segmentedControlStyle = UISegmentedControlStyleBar;
		rightBarControl.momentary = YES;
		
		@synchronized(self)
		{
			UIBarButtonItem *segmentBarItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBarControl] autorelease];
			self.navigationItem.rightBarButtonItem = segmentBarItem;
		}
	}
	[rightBarControl setEnabled:[[CHMDocument CurrentDocument] tocSource] != nil forSegmentAtIndex:0];
	[rightBarControl setEnabled:[[CHMDocument CurrentDocument] idxItems] != nil forSegmentAtIndex:1];
}

- (void) addLoadingTOCIndicator {
	@synchronized(self)
	{
		if (rightBarControl)
			return;
		UIActivityIndicatorView * loadingTOCView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:loadingTOCView];
		[loadingTOCView startAnimating];
		self.navigationItem.rightBarButtonItem = segmentBarItem;
		[loadingTOCView release];
		[segmentBarItem release];
	}
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	// "Segmented" control to the right
	segmentedControl = [[UISegmentedControl alloc] initWithItems:
											 [NSArray arrayWithObjects:
											  [UIImage imageNamed:@"left.png"],
											  [UIImage imageNamed:@"home.png"],
											  [UIImage imageNamed:@"right.png"],
											  nil]];
	[segmentedControl addTarget:self action:@selector(navHistory:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 120, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	self.navigationItem.titleView = segmentedControl;
	[self resetHistoryNavBar];

	CHMDocument * doc = [CHMDocument CurrentDocument];
	if ([doc tocIsReady]) {
		[self updateTOCButton];
	}
	else
	{
		[self addLoadingTOCIndicator];
	}

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	webView.autoresizesSubviews = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)resetHistoryNavBar
{
	[segmentedControl setEnabled:[webView canGoBack] forSegmentAtIndex:0];
	[segmentedControl setEnabled:[webView canGoForward] forSegmentAtIndex:2];
}

- (NSString*)extractPathFromURL:(NSURL*)url
{
	return [[[url absoluteString] substringFromIndex:11] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark load page
- (void)loadPath:(NSString *)path
{
	NSURL *url = [self composeURL:path];
	[self loadURL:url];
}

- (void)loadURL:(NSURL *)url
{
	if( url ) {
		CHMDocument *doc = [CHMDocument CurrentDocument];
		NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
		[req setEncodingName:[doc currentEncodingName]];
		[webView loadRequest:req];
	}
}

- (NSURL*)composeURL:(NSString *)path
{
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itss://chm/%@", path]];
	if (!url)
		url = [NSURL URLWithString:[NSString stringWithFormat:@"itss://chm/%@", [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	return url;
}

#pragma mark ui actions
- (void)navHistory:(id)sender
{
	UISegmentedControl* segCtl = sender;
	// the segmented control was clicked, handle it here
	switch ([segCtl selectedSegmentIndex]) {
		case 0:
			[webView goBack];
			break;
		case 1:
			[self loadPath:[[CHMDocument CurrentDocument] homePath]];
			break;
		case 2:
			[webView goForward];
			break;
	}
	[self resetHistoryNavBar];
}

- (void)toTocOrIdx:(id)sender
{
	UISegmentedControl* segCtl = sender;
	// the segmented control was clicked, handle it here
	switch ([segCtl selectedSegmentIndex]) {
		case 0:
			[self navToTOC:sender];
			break;
		case 1:
			[self navToIDX:sender];
			break;
	}
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)navToIDX:(id)sender
{
	CHMDocument *doc = [CHMDocument CurrentDocument];
	IndexController* controller = [[[IndexController alloc]
									initWithBrowserController:self
								    idxSource:[[doc indexSource] rootItems] ] autorelease];
	[[self navigationController] pushViewController:controller animated:NO];
}

- (void)navToTOC:(id)sender
{
	CHMDocument *doc = [CHMDocument CurrentDocument];
	NSMutableArray *tocStack = [[NSMutableArray alloc] init];
	[[doc tocSource] itemForPath:[currentItem path] 
					  withStack:tocStack];
	if ([tocStack count])
	{
		NSEnumerator *enumerator = [tocStack reverseObjectEnumerator];
		for (LinkItem *p in enumerator) {
			TableOfContentController *tocController = [[[TableOfContentController alloc] initWithBrowserController:self tocRoot:p] autorelease];
			[[self navigationController] pushViewController:tocController animated:NO];
		}
	}
	else
	{
		LinkItem *p = [doc tocItems];
		TableOfContentController *tocController = [[[TableOfContentController alloc] initWithBrowserController:self tocRoot:p] autorelease];
		[[self navigationController] pushViewController:tocController animated:NO];		
	}
	[tocStack release];
}

#pragma mark webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webview
{
	[self resetHistoryNavBar];
	
	NSURL *url = [webView.request URL];
	NSString *path = [self extractPathFromURL:url];
	currentItem = [[[CHMDocument CurrentDocument] tocSource] itemForPath:path withStack:nil];

	if (currentItem)
	{
		iChmAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
		NSDictionary *pref = [NSDictionary dictionaryWithObject:[currentItem path] forKey:@"last path"];
		[appDelegate setPreference:pref ForFile:[CHMDocument CurrentDocument].fileName];	
	}
}

#pragma mark dealloc
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	[segmentedControl release];
	[rightBarControl release];
	[webView stopLoading];
	webView.delegate = nil;
    [super dealloc];
}

- (void)willTerminate
{
	// Save data if appropriate
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[CHMDocument CurrentDocument].fileName forKey:@"last open file"];
	[defaults synchronize];
}
@end
