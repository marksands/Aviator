#import "Aviator.h"
#import "TFFFileSwitcher.h"
#import "TFFileProvider.h"

static Aviator *sharedPlugin;

@interface Aviator()
@end

@implementation Aviator

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[self alloc] init];
        });
    }
}

- (id)init {
    if (self = [super init]) {
        [self removeConflictingKeyBinding];
        [self addJumpItem];
        
        TFFileProvider *provider = [[TFFileProvider alloc] init];
        NSArray *contents = [provider flattenedProjectContents];
        NSLog(@"contents: %@", contents);
    }
    return self;
}

#pragma mark - 

// TODO: Rather than remove the item, modify the shortcut key?
- (void)removeConflictingKeyBinding {
    @try{
        NSMenuItem *fileItem = [[NSApp mainMenu] itemWithTitle:@"File"];
        NSMenuItem *newMenu = [[[fileItem submenu] itemArray] firstObject];
        NSMenuItem *newWindowItem = [[[[[fileItem submenu] itemArray] firstObject] submenu] itemArray][1];
        [[newMenu submenu] removeItem:newWindowItem];
    } @catch(NSException *) {}
}

// TODO: Investigate why "Navigate" doesn't work
- (void)addJumpItem {
    NSMenuItem *navigateItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (navigateItem) {
        [[navigateItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *jumpItem = [[NSMenuItem alloc] initWithTitle:@"Jump to Test File" action:@selector(jumpToFile) keyEquivalent:@"t"];
        [jumpItem setKeyEquivalentModifierMask:NSCommandKeyMask | NSShiftKeyMask];
        [jumpItem setTarget:self];
        
        [[navigateItem submenu] addItem:jumpItem];
    }
}

- (void)jumpToFile {
    [TFFFileSwitcher switchToTestOrImplementationFile];
}

@end
