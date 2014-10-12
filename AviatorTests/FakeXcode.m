#import "FakeXcode.h"

@implementation DVTDocumentLocation
- (id)initWithDocumentURL:(NSURL *)fileUrl timestamp:(id)timestamp { return nil; };
@end
@implementation IDEEditorOpenSpecifier
+ (IDEEditorOpenSpecifier *)structureEditorOpenSpecifierForDocumentLocation:(DVTDocumentLocation *)documentLocation
                                            inWorkspace:(id)workspace
                                                  error:(id)error {return nil;}
@end
@implementation PBXReference
- (BOOL)isGroup { return NO; }
- (id)group { return nil; }
- (id)container { return nil; }
- (NSString *)name { return nil; }
- (NSSet *)includingTargets {
    return nil;
}
- (void)flattenItemsIntoArray:(NSArray *)obj { }
- (NSString *)absolutePath { return nil; }
@end
@implementation PBXFileReference @end
@implementation DVTFilePath@end
@implementation IDESourceCodeDocument
- (NSArray *)knownFileReferences { return nil; }
-(DVTFilePath *)filePath {
    return nil;
}
@end
@implementation PBXTarget
- (NSString *)name { return nil; }
- (BOOL)_looksLikeUnitTestTarget { return NO; }
@end

@implementation PBXContainer
- (NSString *)name { return nil; }
@end
@implementation PBXObject@end
@implementation PBXContainerItem@end

@implementation IDESourceCodeDocumentDouble @end
@implementation PBXTargetDouble @end
@implementation DVTFilePathDouble @end
@implementation PBXFileReferenceDouble @end
