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
- (NSSet *)referencedContainers;
@end

@interface IDEWorkspaceDocument : NSDocument
@property (readonly) IDEWorkspace *workspace;
@end

@interface DVTModelObject : NSObject
@end

@interface IDEContainerItem : DVTModelObject
@end

@interface IDEGroup : IDEContainerItem
- (NSArray *)subitems;
- (NSImage *)navigableItem_image;
@end

@interface IDEContainer : DVTModelObject
- (DVTFilePath *)filePath;
- (IDEGroup *)rootGroup;
- (void)debugPrintInnerStructure;
- (void)debugPrintStructure;
@end

@interface PBXObject : NSObject
@end

@interface PBXContainer : PBXObject
- (NSString *)name;
@end

@interface PBXContainerItem : PBXObject
@end

@class PBXGroup;
@interface PBXReference : PBXContainerItem
- (BOOL)isGroup;
- (NSString *)name;
- (NSString *)absolutePath;
- (PBXGroup *)group;
- (PBXContainer *)container;
@end

@interface PBXGroup : PBXReference
- (NSArray *)children;
@end

@interface Xcode3Group : IDEGroup
- (PBXGroup *)group;
@end

@interface Xcode3Project : IDEContainer
- (Xcode3Group *)rootGroup;
@end
