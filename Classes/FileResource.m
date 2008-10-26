//
//  FileResource.m
//  iChm
//
//  Created by Robin Lu on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FileResource.h"
#import "RegexKitLite.h"
#import "HTTPConnection.h"
#import "HTTPServer.h"
#import "iChmAppDelegate.h"

@implementation FileResource

+ (BOOL)canHandle:(CFHTTPMessageRef)request
{
	CFURLRef url = CFHTTPMessageCopyRequestURL(request);
	NSString* fullpath = [(NSString*)CFURLCopyPath(url) autorelease];
	NSString* path = [[fullpath componentsSeparatedByString:@"/"] objectAtIndex:1];
	NSLog(path);
	path = [[path componentsSeparatedByString:@"."] objectAtIndex:0];
	NSComparisonResult rslt = [path caseInsensitiveCompare:@"files"];
	CFRelease(url);
	return rslt == NSOrderedSame;
}

- (id)initWithConnection:(HTTPConnection*)conn
{
	if (self = [self init])
	{
		request = conn.request;
		boundary = nil;
		parameters = conn.params;
		connection = conn;
		[connection retain];
	}
	return self;
}

- (void)dealloc
{
	[connection release];
	[super dealloc];
}

- (void)handleRequest
{
	CFURLRef url = CFHTTPMessageCopyRequestURL(request);
	NSString *method = (NSString *)CFHTTPMessageCopyRequestMethod(request);
	NSString* path = [(NSString*)CFURLCopyPath(url) autorelease];
	NSString *_method = [parameters objectForKey:@"_method"];
	
	if ([method isEqualToString:@"GET"])
	{
		if (NSOrderedSame == [path caseInsensitiveCompare:@"/files"])
			[self actionList];
		else
			[self actionShow];
	}
	else if (([method isEqualToString:@"POST"]) && _method && [[_method lowercaseString] isEqualToString:@"delete"])
	{
		NSArray *segs = [path componentsSeparatedByString:@"/"];
		if ([segs count] >= 2)
		{
			int fileId = [[segs objectAtIndex:2] intValue] ;
			[self actionDelete:fileId];
		}
	}
	else if (([method isEqualToString:@"POST"]))
	{
		[self actionNew];
	}
	
	CFRelease(url);
	[method release];
}

- (void)actionDelete:(int)fileId
{
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	iChmAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	NSArray *filelist = [appDelegate fileList];
	NSString *filename = [filelist objectAtIndex:fileId];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDir, filename];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	if(![fm removeItemAtPath:filePath error:&error])
	{
		NSLog(@"%@ can not be removed because:%@", filePath, error);
	}
	[appDelegate reloadFileList];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:HTTPFileDeletedNotification object:filename];

	[connection redirectoTo:@"/"];	
}

- (void)actionList
{
	NSMutableString *output = [[NSMutableString alloc] init];
	[output appendString:@"["];
	iChmAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	NSArray *filelist = [appDelegate fileList];
	for(int i = 0; i<[filelist count]; ++i)
	{
		NSString* file = [filelist objectAtIndex:i];
		[output appendFormat:@"{'name':'%@', 'id':%d},", file, i];
	}
	if ([output length] > 1)
	{
		NSRange range = NSMakeRange([output length] - 1, 1);
		[output replaceCharactersInRange:range withString:@"]"];
	}
	else
	{
		[output appendString:@"]"];
	}
	
	[connection sendString:output mimeType:nil];
	[output release];
}

- (void)actionShow
{
}

- (void)actionNew
{
	NSString *filename = [parameters objectForKey:@"newfile"];
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", docDir, filename];
	NSString *tmpfile = [parameters objectForKey:@"tmpfilename"];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	[fm moveItemAtPath:tmpfile toPath:filePath error:&error];
	
	iChmAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
	[appDelegate reloadFileList];
	[[NSNotificationCenter defaultCenter] postNotificationName:HTTPUploadingFinishedNotification object:filename];

	[connection redirectoTo:@"/"];
}
	
@end
