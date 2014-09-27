#import "TFFXcodeDocumentNavigator.h"

@implementation TFFXcodeDocumentNavigator

+ (IDEEditorContext *)currentEditorContext {
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEWorkspaceWindowController *workspaceController = (IDEWorkspaceWindowController *)currentWindowController;
        IDEEditorArea *editorArea = [workspaceController editorArea];
        return [editorArea lastActiveEditorContext];
    }
    return nil;
}

+ (id)currentEditor {
    IDEEditorContext *currentEditorContext = [self currentEditorContext];
    if (currentEditorContext) {
        return [currentEditorContext editor];
    }
    return nil;
}

+ (IDEWorkspaceDocument *)currentWorkspaceDocument {
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    id document = [currentWindowController document];
    if (currentWindowController && [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        return (IDEWorkspaceDocument *)document;
    }
    return nil;
}

+ (IDEWorkspace *)currentWorkspace {
    return [[self currentWorkspaceDocument] workspace];
}

+ (NSString *)currentWorkspacePath {
    IDEWorkspaceDocument *document = [TFFXcodeDocumentNavigator currentWorkspaceDocument];
    return [[document fileURL] path];
}

+ (IDESourceCodeDocument *)currentSourceCodeDocument {
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        IDESourceCodeEditor *editor = [self currentEditor];
        return editor.sourceCodeDocument;
    }
    
    if ([[self currentEditor] isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")]) {
        IDESourceCodeComparisonEditor *editor = [self currentEditor];
        if ([[editor primaryDocument] isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
            IDESourceCodeDocument *document = (IDESourceCodeDocument *)editor.primaryDocument;
            return document;
        }
    }
    
    return nil;
}

+ (void)jumpToFileURL:(NSURL *)fileURL {
    //    id controller = [NSClassFromString(@"IDEApplicationController") performSelector:@selector(sharedAppController)];
    //    id sharedApp = [NSClassFromString(@"IDEApplication") performSelector:@selector(sharedApplication)];
    ////    [controller performSelector:@selector(application:openFile:) withObject:sharedApp withObject:fileURL.absoluteString];
    
    //@interface DVTDocumentLocation <NSObject>
    //- (DVTDocumentLocation *)initWithDocumentURL:(NSURL *)documentURL timestamp:(NSNumber *)timestamp;
    //- (NSURL *)documentURL;
    //@end
    
    DVTDocumentLocation *documentLocation = [[DVTDocumentLocation alloc] initWithDocumentURL:fileURL timestamp:nil];
    
    IDEEditorOpenSpecifier *openSpecifier = [IDEEditorOpenSpecifier structureEditorOpenSpecifierForDocumentLocation:documentLocation
                                                                                                        inWorkspace:[self currentWorkspace]
                                                                                                              error:nil];
    
                                             [[self currentEditorContext] openEditorOpenSpecifier:openSpecifier];
}

@end
