#import <Foundation/Foundation.h>
#import "XCodePrivate.h"

@interface TFFReference : NSObject

- (instancetype)initWithPBXReference:(PBXReference *)pbxReference;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *absolutePath;
@property (nonatomic, readonly) PBXContainer *container;

@end
