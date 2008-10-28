//
//  CHMDocument.m
//  iChm
//
//  Created by Robin Lu on 10/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "chm_lib.h"
#import "lcid.h"
#import "CHMDocument.h"
#import "CHMTableOfContent.h"

#pragma mark Basic CHM reading operations
static inline NSStringEncoding nameToEncoding(NSString* name) {
	if(!name || [name length] == 0)
		return NSUTF8StringEncoding;
	return CFStringConvertEncodingToNSStringEncoding(
													 CFStringConvertIANACharSetNameToEncoding((CFStringRef) name));
}

static inline unsigned short readShort( NSData *data, unsigned int offset ) {
    NSRange valueRange = { offset, 2 };
    unsigned short value;
    
    [data getBytes:(void *)&value range:valueRange];
    return NSSwapLittleShortToHost( value );
}

static inline unsigned long readLong( NSData *data, unsigned int offset ) {
    NSRange valueRange = { offset, 4 };
    unsigned long value;
    
    [data getBytes:(void *)&value range:valueRange];
    return NSSwapLittleLongToHost( value );
}

static inline NSString * readString( NSData *data, unsigned long offset, NSString *encodingName ) {
    const char *stringData = (char *)[data bytes] + offset;
	return [[NSString alloc] initWithCString:stringData encoding:nameToEncoding(encodingName)];
}

