#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "FakeXcode.h"
#import "TFFFileSwitcherDouble.h"
#import "TFFFileProvider.h"
#import "TFFXcodeDocumentNavigatorFake.h"

@interface TFFFileSwitcherTests : XCTestCase
@property (nonatomic) TFFFileSwitcherDouble *testObject;
@property (nonatomic) TFFFileProvider *mockFileProvider;
@property (nonatomic, readonly) TFFXcodeDocumentNavigator *mockDocumentNavigator;
@end

@implementation TFFFileSwitcherTests

- (void)setUp {
    [super setUp];
    
    _mockDocumentNavigator = OCMClassMock([TFFXcodeDocumentNavigator class]);
    _mockFileProvider = OCMClassMock([TFFFileProvider class]);
    _testObject = [[TFFFileSwitcherDouble alloc] initWithFileProvider:self.mockFileProvider];
}

- (void)tearDown {
    _mockFileProvider = nil;
    _testObject = nil;
    [super tearDown];
}

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
    [OCMStub([mockPBXHeaderRef absolutePath]) andReturn:headerFileName];
    return mockPBXHeaderRef;
}

- (PBXFileReferenceDouble *)stubSourceFileName:(NSString *)sourceFileName {
    PBXFileReferenceDouble *mockPBXSourceRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXSourceRef includingTargets]) andReturn:[NSSet setWithArray:@[[self aviatorTarget]]]];
    [OCMStub([mockPBXSourceRef name]) andReturn:sourceFileName];
    [OCMStub([mockPBXSourceRef absolutePath]) andReturn:sourceFileName];
    return mockPBXSourceRef;
}

- (PBXFileReferenceDouble *)stubTestFileName:(NSString *)testFileName {
    PBXFileReferenceDouble *mockPBXTestRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXTestRef includingTargets]) andReturn:[NSSet setWithArray:@[[self testTarget]]]];
    [OCMStub([mockPBXTestRef name]) andReturn:testFileName];
    [OCMStub([mockPBXTestRef absolutePath]) andReturn:testFileName];
    return mockPBXTestRef;
}

- (IDESourceCodeDocumentDouble *)stubSourceCodeDocument:(NSString *)filePath {
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    IDESourceCodeDocumentDouble *sourceCodeDocument = OCMClassMock([IDESourceCodeDocumentDouble class]);
    DVTFilePathDouble *mockFilePath = OCMClassMock([DVTFilePathDouble class]);
    OCMStub([sourceCodeDocument filePath]).andReturn(mockFilePath);
    OCMStub([mockFilePath fileURL]).andReturn(fileURL);
    return sourceCodeDocument;
}

#pragma mark -

- (void)testWhenCurrentSourceDocIsHeaderFileThenNavigatorJumpsToTestFile {
    PBXFileReferenceDouble *mockPBXHeaderRef = [self stubHeaderFileName:@"HanSolo.h"];
    PBXFileReferenceDouble *mockPBXSourceRef = [self stubSourceFileName:@"HanSolo.m"];
    PBXFileReferenceDouble *mockPBXTestRef = [self stubTestFileName:@"HanSoloTests.m"];
    
    TFFReference *headerRef = [[TFFReference alloc] initWithPBXReference:mockPBXHeaderRef];
    TFFReference *sourceRef = [[TFFReference alloc] initWithPBXReference:mockPBXSourceRef];
    TFFReference *testRef = [[TFFReference alloc] initWithPBXReference:mockPBXTestRef];

    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef
                                                                                                  sourceFileReference:sourceRef
                                                                                                    testFileReference:testRef];
    
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:@"HanSolo.m"];
    OCMStub([self.mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);

    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    OCMExpect([fakeNavigator jumpToFileURL:[NSURL fileURLWithPath:@"HanSoloTests.m"]]);

    [self.testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument];
    
    OCMVerifyAll(fakeNavigator);
}

