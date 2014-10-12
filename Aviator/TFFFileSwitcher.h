#import <Foundation/Foundation.h>

@class TFFFileProvider;
@class IDESourceCodeDocument;

@interface TFFFileSwitcher : NSObject

- (instancetype)initWithFileProvider:(TFFFileProvider *)fileProvider;
- (void)switchBetweenReferenceCollectionFilesForCurrentSourceDocument:(IDESourceCodeDocument *)sourceCodeDocument;

@end
