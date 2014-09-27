#import <Foundation/Foundation.h>
#import "XcodePrivate.h"

@interface TFFXcodeDocumentNavigator : NSObject

+ (IDESourceCodeDocument *)currentSourceCodeDocument;
+ (void)jumpToFileURL:(NSURL *)fileURL;

@end

