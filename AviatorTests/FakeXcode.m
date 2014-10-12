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
- (NSString *)name { return nil; }
- (NSSet *)includingTargets {
    return nil;
}
- (NSString *)absolutePath { return nil; }
@end
@implementation PBXFileReference @end
@implementation DVTFilePath@end
@implementation IDESourceCodeDocument
-(DVTFilePath *)filePath {
    return nil;
}
@end
@implementation PBXTarget
- (BOOL)_looksLikeUnitTestTarget { return NO; }
@end

@implementation PBXContainer@end
@implementation PBXObject@end
@implementation PBXContainerItem@end

@implementation IDESourceCodeDocumentDouble @end
@implementation PBXTargetDouble @end
@implementation DVTFilePathDouble @end
@implementation PBXFileReferenceDouble @end
