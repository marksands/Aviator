#import "TFFFileSwitcher.h"
#import "XCodePrivate.h"
#import "TFFXcodeDocumentNavigator.h"
#import "TFFFileProvider.h"

@interface TFFFileSwitcher ()
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
        TFFFileReferenceCollection *referenceCollection = [self.fileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument];
        
        NSString *fileName = sourceCodeDocument.filePath.fileURL.lastPathComponent;
        if ([referenceCollection.headerFile.name isEqualToString:fileName] || [referenceCollection.sourceFile.name isEqualToString:fileName]) {
            [self.XcodeNavigatorClassSeam jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.testFile.absolutePath]];
        } else if ([referenceCollection.testFile.name isEqualToString:fileName]) {
            [self.XcodeNavigatorClassSeam jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.sourceFile.absolutePath]];
        }
    } @catch (NSException *) {}
}

- (Class)XcodeNavigatorClassSeam {
    return TFFXcodeDocumentNavigator.class;
}

@end
