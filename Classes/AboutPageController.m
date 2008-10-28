//
//  AboutPageController.m
//  iChm
//
//  Created by Robin Lu on 10/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AboutPageController.h"


@implementation AboutPageController

- (id)init
{
	[self initWithNibName:@"about" bundle:nil];
	self.tableView.tableHeaderView = headerView;
	[headerView setBackgroundColor:[UIColor clearColor]];
	self.title = NSLocalizedString(@"About iChm", @"About iChm");

	self.tableView.tableFooterView = footerView;
	[footerView setBackgroundColor:[UIColor clearColor]];
	
	NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
	[versionInfo setText:[NSString stringWithFormat: @"iChm v%@", [dic objectForKey:@"CFBundleVersion"]]];
	[versionInfo setFont:[UIFont boldSystemFontOfSize:28]];
	
	NSString *error;
	NSPropertyListFormat format;
	NSString* path = [[NSBundle mainBundle] pathForResource:@"credits" ofType:@"plist"];
	creditsData = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:path]
												   mutabilityOption:NSPropertyListImmutable
															 format:&format
												   errorDescription:&error];
	[creditsData retain];
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Credits";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [creditsData count] * 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell
	int idx = indexPath.row/2;
	if (idx * 2 == indexPath.row)
	{
		cell.text = [(NSDictionary*)[creditsData objectAtIndex:idx] objectForKey:@"title"];
		cell.font = [UIFont boldSystemFontOfSize:18];
	}
	else
	{
		cell.text = [(NSDictionary*)[creditsData objectAtIndex:idx] objectForKey:@"name"];
		cell.font = [UIFont systemFontOfSize:18];
		cell.indentationLevel = 2;
	}
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
*/

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
	[creditsData release];
    [super dealloc];
}


@end

