//
//  FileResource.h
//  iChm
//
//  Created by Robin Lu on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CFNetwork/CFHTTPMessage.h>
@class HTTPConnection;

@interface FileResource : NSObject {
	CFHTTPMessageRef request;
	NSString * boundary;
	NSDictionary *parameters;
	HTTPConnection *connection;
}

+ (BOOL)canHandle:(CFHTTPMessageRef)request;

- (id)initWithConnection:(HTTPConnection*)conn;

- (void)handleRequest;
- (void)actionList;
- (void)actionShow;
- (void)actionNew;
@end
