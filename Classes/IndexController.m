//
//  IndexController.m
//  iChm
//
//  Created by Robin Lu on 10/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "IndexController.h"
#import "CHMBrowserController.h"
#import "CHMTableOfContent.h"
#import "MovableTableViewIndex.h"

#pragma mark hack for UITableViewIndex
static BOOL tableViewIndexMoveIn(id self, SEL _cmd) {
	UIView *index = (UIView *)self;
	
	[UIView beginAnimations:nil context:nil];
	index.center = CGPointMake(index.center.x - 30, index.center.y);
	[UIView commitAnimations];
	
    return YES;
}

static BOOL tableViewIndexMoveOut(id self, SEL _cmd) {
	UIView *index = (UIView *)self;
	
	[UIView beginAnimations:nil context:nil];
	index.center = CGPointMake(index.center.x + 30, index.center.y);
	[UIView commitAnimations];
	
    return YES;
}

@interface IndexController (Private)
- (void) moveOutIndexView;
- (void) moveInIndexView;

@end

@implementation IndexController

- (id)initWithBrowserController:(CHMBrowserController*)controller idxSource:(LinkItem*)root
{
	if (self = [super initWithNibName:@"IndexController" bundle:nil]) {
		browserController = controller;
		[browserController retain];
		rootItem = root;
		indexSource = root;
		searchSource = [[LinkItem alloc] initWithName:@"root"	Path:@"/"];
		
		self.title = NSLocalizedString(@"Index", @"Index");
		[indexSource retain];
	}
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

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	CGRect newFrame = CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, searchBar.frame.size.height);
	searchBar.backgroundColor = [UIColor clearColor];
	searchBar.frame = newFrame;
	self.tableView.tableHeaderView = searchBar;
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (rootItem == indexSource)
		return [rootItem numberOfChildren];
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (rootItem == indexSource)
		return [[rootItem childAtIndex:section] numberOfChildren];
	return [rootItem numberOfChildren];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell
	LinkItem *item;
	if (rootItem == indexSource)
	{
		item = [[rootItem childAtIndex:indexPath.section] childAtIndex:indexPath.row];
	}
	else
	{
		item = [rootItem childAtIndex:indexPath.row];
	}
	cell.text = [item name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	LinkItem *item;
	if (rootItem == indexSource)
		item = [[rootItem childAtIndex:indexPath.section] childAtIndex:indexPath.row];
	else
		item = [rootItem childAtIndex:indexPath.row];
	[browserController loadPath:[item path]];
	[self.navigationController popToViewController:browserController animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
	if (rootItem == indexSource)
		return [[rootItem childAtIndex:section] name];
	return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView { 
	if (rootItem == indexSource)
		return [[rootItem children] valueForKey:@"name"]; 
	return nil;
}

/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
	[indexSource release];
	[browserController release];
	[searchSource release];
    [super dealloc];
}

#pragma mark searchbar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar
{
	searchBar.showsCancelButton = YES;
	[self moveOutIndexView];
}

- (void) moveOutIndexView
{
	for (UIView *view in self.tableView.subviews) {
		if ( [view respondsToSelector:@selector(moveIndexOut)] ) {
			MovableTableViewIndex *index = (MovableTableViewIndex *)view;
			[index moveIndexOut];
		}
	}	
}
- (void) moveInIndexView
{
	for (UIView *view in self.tableView.subviews) {
		if ( [view respondsToSelector:@selector(moveIndexIn)] ) {
			MovableTableViewIndex *index = (MovableTableViewIndex *)view;
			[index moveIndexIn];
		}
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar
{
	[searchBar resignFirstResponder];
	searchBar.text = @"";
	searchBar.showsCancelButton = NO;
	[self moveInIndexView];
	rootItem = indexSource;
	[self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[searchSource removeAllChildren];
	for	(LinkItem* section in [indexSource children])
	{
		for (LinkItem* item in [section children])
		{
			NSComparisonResult result = [[item name] compare:searchText options:NSCaseInsensitiveSearch
													 range:NSMakeRange(0, [searchText length])];
			if (result == NSOrderedSame)
				[searchSource appendChild:item];
		}
	}
	
	rootItem = searchSource;
	[self.tableView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)_searchBar
{
	searchBar.showsCancelButton = NO;
}
@end

