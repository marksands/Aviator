#import "TFFFileSwitcher.h"
#import "XCodePrivate.h"
#import "TFFXcodeDocumentNavigator.h"
#import "TFFFileProvider.h"

@interface TFFFileSwitcher () <NSAlertDelegate>
@property (nonatomic, readonly) TFFFileProvider *fileProvider;
@end

@implementation TFFFileSwitcher

- (instancetype)initWithFileProvider:(TFFFileProvider *)fileProvider {
    if (self = [super init]) {
        _fileProvider = fileProvider;
    }
    return self;
}

- (void)switchBetweenReferenceCollectionFilesForCurrentSourceDocument:(IDESourceCodeDocument *)sourceCodeDocument {
    @try {
        NSLog(@"jumping0.............");
        TFFFileReferenceCollection *referenceCollection = [self.fileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument];
        NSLog(@"jumping1.............");
        NSLog(@"jumping from: %@", sourceCodeDocument.filePath);
        NSString *fileName = sourceCodeDocument.filePath.fileURL.lastPathComponent;
        if ([referenceCollection.headerFile.name isEqualToString:fileName] || [referenceCollection.sourceFile.name isEqualToString:fileName]) {
            if( referenceCollection.testFile == nil ) {
                NSString *testFilename = [[fileName stringByDeletingPathExtension] stringByAppendingString:@"Tests"];
                NSAlert *alert = [[NSAlert alloc]init];
                [alert setDelegate:self];
                [alert addButtonWithTitle:@"Copy test class name"];
                [alert addButtonWithTitle:@"Cancel"];
                [alert setMessageText:[NSString stringWithFormat:@"Can't find %@ in project, maybe you want to create it ?", testFilename]];
                long rCode = [alert runModal];
                if( rCode == NSAlertFirstButtonReturn ) {
                    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
                    [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                    [pasteboard setString:testFilename forType:NSStringPboardType];
                }
            } else {
                NSLog(@"jumping to test file : %@",referenceCollection.testFile.absolutePath);

                [[self XcodeNavigatorClassSeam] jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.testFile.absolutePath]];
            }
        } else if ([referenceCollection.testFile.name isEqualToString:fileName]) {
            if( referenceCollection.sourceFile.absolutePath ) {
                NSLog(@"jumping to source file : %@",referenceCollection.sourceFile.absolutePath);
                [self.XcodeNavigatorClassSeam jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.sourceFile.absolutePath]];
            } else {
                NSLog(@"jumping to headerFile file : %@",referenceCollection.headerFile.absolutePath);

                [self.XcodeNavigatorClassSeam jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.headerFile.absolutePath]];
            }
        }
    } @catch (NSException *e) { NSLog(@"prevented plugin crash from switchBetweenReferenceCollectionFilesForCurrentSourceDocument : %@", e); }
}

- (Class)XcodeNavigatorClassSeam {
    return TFFXcodeDocumentNavigator.class;
}

@end