- (void)testWhenCurrentSourceDocIsSourceFileThenNavigatorJumpsToTestFile {
    PBXFileReferenceDouble *mockPBXHeaderRef = [self stubHeaderFileName:@"HanSolo.h"];
    PBXFileReferenceDouble *mockPBXSourceRef = [self stubSourceFileName:@"HanSolo.m"];
    PBXFileReferenceDouble *mockPBXTestRef = [self stubTestFileName:@"HanSoloTests.m"];
    
    TFFReference *headerRef = [[TFFReference alloc] initWithPBXReference:mockPBXHeaderRef];
    TFFReference *sourceRef = [[TFFReference alloc] initWithPBXReference:mockPBXSourceRef];
    TFFReference *testRef = [[TFFReference alloc] initWithPBXReference:mockPBXTestRef];
    
    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef
                                                                                                  sourceFileReference:sourceRef
                                                                                                    testFileReference:testRef];
    
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:@"HanSolo.h"];
    OCMStub([self.mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);
    
    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    OCMExpect([fakeNavigator jumpToFileURL:[NSURL fileURLWithPath:@"HanSoloTests.m"]]);
    
    [self.testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument];
    
    OCMVerifyAll(fakeNavigator);
}

- (void)testWhenCurrentSourceDocIsTestFileThenNavigatorJumpsToSourceFile {
    PBXFileReferenceDouble *mockPBXHeaderRef = [self stubHeaderFileName:@"HanSolo.h"];
    PBXFileReferenceDouble *mockPBXSourceRef = [self stubSourceFileName:@"HanSolo.m"];
    PBXFileReferenceDouble *mockPBXTestRef = [self stubTestFileName:@"HanSoloTests.m"];
    
    TFFReference *headerRef = [[TFFReference alloc] initWithPBXReference:mockPBXHeaderRef];
    TFFReference *sourceRef = [[TFFReference alloc] initWithPBXReference:mockPBXSourceRef];
    TFFReference *testRef = [[TFFReference alloc] initWithPBXReference:mockPBXTestRef];
    
    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef
                                                                                                  sourceFileReference:sourceRef
                                                                                                    testFileReference:testRef];
    
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:@"HanSoloTests.m"];
    OCMStub([self.mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);
    
    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    OCMExpect([fakeNavigator jumpToFileURL:[NSURL fileURLWithPath:@"HanSolo.m"]]);
    
    [self.testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument];
    
    OCMVerifyAll(fakeNavigator);
}

- (void)testWhenCurrentSourceDocIsSourceFileAndNoUnitTestExistsThenNavigatorDoesNotJumpToFile {
    PBXFileReferenceDouble *mockPBXHeaderRef = [self stubHeaderFileName:@"HanSolo.h"];
    PBXFileReferenceDouble *mockPBXSourceRef = [self stubSourceFileName:@"HanSolo.m"];
    
    TFFReference *headerRef = [[TFFReference alloc] initWithPBXReference:mockPBXHeaderRef];
    TFFReference *sourceRef = [[TFFReference alloc] initWithPBXReference:mockPBXSourceRef];
    
    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef
                                                                                                  sourceFileReference:sourceRef
                                                                                                    testFileReference:nil];
    
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:@"HanSoloTests.m"];
    OCMStub([self.mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);
    
    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    [[fakeNavigator reject] jumpToFileURL:[OCMArg any]];
    
    [self.testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument];
    
    OCMVerifyAll(fakeNavigator);
}

- (void)testWhenXcodeNavigatorThrowsExceptionThenFileSwitcherFailsSilently {
    PBXFileReferenceDouble *mockPBXHeaderRef = [self stubHeaderFileName:@"HanSolo.h"];
    PBXFileReferenceDouble *mockPBXSourceRef = [self stubSourceFileName:@"HanSolo.m"];
    PBXFileReferenceDouble *mockPBXTestRef = [self stubTestFileName:@"HanSoloTests.m"];
    
    TFFReference *headerRef = [[TFFReference alloc] initWithPBXReference:mockPBXHeaderRef];
    TFFReference *sourceRef = [[TFFReference alloc] initWithPBXReference:mockPBXSourceRef];
    TFFReference *testRef = [[TFFReference alloc] initWithPBXReference:mockPBXTestRef];
    
    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef
                                                                                                  sourceFileReference:sourceRef
                                                                                                    testFileReference:testRef];
    
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:@"HanSoloTests.m"];
    OCMStub([self.mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);
    
    NSException *exception = [NSException exceptionWithName:@"Exception" reason:@"" userInfo:nil];
    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    OCMStub([fakeNavigator jumpToFileURL:[NSURL fileURLWithPath:@"HanSolo.m"]]).andThrow(exception);
    
    XCTAssertNoThrow([self.testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument]);
}

@end
