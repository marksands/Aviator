#import <Foundation/Foundation.h>
#import "XcodePrivate.h"

@interface TFFXcodeDocumentNavigator : NSObject

+ (IDEEditorContext *)currentEditorContext;
+ (id)currentEditor;
+ (IDEWorkspaceDocument *)currentWorkspaceDocument;
+ (IDEWorkspace *)currentWorkspace;
+ (NSString *)currentWorkspacePath;
+ (IDESourceCodeDocument *)currentSourceCodeDocument;

+ (void)jumpToFileURL:(NSURL *)fileURL;

@end

