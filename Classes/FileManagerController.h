//
//  FileManagerController.h
//  iChm
//
//  Created by Robin Lu on 10/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class   HTTPServer;

@interface FileManagerController : UITableViewController {
	HTTPServer *httpServer;
	IBOutlet UILabel *fileNameLabel;
	IBOutlet UIProgressView *uploadProgress;
	IBOutlet UIView *uploadNoticeView;
}
- (void)uploadingStarted:(NSNotification*)notification;
- (void)updateUploadingStatus:(NSNotification*)notification;
- (void)uploadingFinished:(NSNotification*)notification;
@end
