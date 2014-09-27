#import <Cocoa/Cocoa.h>

@interface DVTDocumentLocation : NSObject
- (DVTDocumentLocation *)initWithDocumentURL:(NSURL *)documentURL timestamp:(NSNumber *)timestamp;
@end

@interface DVTFileDataType : NSObject
@end

@interface DVTFilePath : NSObject
@property (readonly) NSURL *fileURL;
@end

@interface IDENavigableItem : NSObject
@end

@interface IDENavigatorArea : NSObject
@end

@interface IDEWorkspaceTabController : NSObject
@end

@interface IDESourceCodeDocument : NSDocument
- (DVTFilePath *)filePath;
@end

@class DVTDocumentLocation;
@interface IDEEditorOpenSpecifier : NSObject
+ (IDEEditorOpenSpecifier *)structureEditorOpenSpecifierForDocumentLocation:(DVTDocumentLocation *)documentLocation inWorkspace:(id)workspace error:(NSError *)error;
@end

@interface IDESourceCodeComparisonEditor : NSObject
@property (retain) NSDocument *primaryDocument;
@end

@interface IDESourceCodeEditor : NSObject
- (IDESourceCodeDocument *)sourceCodeDocument;
@end

@interface IDEEditorContext : NSObject
- (BOOL)openEditorOpenSpecifier:(id)openSpecifier;
- (id)editor;
@end

@interface IDEEditorArea : NSObject
- (IDEEditorContext *)lastActiveEditorContext;
@end

@interface IDEWorkspaceWindowController : NSObject
- (IDEEditorArea *)editorArea;
@end

@interface IDEWorkspace : NSObject
@end

@interface IDEWorkspaceDocument : NSDocument
@property (readonly) IDEWorkspace *workspace;
@end
