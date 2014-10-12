#import "TFFFileSwitcherDouble.h"
#import "TFFXcodeDocumentNavigatorFake.h"

@implementation TFFFileSwitcherDouble

- (Class)XcodeNavigatorClassSeam {
    return [TFFXcodeDocumentNavigatorFake class];
}

@end
