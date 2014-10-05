#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <dlfcn.h>
#import "TFFFileReference.h"
#import "TFFFileProvider.h"
#import "FakeXcode.h"

#pragma clang diagnostic push // Silence Build Errors
#pragma clang diagnostic ignored "-Wincomplete-implementation"
//@implementation DVTDocumentLocation@end
//@implementation IDEEditorOpenSpecifier@end
//@implementation PBXReference@end
//@implementation DVTFilePath@end
//@implementation IDESourceCodeDocument@end
//@implementation PBXTarget@end
//@implementation PBXContainer@end
//@implementation PBXObject@end
//@implementation PBXContainerItem@end
#pragma clang diagnostic pop

#pragma mark -

@interface TFFFileProviderTests : XCTestCase
@property (nonatomic) TFFFileProvider *testObject;
@property (nonatomic) IDESourceCodeDocumentDouble *sourceCodeDocument;
@property (nonatomic) NSURL *currentDocumentURL;
@end

@implementation TFFFileProviderTests

+ (void)load {
    //dlopen_preflight("/Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/IDEKit");
    //const char *error1 = dlerror();
    //printf("%s\n", error1);

    //dlopen_preflight("/Applications/Xcode.app/Contents/Frameworks/IDEFoundation.framework/Versions/A/IDEFoundation");
    //const char *error2 = dlerror();
    //printf("%s\n", error2);
    
    //dlopen_preflight("/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/DVTFoundation");
    //const char *error4 = dlerror();
    //printf("%s\n", error4);

    //dlopen_preflight("/Applications/Xcode.app/Contents/SharedFrameworks/DVTKit.framework/Versions/A/DVTKit");
    //const char *error3 = dlerror();
    //printf("%s\n", error3);

    //[NSThread sleepForTimeInterval:1];
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    _sourceCodeDocument = nil;
    _currentDocumentURL = nil;
    _testObject = nil;
    [super tearDown];
}

#pragma mark - Mocks

- (PBXTargetDouble *)testTarget {
    PBXTargetDouble *target = OCMClassMock([PBXTargetDouble class]);
    BOOL yes = YES;
    [OCMStub([target _looksLikeUnitTestTarget]) andReturnValue:OCMOCK_VALUE(yes)];
    return target;
}

- (PBXTargetDouble *)aviatorTarget {
    PBXTargetDouble *target = OCMClassMock([PBXTargetDouble class]);
    BOOL no = NO;
    [OCMStub([target _looksLikeUnitTestTarget]) andReturnValue:OCMOCK_VALUE(no)];
    return target;
}

- (PBXFileReferenceDouble *)stubHeaderFileName:(NSString *)headerFileName {
    PBXFileReferenceDouble *mockPBXHeaderRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXHeaderRef includingTargets]) andReturn:[NSSet setWithArray:@[]]];
    [OCMStub([mockPBXHeaderRef name]) andReturn:headerFileName];
    return mockPBXHeaderRef;
}

- (PBXFileReferenceDouble *)stubSourceFileName:(NSString *)sourceFileName {
    PBXFileReferenceDouble *mockPBXSourceRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXSourceRef includingTargets]) andReturn:[NSSet setWithArray:@[[self aviatorTarget]]]];
    [OCMStub([mockPBXSourceRef name]) andReturn:sourceFileName];
    return mockPBXSourceRef;
}

- (PBXFileReferenceDouble *)stubTestFileName:(NSString *)testFileName {
    PBXFileReferenceDouble *mockPBXTestRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXTestRef includingTargets]) andReturn:[NSSet setWithArray:@[[self testTarget]]]];
    [OCMStub([mockPBXTestRef name]) andReturn:testFileName];
    return mockPBXTestRef;
}

- (void)stubSourceDocument:(NSString *)fileName {
    _currentDocumentURL = [NSURL fileURLWithPath:fileName];
    _sourceCodeDocument = OCMClassMock([IDESourceCodeDocumentDouble class]);
    DVTFilePathDouble *mockFilePath = OCMClassMock([DVTFilePathDouble class]);
    OCMStub([self.sourceCodeDocument filePath]).andReturn(mockFilePath);
    OCMStub([mockFilePath fileURL]).andReturn(self.currentDocumentURL);
}

#pragma mark -

- (void)testWhenSourceFileExistsWithSourceFileAndUnitTestThenReferenceCollectionReturnsExpectedProperties {
    PBXFileReferenceDouble *mockPBXHeaderRef = [self stubHeaderFileName:@"HanSolo.h"];
    PBXFileReferenceDouble *mockPBXSourceRef = [self stubSourceFileName:@"HanSolo.m"];
    PBXFileReferenceDouble *mockPBXTestRef = [self stubTestFileName:@"HanSoloTests.m"];

    TFFReference *headerRef = [[TFFReference alloc] initWithPBXReference:mockPBXHeaderRef];
    TFFReference *sourceRef = [[TFFReference alloc] initWithPBXReference:mockPBXSourceRef];
    TFFReference *testRef = [[TFFReference alloc] initWithPBXReference:mockPBXTestRef];
    
    [self stubSourceDocument:@"HanSolo.m"];

    NSArray *fileReferences = @[headerRef, sourceRef, testRef];
    _testObject = [[TFFFileProvider alloc] initWithFileReferences:fileReferences];
    
    TFFFileReferenceCollection *collection = [self.testObject referenceCollectionForSourceCodeDocument:self.sourceCodeDocument];
    XCTAssertEqualObjects(collection.headerFile, headerRef);
    XCTAssertEqualObjects(collection.sourceFile, sourceRef);
    XCTAssertEqualObjects(collection.testFile, testRef);
}

- (void)testWhenSourceFileExistsWithNoUnitTestThenReferenceCollectionReturnsNilTestFile {
    
}

- (void)testWhenSourceFileExistsWithUnitTestHavingDifferentNameThenReferenceCollectionReturnsNilTestFile {
    
}

- (void)testWhenSourceFileExistsWithAnotherSourceFileHavingSimilarNameAndNoUnitTestThenReferenceCollectionReturnsNilTestFile {
    
}

@end
