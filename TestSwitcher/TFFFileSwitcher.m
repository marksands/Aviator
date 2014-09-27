#import "TFFFileSwitcher.h"
#import "XCodePrivate.h"
#import "TFFXcodeDocumentNavigator.h"

@implementation TFFFileSwitcher

+ (void)switchToTestOrImplementationFile {
    @try {
        IDESourceCodeDocument *document = [TFFXcodeDocumentNavigator currentSourceCodeDocument];
        DVTFilePath *filePath = [document filePath];
        NSURL *fileUrl = [self testOrImplementationFileForCurrentFile:[filePath fileURL]];
        
        [TFFXcodeDocumentNavigator jumpToFileURL:fileUrl];
    } @catch (NSException *) {}
}

+ (NSURL *)testOrImplementationFileForCurrentFile:(NSURL *)fileUrl {
    NSString *fileName = [[fileUrl URLByDeletingPathExtension] lastPathComponent];
    
    NSString *urlString = [[fileUrl URLByDeletingPathExtension] path];
    BOOL isTestFile = [[fileName substringWithRange:NSMakeRange(fileName.length - 5, 5)] isEqualToString:@"Tests"];
    if (isTestFile) {
        urlString = [urlString stringByReplacingCharactersInRange:NSMakeRange(urlString.length-5, 5) withString:@""];
        return [[NSURL fileURLWithPath:urlString] URLByAppendingPathExtension:@"m"];
    }
    
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@Tests.m", urlString]];
}

@end
