#import "TFFFileProvider.h"
#import "TFFXcodeDocumentNavigator.h"
#import "XCodePrivate.h"
#import "TFFReference.h"

@implementation TFFFileProvider

- (NSArray *)fileReferences {
    NSArray *projectFiles = [self flattenedProjectContents];

    NSMutableArray *references = [NSMutableArray array];
    for (PBXReference *pbxReference in projectFiles) {
        TFFReference *reference = [[TFFReference alloc] initWithPBXReference:pbxReference];
        if (reference) {
            [references addObject:reference];
        }
    }
    
    return [references copy];
}

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

@end
