#import "TFFSourceAndTestJumper.h"
#import "XCodePrivate.h"
#import "TFFXcodeDocumentNavigator.h"
#import "TFFFileProvider.h"

@implementation TFFSourceAndTestJumper

+ (void)jumpBetweenTestAndImplementationFiles {
    @try {
        TFFFileProvider *provider = [[TFFFileProvider alloc] init];
        IDESourceCodeDocument *currentSourceDoc = [TFFXcodeDocumentNavigator currentSourceCodeDocument];
        TFFFileReferenceCollection *referenceCollection = [provider referenceCollectionForSourceCodeDocument:currentSourceDoc];
        
        NSString *fileName = [[[currentSourceDoc filePath] fileURL] lastPathComponent];
        if ([referenceCollection.headerFile.name isEqualToString:fileName] ||
            [referenceCollection.sourceFile.name isEqualToString:fileName]) {
            [TFFXcodeDocumentNavigator jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.testFile.absolutePath]];
        } else if ([referenceCollection.testFile.name isEqualToString:fileName]) {
            [TFFXcodeDocumentNavigator jumpToFileURL:[NSURL fileURLWithPath:referenceCollection.sourceFile.absolutePath]];
        }
    } @catch (NSException *) {}
}

@end
