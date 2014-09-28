#import <Cocoa/Cocoa.h>
#import "TFFFileReference.h"

@interface TFFFileReferenceCollection : NSObject

- (instancetype)initWithHeaderFileReference:(TFFReference *)headerFile
                        sourceFileReference:(TFFReference *)sourceFile
                          testFileReference:(TFFReference *)testFile;

@property (nonatomic, readonly) TFFReference *headerFile;
@property (nonatomic, readonly) TFFReference *sourceFile;
@property (nonatomic, readonly) TFFReference *testFile;

@end
