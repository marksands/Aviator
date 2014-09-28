#import "TFFileProvider.h"
#import "TFFXcodeDocumentNavigator.h"
#import "XCodePrivate.h"

@implementation TFFileProvider

//- (NSArray *)fileReferences
//{
//    NSArray *projectFiles = [self flattenedProjectContents];
//    return [self arrayOfCPFileReferencesByWrappingXcodeFileReferences:projectFiles];
//}
//
//- (NSArray *)arrayOfCPFileReferencesByWrappingXcodeFileReferences:(NSArray *)xcodeFileReferences
//{
//    NSMutableArray *cpFileReferences = [NSMutableArray array];
//    for (id xcodeFileReference in xcodeFileReferences) {
//        @try {
//            CPFileReference *cpFileRef = [[CPFileReference alloc] initWithPBXFileReference:xcodeFileReference];
//            if (nil != cpFileRef) {
//                [cpFileReferences addObject:cpFileRef];
//            }
//        }
//        @catch (NSException *exception) {}
//    }
//    
//    return cpFileReferences;
//}

- (NSArray *)flattenedProjectContents
{
    NSArray *workspaceReferencedContainers = [[[TFFXcodeDocumentNavigator currentWorkspace] referencedContainers] allObjects];
    NSArray *contents = [NSArray array];
    
    for (IDEContainer *container in workspaceReferencedContainers) {
        if ([container isKindOfClass:[Xcode3Project class]]) {
            Xcode3Project *xc3Project = (Xcode3Project *)container;
            Xcode3Group *xc3RootGroup = [xc3Project rootGroup];
            PBXGroup *mainPBXGroup = [xc3RootGroup group];
            
            contents = [contents arrayByAddingObjectsFromArray:[self recursiveChildrenOfPBXGroup:mainPBXGroup]];
        }
    }
    
    return contents;
}

- (NSArray *)recursiveChildrenOfPBXGroup:(PBXGroup *)pbxGroup
{
    NSMutableArray *objects = [NSMutableArray array];
    
    [objects addObjectsFromArray:[pbxGroup children]];
    
    for (id child in [pbxGroup children]) {
        if ([child isKindOfClass:[PBXGroup class]]) {
            [objects addObjectsFromArray:[self recursiveChildrenOfPBXGroup:child]];
        }
    }
    
    return objects;
}

- (NSArray *)recursiveGroupsOfPBXGroup:(PBXGroup *)pbxGroup
{
    NSMutableArray *objects = [NSMutableArray array];
    
    for (id child in [pbxGroup children]) {
        if ([child isKindOfClass:[PBXGroup class]]) {
            [objects addObject:child];
            [objects addObjectsFromArray:[self recursiveGroupsOfPBXGroup:child]];
        }
    }
    
    return objects;
}

@end