static inline NSString * readTrimmedString( NSData *data, unsigned long offset, NSString *encodingName ) {
    NSString *str = readString(data, offset,encodingName);
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

static inline NSString * LCIDtoEncodingName(unsigned int lcid) {
	NSString * name= nil;
	switch (lcid) {
		case LCID_CS: //1250
		case LCID_HR: //1250
		case LCID_HU: //1250
		case LCID_PL: //1250
		case LCID_RO: //1250
		case LCID_SK: //1250
		case LCID_SL: //1250
		case LCID_SQ: //1250
		case LCID_SR_SP: //1250
			name = @"CP1250";
			break;
		case LCID_AZ_CY: //1251
		case LCID_BE: //1251
		case LCID_BG: //1251
		case LCID_MS_MY: //1251
		case LCID_RU: //1251
		case LCID_SB: //1251
		case LCID_SR_SP2: //1251
		case LCID_TT: //1251
		case LCID_UK: //1251
		case LCID_UZ_UZ2: //1251
		case LCID_YI: //1251
			name = @"CP1251";
			break;
		case LCID_AF: //1252
		case LCID_CA: //1252
		case LCID_DA: //1252
		case LCID_DE_AT: //1252
		case LCID_DE_CH: //1252
		case LCID_DE_DE: //1252
		case LCID_DE_LI: //1252
		case LCID_DE_LU: //1252
		case LCID_EN_AU: //1252
		case LCID_EN_BZ: //1252
		case LCID_EN_CA: //1252
		case LCID_EN_CB: //1252
		case LCID_EN_GB: //1252
		case LCID_EN_IE: //1252
		case LCID_EN_JM: //1252
		case LCID_EN_NZ: //1252
		case LCID_EN_PH: //1252
		case LCID_EN_TT: //1252
		case LCID_EN_US: //1252
		case LCID_EN_ZA: //1252
		case LCID_ES_AR: //1252
		case LCID_ES_BO: //1252
		case LCID_ES_CL: //1252
		case LCID_ES_CO: //1252
		case LCID_ES_CR: //1252
		case LCID_ES_DO: //1252
		case LCID_ES_EC: //1252
		case LCID_ES_ES: //1252
		case LCID_ES_GT: //1252
		case LCID_ES_HN: //1252
		case LCID_ES_MX: //1252
		case LCID_ES_NI: //1252
		case LCID_ES_PA: //1252
		case LCID_ES_PE: //1252
		case LCID_ES_PR: //1252
		case LCID_ES_PY: //1252
		case LCID_ES_SV: //1252
		case LCID_ES_UY: //1252
		case LCID_ES_VE: //1252
		case LCID_EU: //1252
		case LCID_FI: //1252
		case LCID_FO: //1252
		case LCID_FR_BE: //1252
		case LCID_FR_CA: //1252
		case LCID_FR_CH: //1252
		case LCID_FR_FR: //1252
		case LCID_FR_LU: //1252
		case LCID_GD: //1252
		case LCID_HI: //1252
		case LCID_ID: //1252
		case LCID_IS: //1252
		case LCID_IT_CH: //1252
		case LCID_IT_IT: //1252
		case LCID_MS_BN: //1252
		case LCID_NL_BE: //1252
		case LCID_NL_NL: //1252
		case LCID_NO_NO: //1252
		case LCID_NO_NO2: //1252
		case LCID_PT_BR: //1252
		case LCID_PT_PT: //1252
		case LCID_SV_FI: //1252
		case LCID_SV_SE: //1252
		case LCID_SW: //1252
			name = @"CP1252";
			break;
		case LCID_EL: //1253
			name = @"CP1253";
			break;
		case LCID_AZ_LA: //1254
		case LCID_TR: //1254
		case LCID_UZ_UZ: //1254
			name = @"CP1254";
			break;
		case LCID_HE: //1255
			name = @"CP1255";
			break;
		case LCID_AR_AE: //1256
		case LCID_AR_BH: //1256
		case LCID_AR_DZ: //1256
		case LCID_AR_EG: //1256
		case LCID_AR_IQ: //1256
		case LCID_AR_JO: //1256
		case LCID_AR_KW: //1256
		case LCID_AR_LB: //1256
		case LCID_AR_LY: //1256
		case LCID_AR_MA: //1256
		case LCID_AR_OM: //1256
		case LCID_AR_QA: //1256
		case LCID_AR_SA: //1256
		case LCID_AR_SY: //1256
		case LCID_AR_TN: //1256
		case LCID_AR_YE: //1256
		case LCID_FA: //1256
		case LCID_UR: //1256
			name = @"CP1256";
			break;
		case LCID_ET: //1257
		case LCID_LT: //1257
		case LCID_LV: //1257
			name = @"CP1257";
			break;
		case LCID_VI: //1258
			name = @"CP1258";
			break;
		case LCID_TH: //874
			name = @"CP874";
			break;
		case LCID_JA: //932
			name = @"CP932";
			break;
		case LCID_ZH_CN: //936
		case LCID_ZH_SG: //936
			name = @"CP936";
			break;
		case LCID_KO: //949
			name = @"CP949";
			break;
		case LCID_ZH_HK: //950
		case LCID_ZH_MO: //950
		case LCID_ZH_TW: //950
			name = @"CP950";
			break;			
		case LCID_GD_IE: //??
		case LCID_MK: //??
		case LCID_RM: //??
		case LCID_RO_MO: //??
		case LCID_RU_MO: //??
		case LCID_ST: //??
		case LCID_TN: //??
		case LCID_TS: //??
		case LCID_XH: //??
		case LCID_ZU: //??
		case LCID_HY: //0
		case LCID_MR: //0
		case LCID_MT: //0
		case LCID_SA: //0
		case LCID_TA: //0
		default:
			break;
	}
	return name;
}

@interface CHMDocument (Private)

- (id)initWithFileName:(NSString *)filename;

- (BOOL)readFromFile:(NSString *)path;
- (void)setupTOCSource;

@end

@implementation CHMDocument
@synthesize homePath;
@synthesize tocSource;
@synthesize indexSource;
@synthesize docTitle;
@synthesize fileName;

static CHMDocument *currentDocument = nil;

+ (CHMDocument*) CurrentDocument
{
	return currentDocument;
}

+ (CHMDocument*) OpenDocument: (NSString*)filename
{
	if (currentDocument && [[currentDocument fileName] isEqualToString:filename])
		return currentDocument;
	
	if (currentDocument != nil)
		[currentDocument release];
	currentDocument = [[CHMDocument alloc] initWithFileName:filename];
	return currentDocument;
}

- (id)initWithFileName:(NSString *)filename
{
	fileName = filename;
	[fileName retain];
	NSString* docDir = [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
	[self readFromFile:[NSString stringWithFormat:@"%@/%@", docDir, filename]];
	return self;
}

- (BOOL)readFromFile:(NSString *)path{
    NSLog( @"CHMDocument:readFromFile:%@", path );
	NSString* filePath = path;
	
    chmFileHandle = chm_open( [filePath fileSystemRepresentation] );
    if( !chmFileHandle ) return NO;
	
	
    [self loadMetadata];
	[NSThread detachNewThreadSelector:@selector(setupTOCSource) toTarget:self withObject:NULL];
	//[self setupTOCSource];
	return YES;
}

- (void)setupTOCSource{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if (tocPath && [tocPath length] > 0)
	{
		NSData * tocData = [self content:tocPath];
		CHMTableOfContent* newTOC = [[CHMTableOfContent alloc] initWithData:tocData encodingName:[self currentEncodingName]];
		if (tocSource)
			[tocSource release];
		tocSource = newTOC;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:CHMDocumentTOCReady object:nil];

	if (indexPath && [indexPath length] > 0) 
	{
		NSData * tocData = [self content:indexPath];
		CHMIndex* newTOC = [[CHMIndex alloc] initWithData:tocData encodingName:[self currentEncodingName]];
		if (indexSource)
			[indexSource release];
		indexSource = newTOC;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:CHMDocumentIDXReady object:nil];
	[pool release];
}

- (BOOL)tocIsReady
{
	return ((tocPath == nil || [tocPath length] == 0 || tocSource != nil) &&
			 (indexPath == nil || [indexPath length] == 0 || indexSource != nil));
}

- (LinkItem*)tocItems
{
	return [tocSource rootItems];
}

- (LinkItem*)idxItems
{
	if (indexSource)
		return [indexSource rootItems];
	return nil;
}
#pragma mark chm_lib
- (BOOL) exist: (NSString *)path
{
	struct chmUnitInfo info;
	if (chmFileHandle)
		return chm_resolve_object( chmFileHandle, [path UTF8String], &info ) == CHM_RESOLVE_SUCCESS;
	return NO;
}

- (NSData *)content: (NSString *)path
{
	if( !path ) {
		return nil;
    }
    
    if( [path hasPrefix:@"/"] ) {
		if( [path hasPrefix:@"///"] ) {
			path = [path substringFromIndex:2];
		}
    }
    else {
		path = [NSString stringWithFormat:@"/%@", path];
    }
    
	struct chmUnitInfo info;
	void *buffer = nil;
	@synchronized(self)
	{
		if (chm_resolve_object( chmFileHandle, [path UTF8String], &info ) == CHM_RESOLVE_SUCCESS)
		{    
			buffer = malloc( info.length );
			
			if( buffer ) {
				if( !chm_retrieve_object( chmFileHandle, &info, buffer, 0, info.length ) ) {
					NSLog( @"Failed to load %qu bytes for %@", (long long)info.length, path );
					free( buffer );
					buffer = nil;
				}
			}
		}
	}
    
	if (buffer)
		return [NSData dataWithBytesNoCopy:buffer length:info.length];
	
	return nil;
	
}

- (BOOL)loadMetadata {
    //--- Start with WINDOWS object ---
    NSData *windowsData = [self content:@"/#WINDOWS"];
    NSData *stringsData = [self content:@"/#STRINGS"];
	
    if( windowsData && stringsData ) {
		const unsigned long entryCount = readLong( windowsData, 0 );
		const unsigned long entrySize = readLong( windowsData, 4 );
		
		for( int entryIndex = 0; entryIndex < entryCount; ++entryIndex ) {
			unsigned long entryOffset = 8 + ( entryIndex * entrySize );
			
			if( !docTitle || ( [docTitle length] == 0 ) ) { 
				docTitle = readTrimmedString( stringsData, readLong( windowsData, entryOffset + 0x14), encodingName );
			}
			
			if( !tocPath || ( [tocPath length] == 0 ) ) { 
				tocPath = readString( stringsData, readLong( windowsData, entryOffset + 0x60 ), encodingName );
			}
			
			if( !indexPath || ( [indexPath length] == 0 ) ) { 
				indexPath = readString( stringsData, readLong( windowsData, entryOffset + 0x64 ), encodingName );
			}
			
			if( !homePath || ( [homePath length] == 0 ) ) { 
				homePath = readString( stringsData, readLong( windowsData, entryOffset + 0x68 ), encodingName );
			}
		}
    }
    
    //--- Use SYSTEM object ---
    NSData *systemData = [self content:@"/#SYSTEM"];
    if( systemData == nil ) {
		return NO;
    }
	
    unsigned int maxOffset = [systemData length];
	unsigned int offset = 4;
    for( ;offset<maxOffset; ) {
		switch( readShort( systemData, offset ) ) {
			case 0:
				if( !tocPath || ( [tocPath length] == 0 ) ) {
					tocPath = readString( systemData, offset + 4, encodingName );
				}
				break;
			case 1:
				if( !indexPath || ( [indexPath length] == 0 ) ) {
					indexPath = readString( systemData, offset + 4, encodingName );
				}
				break;
			case 2:
				if( !homePath || ( [homePath length] == 0 ) ) {
					homePath = readString( systemData, offset + 4, encodingName );
				}
				break;
			case 3:
				if( !docTitle || ( [docTitle length] == 0 ) ) {
					docTitle = readTrimmedString( systemData, offset + 4, encodingName );
				}
				break;
			case 4:
			{
				unsigned int lcid = readLong(systemData, offset + 4);
				NSLog(@"SYSTEM LCID: %d", lcid);
				encodingName = LCIDtoEncodingName(lcid);
				NSLog(@"SYSTEM encoding: %@", encodingName);
			}
				break;
			case 6:
			{
				const char *data = (const char *)([systemData bytes] + offset + 4);
				NSString *prefix = [[NSString alloc] initWithCString:data encoding:nameToEncoding(encodingName)];
				if( !tocPath || [tocPath length] == 0 ) {
					NSString *path = [NSString stringWithFormat:@"/%@.hhc", prefix];
					if ([self exist:path])
					{
						tocPath = path;
					}
				}
				if ( !indexPath || [indexPath length] == 0 )
				{
					NSString *path = [NSString stringWithFormat:@"/%@.hhk", prefix];
					if ([self exist:path])
					{
						indexPath = path;
					}
				}
				[prefix release];
			}
				break;
			case 9:
				break;
			case 16:
				break;
			default:
				NSLog(@"SYSTEM unhandled value:%d", readShort( systemData, offset ));
				break;
		}
		offset += readShort(systemData, offset+2) + 4;
    }
	
    // Check for empty string titles
    if( [docTitle length] == 0 )  {
        docTitle = nil;
    }
    else {
        [docTitle retain];
    }
	
    // Check for lack of index page
    if( !homePath ) {
        homePath = [self findHomeForPath:@"/"];
        NSLog( @"Implicit home: %@", homePath );
    }
    
    [homePath retain];
    [tocPath retain];
    [indexPath retain];
    
    return YES;
}

- (NSString *)findHomeForPath: (NSString *)basePath
{
    NSString *testPath;
    
    NSString *separator = [basePath hasSuffix:@"/"]? @"" : @"/";
    testPath = [NSString stringWithFormat:@"%@%@index.htm", basePath, separator];
    if( [self exist:testPath] ) {
        return testPath;
    }
	
    testPath = [NSString stringWithFormat:@"%@%@default.html", basePath, separator];
    if( [self exist:testPath] ) {
        return testPath;
    }
	
    testPath = [NSString stringWithFormat:@"%@%@default.htm", basePath, separator];
    if( [self exist:testPath] ) {
        return testPath;
    }
	
    return [NSString stringWithFormat:@"%@%@index.html", basePath, separator];
}

#pragma mark encoding
- (NSString*)currentEncodingName
{
	return encodingName;
}

#pragma mark dealloc
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];	
	[fileName release];
	[tocSource release];
	[indexSource release];
    [super dealloc];
}

@end
