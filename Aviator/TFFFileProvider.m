#import "TFFFileProvider.h"
#import "TFFXcodeDocumentNavigator.h"
#import "XCodePrivate.h"
#import "TFFReference.h"
#import "TFFFileReferenceCollection.h"

@interface TFFFileProvider ()
@property (nonatomic, copy) NSArray *fileReferences;
@end

@implementation TFFFileProvider

- (instancetype)initWithFileReferences:(NSArray *)fileReferences {
    if (self = [super init]) {
        _fileReferences = fileReferences;
    }
    return self;
}

- (TFFFileReferenceCollection *)referenceCollectionForSourceCodeDocument:(IDESourceCodeDocument *)sourceCodeDocument {
    if (sourceCodeDocument) {
        DVTFilePath *filePath = sourceCodeDocument.filePath;
        NSString *fileName = filePath.fileURL.lastPathComponent;
        fileName = [self fileNameByStrippingExtensionAndLastOccuranceOfTest:fileName];
        
        TFFReference *headerRef = nil;
        TFFReference *sourceRef = nil;
        TFFReference *testRef = nil;
        
        NSArray *fileReferences = self.fileReferences;
        for (TFFReference *reference in fileReferences) {
            if ([reference.name rangeOfString:fileName].location != NSNotFound) {
                if (reference.isTestFile) {
                    testRef = reference;
                } else if (reference.isSourceFile) {
                    sourceRef = reference;
                } else if (reference.isHeaderFile) {
                    headerRef = reference;
                }
            }
        }
        
        return [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:testRef];
    }
    return nil;
}

#pragma mark - Helper

- (NSString *)fileNameByStrippingExtensionAndLastOccuranceOfTest:(NSString *)fileName {
    NSString *file = [fileName stringByDeletingPathExtension];
    NSString *strippedFileName = nil;
    
    if (file.length >= 5) {
        NSRange rangeOfOccurrenceOfTest = [file rangeOfString:@"Test" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length - 5, 5)];
        NSRange rangeOfOccurrenceOfSpec = [file rangeOfString:@"Spec" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length - 5, 5)];
        if (rangeOfOccurrenceOfTest.location != NSNotFound) {
            strippedFileName = [file substringToIndex:rangeOfOccurrenceOfTest.location];
        } else if (rangeOfOccurrenceOfSpec.location != NSNotFound) {
            strippedFileName = [file substringToIndex:rangeOfOccurrenceOfSpec.location];
        } else {
            strippedFileName = file;
        }
    }
    return strippedFileName;
}

@end
