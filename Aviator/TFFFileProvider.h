#import <Foundation/Foundation.h>
#import "XCodePrivate.h"
#import "TFFFileReferenceCollection.h"

@interface TFFFileProvider : NSObject

- (instancetype)initWithFileReferences:(NSArray *)fileReferences;
- (TFFFileReferenceCollection *)referenceCollectionForSourceCodeDocument:(IDESourceCodeDocument *)sourceCodeDocument;

@end
