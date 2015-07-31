#import "Aviator.h"
#import "TFFFileSwitcher.h"
#import "TFFFileProvider.h"
#import "TFFXcodeDocumentNavigator.h"
#import "TFFFileReferenceProvider.h"

static Aviator *sharedPlugin;

@implementation Aviator

+ (void)pluginDidLoad:(NSBundle *)plugin {
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[Aviator alloc] init];
        });
    }
}

- (instancetype)init {
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunchingNotification:)
                                                 name:NSApplicationDidFinishLaunchingNotification
                                               object:nil];
    return self;
}

- (void)applicationDidFinishLaunchingNotification:(NSNotification *)notification {
    [self removeConflictingKeyBinding];
    [self addJumpItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
}

#pragma mark - 

- (void)removeConflictingKeyBinding {
    @try{
        NSMenuItem *fileItem = [[NSApp mainMenu] itemWithTitle:@"File"];
        NSMenuItem *newWindowItem = [[[[[fileItem submenu] itemArray] firstObject] submenu] itemArray][1];
        [newWindowItem setKeyEquivalentModifierMask:NSShiftKeyMask | NSAlternateKeyMask | NSCommandKeyMask];
    } @catch(NSException *) {}
}

// TODO: Investigate why "Navigate" doesn't work
- (void)addJumpItem {
    NSMenuItem *navigateItem = [[NSApp mainMenu] itemWithTitle:@"Find"];
    if (navigateItem) {
        [[navigateItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *jumpItem = [[NSMenuItem alloc] initWithTitle:@"Jump to Test File" action:@selector(jumpToFile) keyEquivalent:@"t"];
        [jumpItem setKeyEquivalentModifierMask:NSCommandKeyMask | NSShiftKeyMask];
        [jumpItem setTarget:self];
        [jumpItem setHidden:NO];
        
        [[navigateItem submenu] addItem:jumpItem];
    }
}

- (void)jumpToFile {
    TFFFileReferenceProvider *fileReferenceProvider = [[TFFFileReferenceProvider alloc] init];
    NSArray *fileReferences = [fileReferenceProvider fileReferences];
    
    TFFFileProvider *fileProvider = [[TFFFileProvider alloc] initWithFileReferences:fileReferences];
    TFFFileSwitcher *fileSwitcher = [[TFFFileSwitcher alloc] initWithFileProvider:fileProvider];
    
    [fileSwitcher switchBetweenReferenceCollectionFilesForCurrentSourceDocument:TFFXcodeDocumentNavigator.currentSourceCodeDocument];
}

@end
