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
        DVTFilePath *filePath = [sourceCodeDocument filePath];
        NSString *fileName = [[filePath fileURL] lastPathComponent];
        fileName = [self fileNameByStrippingExtensionAndLastOccuranceOfTest:fileName];
        
        TFFReference *headerRef;
        TFFReference *sourceRef;
        TFFReference *testRef;
        
        NSArray *fileReferences = self.fileReferences;
        for (TFFReference *reference in fileReferences) {
            if ([[reference name] rangeOfString:fileName].location != NSNotFound) {
                if (reference.isTestFile) {
                    testRef = reference;
                } else if (reference.isSourceFile) {
                    sourceRef = reference;
                } else if (reference.isHeaderFile) {
                    headerRef = reference;
                }
            }
        }
        
        return [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef
                                                           sourceFileReference:sourceRef
                                                             testFileReference:testRef];
    }
    return nil;
}

#pragma mark - Private

//- (NSArray *)fileReferences {
//    NSArray *projectFiles = [self flattenedProjectContents];
//
//    NSMutableArray *references = [NSMutableArray array];
//    for (PBXReference *pbxReference in projectFiles) {
//        TFFReference *reference = [[TFFReference alloc] initWithPBXReference:pbxReference];
//        if (reference) {
//            [references addObject:reference];
//        }
//    }
//    
//    return [references copy];
//}

- (NSArray *)flattenedProjectContents {
    NSArray *workspaceReferencedContainers = [[[TFFXcodeDocumentNavigator currentWorkspace] referencedContainers] allObjects];
    NSArray *contents = [NSArray array];
    
    for (IDEContainer *container in workspaceReferencedContainers) {
        if ([container isKindOfClass:NSClassFromString(@"Xcode3Project")]) {
            Xcode3Project *project = (Xcode3Project *)container;
            Xcode3Group *rootGroup = [project rootGroup];
            PBXGroup *pbxGroup = [rootGroup group];

            NSMutableArray *groupContents = [NSMutableArray array];
            [pbxGroup flattenItemsIntoArray:groupContents];
            contents = [contents arrayByAddingObjectsFromArray:groupContents];
        }
    }
    
    return contents;
}

#pragma mark - Helper

- (NSString *)fileNameByStrippingExtensionAndLastOccuranceOfTest:(NSString *)fileName {
    NSString *file = [fileName stringByDeletingPathExtension];
    
    if (file.length >= 5) {
        NSRange rangeOfOccuranceOfTest = [file rangeOfString:@"Test" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length-5, 5)];
        if (rangeOfOccuranceOfTest.location == NSNotFound) {
            return file;
        }
        
        return [file substringToIndex:rangeOfOccuranceOfTest.location];
    }
    return file;
}

@end
