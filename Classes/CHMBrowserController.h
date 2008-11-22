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
	IBOutlet UIActivityIndicatorView *loadIndicatorView;
	UISegmentedControl *segmentedControl;
	UISegmentedControl *rightBarControl;
	
	LinkItem* currentItem;
}

@property (readonly) LinkItem* currentItem;

-(id)init;

- (void)loadURL:(NSURL *)url;
- (void)loadPath:(NSString *)path;
- (NSURL*)composeURL:(NSString *)path;

- (void)navToTOC:(id)sender;
- (void)navToIDX:(id)sender;
@end
