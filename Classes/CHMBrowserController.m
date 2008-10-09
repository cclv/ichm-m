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

@interface CHMBrowserController (Private)

- (void)resetHistoryNavBar;

@end

@implementation CHMBrowserController

// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
-(id)initWithCHMDocument:(CHMDocument*)chmdoc
{
    if (self = [super initWithNibName:@"CHMBrowser" bundle:nil]) {
        // Custom initialization
		chmHandle = chmdoc;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	// "Segmented" control to the right
	segmentedControl = [[UISegmentedControl alloc] initWithItems:
											 [NSArray arrayWithObjects:
											  [UIImage imageNamed:@"left.png"],
											  [UIImage imageNamed:@"right.png"],
											  nil]];
	[segmentedControl addTarget:self action:@selector(navHistory:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	defaultTintColor = [segmentedControl.tintColor retain];	// keep track of this for later
	self.navigationItem.titleView = segmentedControl;
	[self resetHistoryNavBar];

	UIBarButtonItem *tocButton = [[[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"TOC", @"")
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(navToTOC:)] autorelease];
	self.navigationItem.rightBarButtonItem = tocButton;

    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)resetHistoryNavBar
{
	[segmentedControl setEnabled:[webView canGoBack] forSegmentAtIndex:0];
	[segmentedControl setEnabled:[webView canGoForward] forSegmentAtIndex:1];
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
		NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
		[req setChmDoc:chmHandle];
		[req setEncodingName:[chmHandle currentEncodingName]];
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
			[webView goForward];
			break;
	}
	[self resetHistoryNavBar];
}

- (void)navToTOC:(id)sender
{
	CHMDocument *doc = [CHMDocument CurrentDocument];
	LinkItem* rootItem = [doc tocItems];
	TableOfContentController *tocController = [[TableOfContentController alloc] initWithBrowserController:self tocRoot:rootItem];
	[[self navigationController] pushViewController:tocController animated:YES];
	[tocController release];	
}

#pragma mark webviewdelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self resetHistoryNavBar];
}

#pragma mark dealloc
- (void)dealloc {
	[segmentedControl release];
    [super dealloc];
}


@end
