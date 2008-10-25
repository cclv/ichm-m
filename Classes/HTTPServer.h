#import <Foundation/Foundation.h>

#define HTTPUploadingStartNotification @"UploadingStarted"
#define HTTPUploadingProgressNotification @"UploadingProgress"
#define HTTPUploadingFinishedNotification @"UploadingFinished"

@class AsyncSocket;


@interface HTTPServer : NSObject
{
	// Underlying asynchronous TCP/IP socket
	AsyncSocket *asyncSocket;
	
	// Standard delegate
	id delegate;
	
	// HTTP server configuration
	NSString *documentRoot;
	Class connectionClass;
	
	// NSNetService and related variables
	NSNetService *netService;
    NSString *domain;
	NSString *type;
    NSString *name;
	UInt16 port;
	NSDictionary *txtRecordDictionary;
	
	NSMutableArray *connections;
}

- (id)delegate;
- (void)setDelegate:(id)newDelegate;

- (NSString *)documentRoot;
- (void)setDocumentRoot:(NSString *)value;

- (Class)connectionClass;
- (void)setConnectionClass:(Class)value;

- (NSString *)domain;
- (void)setDomain:(NSString *)value;

- (NSString *)type;
- (void)setType:(NSString *)value;

- (NSString *)name;
- (void)setName:(NSString *)value;

- (UInt16)port;
- (void)setPort:(UInt16)value;

- (NSDictionary *)TXTRecordDictionary;
- (void)setTXTRecordDictionary:(NSDictionary *)dict;

- (BOOL)start:(NSError **)error;
- (BOOL)stop;

- (int)numberOfHTTPConnections;

- (NSString*)hostName;
@end
