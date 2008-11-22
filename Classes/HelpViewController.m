//
//  HelpViewController.m
//  iChm
//
//  Created by Robin Lu on 11/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController

- (id)init
{
	self = [super initWithNibName:@"Help" bundle:nil];
	self.title = NSLocalizedString(@"Help", @"Help");
	return self;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *path = [bundle pathForResource:@"help" ofType:@"html" inDirectory:@"help_doc"];
	NSURL *url = [NSURL fileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[webView loadRequest:request];
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
