//
//  AboutPageController.h
//  iChm
//
//  Created by Robin Lu on 10/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutPageController : UITableViewController {
	IBOutlet UILabel *versionInfo;
	IBOutlet UIView *headerView;
	IBOutlet UIView *footerView;
	NSArray *creditsData;
}

- (IBAction)helpPage:(id)sender;
@end
