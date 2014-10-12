#import "TFFXcodeDocumentNavigatorFake.h"

@implementation TFFXcodeDocumentNavigatorFake

+ (void)jumpToFileURL:(NSURL *)fileURL {
    NSLog(@"jump %@", fileURL);
}

@end
