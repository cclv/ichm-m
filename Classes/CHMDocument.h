//
//  CHMDocument.h
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
struct chmFile;
@class CHMTableOfContent;
@class LinkItem;

@interface CHMDocument : NSObject {
	struct chmFile *chmFileHandle;
	NSString *filePath;
	
    NSString *docTitle;
    NSString *homePath;
    NSString *tocPath;
    NSString *indexPath;
	
	CHMTableOfContent *tocSource ;
	CHMTableOfContent *indexSource ;

	NSString* encodingName;
}

@property (readonly) NSString* homePath;
@property (readonly) CHMTableOfContent* tocSource;

+ (CHMDocument*) CurrentDocument;
+ (CHMDocument*) OpenDocument: (NSString*)filename;

- (BOOL) exist: (NSString *)path;
- (NSData *)content: (NSString *)path;
- (BOOL)loadMetadata;
- (NSString *)findHomeForPath: (NSString *)basePath;

- (NSString*)currentEncodingName;
- (LinkItem*)tocItems;
@end
