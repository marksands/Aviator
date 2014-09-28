#import "TFFReference.h"
#import "TFFGroup.h"
#import "TFFVariantGroup.h"
#import "TFFFileReference.h"

@implementation TFFReference

- (instancetype)initWithPBXReference:(PBXReference *)pbxReference {
    if ([pbxReference isKindOfClass:NSClassFromString(@"PBXGroup")]) {
        return [[TFFGroup alloc] initWithPBXReference:pbxReference];
    } else if ([pbxReference isKindOfClass:NSClassFromString(@"PBXFileReference")]) {
        return [[TFFFileReference alloc] initWithPBXReference:pbxReference];
    } else if ([pbxReference isKindOfClass:NSClassFromString(@"PBXVariantGroup")]) {
        return [[TFFVariantGroup alloc] initWithPBXReference:pbxReference];
    }
    return nil;
}

@end
