#import "HBSettingsManager.h"

@interface HBSettingsManager ()

@property (nonatomic, copy) NSDictionary *settings;

@end

@implementation HBSettingsManager

+ (instancetype)sharedManager {
    static dispatch_once_t p = 0;
    __strong static id _sharedSelf = nil;
    dispatch_once(&p, ^{
        _sharedSelf = [[self alloc] init];
    });
    return _sharedSelf;
}

void settingsChanged(CFNotificationCenterRef center,
                     void * observer,
                     CFStringRef name,
                     const void * object,
                     CFDictionaryRef userInfo) {
    [[HBSettingsManager sharedManager] updateSettings];
}

- (id)init {
    if (self = [super init]) {
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChanged, CFSTR("ws.hbang.plugication/preferenceschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        [self updateSettings];
    }
    
    return self;
}

- (void)updateSettings {
    
    self.settings = nil;
    
    CFPreferencesAppSynchronize(CFSTR("ws.hbang.plugication"));
    CFStringRef appID = CFSTR("ws.hbang.plugication");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID , kCFPreferencesCurrentUser, kCFPreferencesAnyHost) ?: CFArrayCreate(NULL, NULL, 0, NULL);
    self.settings = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID , kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);

    HBLogDebug(@"%@", self.settings);
    
}

- (BOOL)isEnabled {
    return self.settings[@"enabled"] ? [self.settings[@"enabled"] boolValue] : YES;
}

- (BOOL)isVolumeLimitEnabled {
    return self.settings[@"useVolumeLimit"] ? [self.settings[@"useVolumeLimit"] boolValue] : YES;
}

- (CGFloat)volumeLimitValue {
    return self.settings[@"volumeLimitValue"] ? [self.settings[@"volumeLimitValue"] floatValue] : 0.5;
}

@end