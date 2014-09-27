#import <Foundation/Foundation.h>
#import "XcodePrivate.h"

@class DVTDocumentLocation;

@interface TFFXcodeDocumentNavigator : NSObject

+ (IDEEditorContext *)currentEditorContext;
+ (id)currentEditor;
+ (IDEWorkspaceDocument *)currentWorkspaceDocument;
+ (IDEWorkspace *)currentWorkspace;
+ (NSString *)currentWorkspacePath;

+ (void)jumpToFileURL:(NSURL *)fileURL;

@end

