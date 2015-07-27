#import <Celestial/Celestial.h>
#import "HBSettingsManager.h"

@interface SBMediaController

+ (instancetype)sharedInstance;

- (void)play;

- (void)setVolume:(float)volume;

- (float)volume;

@end

@interface TUCallCenter

+ (instancetype)sharedInstance;

- (BOOL)inCall;

@end