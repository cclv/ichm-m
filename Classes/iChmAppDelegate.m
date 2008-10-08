//
//  iChmAppDelegate.m
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "iChmAppDelegate.h"
#import "ITSSProtocol.h"
#import "RootViewController.h"


@implementation iChmAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[NSURLProtocol registerClass:[ITSSProtocol class]];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[NSURLProtocol unregisterClass:[ITSSProtocol class]];
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
