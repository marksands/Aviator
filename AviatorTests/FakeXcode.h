#import "XCodePrivate.h"

@implementation DVTDocumentLocation@end
@implementation IDEEditorOpenSpecifier@end
@implementation PBXReference
- (NSString *)name { return nil; }
- (NSSet *)includingTargets {
    return nil;
}
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

@interface IDESourceCodeDocumentDouble : IDESourceCodeDocument @end
@implementation IDESourceCodeDocumentDouble @end

@interface PBXTargetDouble : PBXTarget @end
@implementation PBXTargetDouble @end

@interface DVTFilePathDouble : DVTFilePath @end
@implementation DVTFilePathDouble @end

@interface PBXFileReferenceDouble : PBXFileReference @end
@implementation PBXFileReferenceDouble @end
