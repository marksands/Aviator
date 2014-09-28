#import "TFFGroup.h"
#import "XCodePrivate.h"

@interface TFFGroup ()
@property (nonatomic, readonly) PBXGroup *pbxGroup;
@end

@implementation TFFGroup

- (instancetype)initWithPBXReference:(PBXGroup *)pbxReference {
    if (self = [super init]) {
        _pbxGroup = pbxReference;
    }
    return self;
}

- (NSString *)name {
    return self.pbxGroup.name;
}

- (NSString *)absolutePath {
    return self.pbxGroup.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxGroup.container;
}

@end
