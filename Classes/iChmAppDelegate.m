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
- (void)setupFilePreferences;
@end


@implementation iChmAppDelegate
static NSString *filePreferencesIdentity = @"FilePreferences";

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

- (void)setupFilePreferences
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *fileDefaults = [defaults dictionaryForKey:filePreferencesIdentity];
	filePreferences = [[NSMutableDictionary alloc] initWithDictionary:fileDefaults];
}

- (id) getPreferenceForFile:(NSString*)filename
{
	return [filePreferences objectForKey:filename];
}

- (void) setPreference:(id)pref ForFile:(NSString*)filename
{
	[filePreferences setObject:pref forKey:filename];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[NSURLProtocol registerClass:[ITSSProtocol class]];
	[self setupFileList];
	[self setupFilePreferences];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[NSURLProtocol unregisterClass:[ITSSProtocol class]];
	// Save data if appropriate
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:filePreferences forKey:filePreferencesIdentity];
	[defaults synchronize];
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[fileList release];
	[filePreferences release];
	[super dealloc];
}

@end
