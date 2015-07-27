@interface HBSettingsManager : NSObject

@property (nonatomic, readonly, getter=isEnabled) BOOL enabled;

@property (nonatomic, readonly, getter=isVolumeLimitEnabled) BOOL volumeLimitEnabled;

@property (nonatomic, readonly, getter=volumeLimitValue) CGFloat volumeLimitValue;

+ (instancetype)sharedManager;

- (void)updateSettings;

@end