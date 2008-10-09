//
//  CHMBrowserController.h
//  iChm
//
//  Created by Robin Lu on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMDocument;
@class LinkItem;

@interface CHMBrowserController : UIViewController {
	IBOutlet UIWebView *webView;
	UIColor *defaultTintColor;
	UISegmentedControl *segmentedControl;
	
	CHMDocument* chmHandle;
	LinkItem* currentItem;
}

@property (readonly) LinkItem* currentItem;

-(id)initWithCHMDocument:(CHMDocument*)chmdoc;

- (void)loadURL:(NSURL *)url;
- (void)loadPath:(NSString *)path;
- (NSURL*)composeURL:(NSString *)path;
@end
