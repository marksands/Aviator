#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "TFFFileReference.h"
#import "TFFFileProvider.h"
#import "FakeXcode.h"

#pragma mark -

@interface TFFFileProviderTests : XCTestCase {
    TFFFileProvider *testObject;
    IDESourceCodeDocumentDouble *sourceCodeDocument;
    NSURL *currentDocumentURL;
}

@end

@implementation TFFFileProviderTests

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

- (PBXFileReferenceDouble *)stubbedFileReferenceWithTargets:(NSArray *)targets fileName:(NSString *)fileName {
    PBXFileReferenceDouble *mockPBXRef = OCMClassMock([PBXFileReferenceDouble class]);
    [OCMStub([mockPBXRef includingTargets]) andReturn:[NSSet setWithArray:targets]];
    [OCMStub([mockPBXRef name]) andReturn:fileName];
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

- (void)setCurrentDocumentAsFile:(NSString *)fileName {
    currentDocumentURL = [NSURL fileURLWithPath:fileName];
    sourceCodeDocument = OCMClassMock([IDESourceCodeDocumentDouble class]);
    DVTFilePathDouble *mockFilePath = OCMClassMock([DVTFilePathDouble class]);
    OCMStub([sourceCodeDocument filePath]).andReturn(mockFilePath);
    OCMStub([mockFilePath fileURL]).andReturn(currentDocumentURL);
}

- (void)verifyReferenceCollectionHeader:(TFFReference *)headerRef source:(TFFReference *)sourceRef test:(TFFReference *)testRef {
    TFFFileReferenceCollection *collection = [testObject referenceCollectionForSourceCodeDocument:sourceCodeDocument];
    XCTAssertEqualObjects(collection.headerFile, headerRef);
    XCTAssertEqualObjects(collection.sourceFile, sourceRef);
    XCTAssertEqualObjects(collection.testFile, testRef);
}

#pragma mark -

- (void)testWhenSourceFileIsNilThenReferenceCollectionReturnsNil {
    TFFFileReferenceCollection *collection = [testObject referenceCollectionForSourceCodeDocument:nil];
    XCTAssertNil(collection);
}

- (void)testWhenSourceFileExistsWithSourceFileAndUnitTestThenReferenceCollectionReturnsExpectedProperties {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];
    TFFReference *testRef = [self testReferenceWithName:@"HanSoloTests.m"];

    testObject = [[TFFFileProvider alloc] initWithFileReferences:@[headerRef, sourceRef, testRef]];
    [self setCurrentDocumentAsFile:@"HanSolo.m"];
    [self verifyReferenceCollectionHeader:headerRef source:sourceRef test:testRef];
}

- (void)testWhenSourceFileExistsWithNoUnitTestThenReferenceCollectionReturnsNilTestFile {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];

    testObject = [[TFFFileProvider alloc] initWithFileReferences:@[headerRef, sourceRef]];
    [self setCurrentDocumentAsFile:@"HanSolo.m"];
    [self verifyReferenceCollectionHeader:headerRef source:sourceRef test:nil];
}

- (void)testWhenSourceFileExistsWithUnitTestHavingDifferentNameThenReferenceCollectionReturnsNilTestFile {
    TFFReference *headerRef = [self headerReferenceWithName:@"HanSolo.h"];
    TFFReference *sourceRef = [self sourceReferenceWithName:@"HanSolo.m"];
    TFFReference *testRef = [self testReferenceWithName:@"StarWarsTest.m"];

    testObject = [[TFFFileProvider alloc] initWithFileReferences:@[headerRef, sourceRef, testRef]];
    [self setCurrentDocumentAsFile:@"HanSolo.m"];
    [self verifyReferenceCollectionHeader:headerRef source:sourceRef test:nil];
}

- (void)testWhenSourceFileExistsWithAnotherSourceFileHavingSimilarNameAndNoUnitTestThenReferenceCollectionReturnsNilTestFile {
    TFFReference *headerRef1 = [self headerReferenceWithName:@"StarWars.h"];
    TFFReference *sourceRef1 = [self sourceReferenceWithName:@"StarWars.m"];
    TFFReference *headerRef2 = [self headerReferenceWithName:@"StarWar.h"];
    TFFReference *sourceRef2 = [self sourceReferenceWithName:@"StarWar.m"];
    TFFReference *testRef2 = [self testReferenceWithName:@"StarWarTests.m"];
    
    testObject = [[TFFFileProvider alloc] initWithFileReferences:@[headerRef1, sourceRef1, headerRef2, sourceRef2, testRef2]];
    [self setCurrentDocumentAsFile:@"StarWars.m"];
    [self verifyReferenceCollectionHeader:headerRef1 source:sourceRef1 test:nil];
}

- (void)testWhenSourceFileExistsWithMultipleMatchingUnitTestFilesThenReturnTestFileWithSuffixTests {
    TFFReference *headerRef1 = [self headerReferenceWithName:@"StarWars.h"];
    TFFReference *sourceRef1 = [self sourceReferenceWithName:@"StarWars.m"];
    TFFReference *testRef1 = [self testReferenceWithName:@"StarWarsTests.m"];
    TFFReference *testRef2 = [self testReferenceWithName:@"StubStarWars.m"];
    
    testObject = [[TFFFileProvider alloc] initWithFileReferences:@[headerRef1, sourceRef1, testRef1, testRef2]];
    [self setCurrentDocumentAsFile:@"StarWars.m"];
    [self verifyReferenceCollectionHeader:headerRef1 source:sourceRef1 test:testRef1];
}

@end
