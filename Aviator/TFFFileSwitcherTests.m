#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "FakeXcode.h"
#import "TFFFileSwitcherDouble.h"
#import "TFFFileProvider.h"
#import "TFFXcodeDocumentNavigatorFake.h"

@interface TFFFileSwitcherTests : XCTestCase {
    TFFFileSwitcherDouble *testObject;
    TFFFileProvider *mockFileProvider;
    TFFXcodeDocumentNavigator *mockDocumentNavigator;
}
@end

@implementation TFFFileSwitcherTests

- (void)setUp {
    [super setUp];
    
    mockDocumentNavigator = OCMClassMock([TFFXcodeDocumentNavigator class]);
    mockFileProvider = OCMClassMock([TFFFileProvider class]);
    testObject = [[TFFFileSwitcherDouble alloc] initWithFileProvider:mockFileProvider];
}

- (PBXTargetDouble *)testTarget {
    PBXTargetDouble *target = OCMClassMock([PBXTargetDouble class]);
    [OCMStub([target targetTypeDisplayName]) andReturn:@""];
    return target;
}

- (PBXTargetDouble *)aviatorTarget {
    PBXTargetDouble *target = OCMClassMock([PBXTargetDouble class]);
    [OCMStub([target targetTypeDisplayName]) andReturn:@"Bundle"];
    return target;
}

- (PBXFileReferenceDouble *)stubbedFileReferenceWithTargets:(NSArray *)targets fileName:(NSString *)fileName {
    PBXFileReferenceDouble *mockPBXRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXRef includingTargets]) andReturn:[NSSet setWithArray:targets]];
    [OCMStub([mockPBXRef name]) andReturn:fileName];
    [OCMStub([mockPBXRef absolutePath]) andReturn:fileName];
    return mockPBXRef;
}

- (TFFReference *)headerReferenceWithName:(NSString *)name {
    return [[TFFReference alloc] initWithPBXReference:[self stubbedFileReferenceWithTargets:@[] fileName:name]];
}

- (TFFReference *)sourceReferenceWithName:(NSString *)name {
    return [[TFFReference alloc] initWithPBXReference:[self stubbedFileReferenceWithTargets:@[self.aviatorTarget] fileName:name]];
}

- (TFFReference *)testReferenceWithName:(NSString *)name {
    return [[TFFReference alloc] initWithPBXReference:[self stubbedFileReferenceWithTargets:@[self.testTarget] fileName:name]];
}

- (IDESourceCodeDocumentDouble *)stubSourceCodeDocument:(NSString *)filePath {
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    IDESourceCodeDocumentDouble *sourceCodeDocument = OCMClassMock([IDESourceCodeDocumentDouble class]);
    DVTFilePathDouble *mockFilePath = OCMClassMock([DVTFilePathDouble class]);
    OCMStub([sourceCodeDocument filePath]).andReturn(mockFilePath);
    OCMStub([mockFilePath fileURL]).andReturn(fileURL);
    return sourceCodeDocument;
}

- (void)verifyTransitionFromCurrentFile:(NSString *)currentFileName toFile:(NSString *)transitioningFileName forReferenceCollection:(TFFFileReferenceCollection *)referenceCollection {
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:currentFileName];
    OCMStub([mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);

    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    OCMExpect([fakeNavigator jumpToFileURL:[NSURL fileURLWithPath:transitioningFileName]]);
    [testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument];
    OCMVerifyAll(fakeNavigator);
}

- (void)verifyNoTransitionFromCurrentFile:(NSString *)currentFileName toFile:(NSString *)transitioningFileName forReferenceCollection:(TFFFileReferenceCollection *)referenceCollection {
    IDESourceCodeDocumentDouble *sourceCodeDocument = [self stubSourceCodeDocument:currentFileName];
    OCMStub([mockFileProvider referenceCollectionForSourceCodeDocument:sourceCodeDocument]).andReturn(referenceCollection);

    id fakeNavigator = OCMClassMock(TFFXcodeDocumentNavigatorFake.class);
    [[fakeNavigator reject] jumpToFileURL:OCMOCK_ANY];
    [testObject switchBetweenReferenceCollectionFilesForCurrentSourceDocument:sourceCodeDocument];
    OCMVerifyAll(fakeNavigator);
}

#pragma mark -

- (void)testWhenCurrentSourceDocIsHeaderFileThenNavigatorJumpsToTestFile {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];
    TFFReference *testRef = [self testReferenceWithName:@"HanSoloTests.m"];

    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:testRef];
    [self verifyTransitionFromCurrentFile:@"HanSolo.h" toFile:@"HanSoloTests.m" forReferenceCollection:referenceCollection];
}

- (void)testWhenCurrentSourceDocIsSourceFileThenNavigatorJumpsToTestFile {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];
    TFFReference *testRef = [self testReferenceWithName:@"HanSoloTests.m"];

    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:testRef];
    [self verifyTransitionFromCurrentFile:@"HanSolo.m" toFile:@"HanSoloTests.m" forReferenceCollection:referenceCollection];
}

- (void)testWhenCurrentSourceDocIsTestFileThenNavigatorJumpsToSourceFile {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];
    TFFReference *testRef = [self testReferenceWithName:@"HanSoloTests.m"];
    
    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:testRef];
    [self verifyTransitionFromCurrentFile:@"HanSoloTests.m" toFile:@"HanSolo.m" forReferenceCollection:referenceCollection];
}

- (void)testWhenCurrentSourceDocIsSourceFileAndNoUnitTestExistsThenNavigatorDoesNotJumpToFile {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];

    TFFFileReferenceCollection *referenceCollection = [[TFFFileReferenceCollection alloc] initWithHeaderFileReference:headerRef sourceFileReference:sourceRef testFileReference:nil];
    [self verifyNoTransitionFromCurrentFile:@"HanSoloTests.m" toFile:nil forReferenceCollection:referenceCollection];
}

@end
