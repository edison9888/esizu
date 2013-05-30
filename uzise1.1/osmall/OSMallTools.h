
#import <Foundation/Foundation.h>
#import "IOSFactory.h"
#import "MBProgressHUD.h"


#define CACHE_DATA_PATH [[IOSFactory getIOSDocuments] stringByAppendingFormat:@"/cache/org.lxh.osmall.plist"]

#define GET_DATA_PATH(x) [[IOSFactory getIOSDocuments] stringByAppendingFormat:x]

#define GET_CACHE_DICT(x) [[NSDictionary alloc]initWithDictionary:[[[NSDictionary alloc]initWithContentsOfFile:CACHE_DATA_PATH] objectForKey:x]];

#define GET_CACHE_AREA_OBJ(x) [[[NSDictionary alloc]initWithContentsOfFile:[IOSFactory getMainPath:x oftype:@"plist"] ]  objectForKey:x]


#define GET_DATA_OBJECT(x) [[NSMutableDictionary dictionaryWithContentsOfFile:CACHE_DATA_PATH] objectForKey:x];

@interface OSMallTools : NSObject

@end
