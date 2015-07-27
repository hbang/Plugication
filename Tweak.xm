#import "Interfaces.h"

static void AVHeadphonesConnectedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	BOOL isPluggedIn = [[[%c(AVSystemController) sharedAVSystemController] attributeForKey:@"AVSystemController_HeadphoneJackIsConnectedAttribute"] boolValue];
	BOOL inCall = [[TUCallCenter sharedInstance] inCall];
	
	BOOL enabled = [[HBSettingsManager sharedManager] isEnabled];
	BOOL volumeLimitEnabled = [[HBSettingsManager sharedManager] isVolumeLimitEnabled];
	CGFloat volumeLimit = [[HBSettingsManager sharedManager] volumeLimitValue];

	if (enabled && !inCall && isPluggedIn) {
		if (volumeLimitEnabled && [[%c(SBMediaController) sharedInstance] volume] > volumeLimit) {
			[[%c(SBMediaController) sharedInstance] setVolume:volumeLimit];
		}
		[[%c(SBMediaController) sharedInstance] play];
	}

}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &AVHeadphonesConnectedNotification, CFSTR("AVSystemController_HeadphoneJackIsConnectedDidChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	[HBSettingsManager sharedManager];
}