//
//  TableOfContentController.h
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHMDocument;

@interface TableOfContentController : UITableViewController {
	CHMDocument *chmDocument;
}

- (id)initWithCHMDocument:(CHMDocument*)chmdoc;
@end
