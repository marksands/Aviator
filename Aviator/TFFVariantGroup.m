#import "TFFVariantGroup.h"
#import "XCodePrivate.h"

@interface TFFVariantGroup ()
@property (nonatomic, readonly) PBXVariantGroup *pbxVariantGroup;
@end

@implementation TFFVariantGroup

- (instancetype)initWithPBXReference:(PBXVariantGroup *)pbxReference {
    if (self = [super init]) {
        _pbxVariantGroup = pbxReference;
    }
    return self;
}

- (NSString *)name {
    return self.pbxVariantGroup.name;
}

- (NSString *)absolutePath {
    return self.pbxVariantGroup.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxVariantGroup.container;
}

@end
