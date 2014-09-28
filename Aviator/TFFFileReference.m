#import "TFFFileReference.h"
#import "XCodePrivate.h"

@interface TFFFileReference ()
@property (nonatomic, readonly) PBXFileReference *pbxFileReference;
@end

@implementation TFFFileReference

- (instancetype)initWithPBXReference:(PBXFileReference *)pbxReference {
    if (self = [super init]) {
        _pbxFileReference = pbxReference;
    }
    return self;
}

- (NSString *)name {
    return self.pbxFileReference.name;
}

- (NSString *)absolutePath {
    return self.pbxFileReference.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxFileReference.container;
}

@end
