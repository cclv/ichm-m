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

@interface iChmAppDelegate (Private)
- (void)setupFileList;
@end


@implementation iChmAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize fileList;

- (void)setupFileList
{
	fileList = [[NSMutableArray alloc] init];
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager]
									  enumeratorAtPath:docDir];
	NSString *pname;
	while (pname = [direnum nextObject])
	{
		if ([[pname pathExtension] isEqualToString:@"chm"])
		{
			[fileList addObject:pname];
		}
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[NSURLProtocol registerClass:[ITSSProtocol class]];
	[self setupFileList];
	
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
	[fileList release];
	[super dealloc];
}

@end
