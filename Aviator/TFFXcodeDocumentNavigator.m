#import "TFFXcodeDocumentNavigator.h"

@interface TFFXcodeDocumentNavigator ()

+ (IDEEditorContext *)currentEditorContext;
+ (id)currentEditor;
+ (IDEWorkspaceDocument *)currentWorkspaceDocument;
+ (IDEWorkspace *)currentWorkspace;

@end

@implementation TFFXcodeDocumentNavigator

+ (IDEEditorContext *)currentEditorContext {
    IDEEditorContext *editorContext = nil;
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEEditorArea *editorArea = [(IDEWorkspaceWindowController *)currentWindowController editorArea];
        editorContext = editorArea.lastActiveEditorContext;
    }
    return editorContext;
}

+ (id)currentEditor {
    return self.currentEditorContext.editor;
}

+ (IDEWorkspaceDocument *)currentWorkspaceDocument {
    IDEWorkspaceDocument *workspaceDocument = nil;
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if (currentWindowController && [currentWindowController.document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        workspaceDocument = (IDEWorkspaceDocument *)currentWindowController.document;
    }
    return workspaceDocument;
}

+ (IDEWorkspace *)currentWorkspace {
    return self.currentWorkspaceDocument.workspace;
}

+ (IDESourceCodeDocument *)currentSourceCodeDocument {
    IDESourceCodeDocument *sourceCodeDocument = nil;
    
    if ([self.currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        sourceCodeDocument = [self.currentEditor sourceCodeDocument];
    } else if ([self.currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")] && [[self.currentEditor primaryDocument] isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
        sourceCodeDocument = (IDESourceCodeDocument *)[self.currentEditor primaryDocument];
    }
    
    return sourceCodeDocument;
}

+ (void)jumpToFileURL:(NSURL *)fileURL {
    DVTDocumentLocation *documentLocation = [[DVTDocumentLocation alloc] initWithDocumentURL:fileURL timestamp:nil];
    IDEEditorOpenSpecifier *openSpecifier = [IDEEditorOpenSpecifier structureEditorOpenSpecifierForDocumentLocation:documentLocation inWorkspace:self.currentWorkspace error:nil];
    [self.currentEditorContext openEditorOpenSpecifier:openSpecifier];
}

@end
