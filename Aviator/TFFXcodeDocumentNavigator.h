#import <Foundation/Foundation.h>
#import "XcodePrivate.h"

@interface TFFXcodeDocumentNavigator : NSObject

+ (IDEWorkspace *)currentWorkspace;
+ (IDESourceCodeDocument *)currentSourceCodeDocument;

+ (void)jumpToFileURL:(NSURL *)fileURL;

@end

