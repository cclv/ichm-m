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
	IBOutlet UIButton *fullScreenButton;

	IBOutlet UIToolbar *toolBar;
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UIBarButtonItem *homeButton;
	IBOutlet UIBarButtonItem *forwardButton;
	IBOutlet UIBarButtonItem *pageupButton;
	IBOutlet UIBarButtonItem *pagedownButton;
	IBOutlet UIBarButtonItem *fullscrennBarButton;
	
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

- (IBAction)toggleFullScreen:(id)sender;
- (IBAction)goHome:(id)sender;
@end
