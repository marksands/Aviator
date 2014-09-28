#import "TFFFileReferenceCollection.h"

@implementation TFFFileReferenceCollection

- (instancetype)initWithHeaderFileReference:(TFFFileReference *)headerFile
                        sourceFileReference:(TFFFileReference *)sourceFile
                          testFileReference:(TFFFileReference *)testFile {
    if (self = [super init]) {
        _headerFile = headerFile;
        _sourceFile = sourceFile;
        _testFile = testFile;
    }
    return self;
}

@end
