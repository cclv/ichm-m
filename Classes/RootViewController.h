//
//  RootViewController.h
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileManagerController;


@interface FileTitleCell: UITableViewCell
{
	UILabel *titleLabel;
	UILabel *filenameLabel;
	UIImageView *backgrounView;
}

- (void)setTitle:(NSString*)title;
- (void)setFilename:(NSString*)filename;

@end


@interface RootViewController : UITableViewController {
	FileManagerController *fileManagerController;
}

- (IBAction)startFileManager:(id)sender;
- (IBAction)aboutPage:(id)sender;
@end
