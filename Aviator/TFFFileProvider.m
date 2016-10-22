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
        
        NSMutableArray *testReferences = [NSMutableArray new];
        
        NSArray *fileReferences = self.fileReferences;
        for (TFFReference *reference in fileReferences) {
            if( ! [reference isKindOfClass:[TFFFileReference class]] ) {
                continue;
            }
            NSRange range = [reference.name rangeOfString:fileName];
            if (range.location != NSNotFound) {
                if (reference.isTestFile) {
                    [testReferences addObject:reference];
                } else if( [reference.name.stringByDeletingPathExtension isEqualToString:fileName] ) {
                    if (reference.isSourceFile) {
                        sourceRef = reference;
                    } else if (reference.isHeaderFile) {
                        headerRef = reference;
                    }
                }
            }
        }
        
        testRef = [self bestMatchingTestReferenceFromTestReferences:testReferences];
        return [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:testRef];
    }
    return nil;
}

#pragma mark - Helper

- (NSString *)fileNameByStrippingExtensionAndLastOccuranceOfTest:(NSString *)fileName {
    NSString *file = [fileName stringByDeletingPathExtension];
    NSString *strippedFileName = file;
    
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

- (TFFReference *)bestMatchingTestReferenceFromTestReferences:(NSArray *)references {
    NSArray * sortedTestReferences = [references sortedArrayUsingComparator:^NSComparisonResult(TFFReference * ref1, TFFReference * ref2) {
        
        NSInteger ref1Score = [self scoreForTestFileName:ref1.name];
        NSInteger ref2Score = [self scoreForTestFileName:ref2.name];
        
        if (ref1Score > ref2Score) {
            return NSOrderedAscending;
        } else if (ref1Score < ref2Score) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedTestReferences.firstObject;
}

- (NSInteger)scoreForTestFileName:(NSString *)testFilename {
    NSString *baseFilename = [testFilename stringByDeletingPathExtension];
    if ([baseFilename hasSuffix:@"Tests"]) {
        return 2;
    } else if ([baseFilename rangeOfString:@"Test"].location != NSNotFound) {
        return 1;
    } else {
        return 0;
    }
}


@end
