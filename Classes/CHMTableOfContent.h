//
//  CHMTableOfContent.h
//  ichm
//
//  Created by Robin Lu on 7/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LinkItem;

@interface CHMTableOfContent : NSObject {
	LinkItem *rootItems;
	
	NSMutableArray *itemStack;
	NSMutableArray *pageList;
	NSCharacterSet *urlSpliter;
	NSString *lastPath;
	LinkItem *curItem;
}
@property (readonly) LinkItem *rootItems;

- (id)initWithData:(NSData *)data encodingName:(NSString*)encodingName;
- (LinkItem *)curItem;
- (LinkItem *)itemForPath:(NSString*)path withStack:(NSMutableArray*)stack;
- (int)rootChildrenCount;
- (void)sort;
- (LinkItem*)getNextPage:(LinkItem*)item;
- (LinkItem*)getPrevPage:(LinkItem*)item;
- (BOOL)canGoNextPage:(LinkItem*)item;
- (BOOL)canGoPrevPage:(LinkItem*)item;
@end

@interface CHMSearchResult : CHMTableOfContent
{
	CHMTableOfContent* tableOfContent;
	CHMTableOfContent* indexContent;
}

- (id)initwithTOC:(CHMTableOfContent*)toc withIndex:(CHMTableOfContent*)index;
- (void)addPath:(NSString*)path Score:(float)score;
@end

@interface LinkItem	: NSObject
{
	NSString *_name;
	NSString *_path;
	NSMutableArray *_children;
	NSUInteger pageID;
}
@property (readonly) NSUInteger pageID;

- (id)initWithName:(NSString *)name Path:(NSString *)path;
- (int)numberOfChildren;
- (LinkItem *)childAtIndex:(int)n;
- (NSString *)name;
- (NSString *)uppercaseName;
- (NSString *)path;
- (NSMutableArray*)children;
- (void)purge;
- (void)setName:(NSString *)name;
- (void)setPath:(NSString *)path;
- (void)setPageID:(NSUInteger)pageid;
- (void)appendChild:(LinkItem *)item;
- (LinkItem*)find_by_path:(NSString *)path withStack:(NSMutableArray*)stack;
- (void)enumerateItemsWithSEL:(SEL)selector ForTarget:(id)target;
- (void)sort;
- (void)removeAllChildren;
@end

@interface ScoredLinkItem : LinkItem
{
	float relScore;
}

@property (readwrite, assign) float relScore;

- (id)initWithName:(NSString *)name Path:(NSString *)path Score:(float)score;
@end

@interface CHMIndex : CHMTableOfContent
{
}
@end
