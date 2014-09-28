#import <Foundation/Foundation.h>
#import "XCodePrivate.h"
#import "TFFFileReferenceCollection.h"

@interface TFFFileProvider : NSObject

- (TFFFileReferenceCollection *)referenceCollectionForSourceCodeDocument:(IDESourceCodeDocument *)sourceCodeDocument;

@end
