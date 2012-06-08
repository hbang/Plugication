/**
 * Plugication - start playing music when headphones are connected
 * So dead simple that Apple should have already done it.
 *
 * By Ad@m <http://adam.hbang.ws>
 * Licensed under the MIT License <http://adam.mit-license.org>
 * WTFPL if you work at Apple <http://sam.zoy.org/wtfpl>
 */

#import <SpringBoard/SpringBoard.h>
#import <SpringBoardServices/SpringBoardServices.h>
#import <CoreFoundation/CFNotificationCenter.h>
#import <Celestial/Celestial.h>

#define prefpath @"/var/mobile/Library/Preferences/ws.hbang.plugication.plist"

static BOOL headphones=NO;
static BOOL shouldPlay=YES;
static BOOL shouldPause=YES;
static BOOL useHeadphones=YES;
static BOOL useBluetooth=YES;
static BOOL useDock=YES; //not implemented
static float volumeLimit=0.8;
static NSString *defaultApp=@"";
static NSMutableDictionary *prefs;
static BOOL shouldRepeat=NO;
static BOOL shouldShuffle=NO;
static NSMutableArray *_stacks=[[[NSMutableArray alloc]init]retain];

%hook SBDisplayStack
-(id)init{
	if((self=%orig)){
		[_stacks addObject:self];
	}
	return self;
}
%end

static inline BOOL ADPCGetHeadphonesStatus(){
	return [[[%c(AVSystemController) sharedAVSystemController]attributeForKey:@"AVSystemController_HeadphoneJackIsConnectedAttribute"]boolValue];
}
static void ADPCHeadphonesCallback(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo){
	BOOL newphones=ADPCGetHeadphonesStatus();
	SBMediaController *sbmc=[%c(SBMediaController) sharedInstance];
	//int err=-1;
	if(newphones!=headphones){
		headphones=newphones;
		if([[%c(SBTelephonyManager) sharedTelephonyManager]inCall]||!useHeadphones||[prefs objectForKey:[@"Blacklist-" stringByAppendingString:[[[_stacks objectAtIndex:1]topApplication]bundleIdentifier]]) return;
		if((headphones&&shouldPlay&&![sbmc isPlaying])||(!headphones&&!shouldPause&&[sbmc isPlaying])){
			if([sbmc volume]>volumeLimit) [sbmc setVolume:volumeLimit];
			/*if(defaultApp&&[[SBUIController sharedInstance]activateApplicationAnimated:[[SBApplicationController sharedInstance]applicationWithDisplayIdentifier:defaultApp]]){
				while(!SBSProcessIDForDisplayIdentifier([defaultApp UTF8String],&pid)) {
					usleep(50000);
					[sbmc performSelector:@selector(togglePlayPause) withObject:nil afterDelay:5];
				}
			}else{*/
				[sbmc togglePlayPause];
			//}
		}
	}
}
static void ADPCPrefsLoad(){
	[prefs release];
	if([[NSFileManager defaultManager]fileExistsAtPath:prefpath]){
		prefs=[[[NSDictionary alloc]initWithContentsOfFile:prefpath]retain];
		if([prefs objectForKey:@"Connect"]) shouldPlay=[[prefs objectForKey:@"Connect"]boolValue];
		if([prefs objectForKey:@"Disconnect"]) shouldPause=[[prefs objectForKey:@"Disconnect"]boolValue];
		if([prefs objectForKey:@"Headphones"]) useHeadphones=[[prefs objectForKey:@"Headphones"]boolValue];
		if([prefs objectForKey:@"Bluetooth"]) useBluetooth=[[prefs objectForKey:@"Bluetooth"]boolValue];
		if([prefs objectForKey:@"Dock"]) useDock=[[prefs objectForKey:@"Dock"]boolValue];
		if([prefs objectForKey:@"Limit"]) volumeLimit=[[prefs objectForKey:@"Limit"]floatValue];
		if([prefs objectForKey:@"Default"]) defaultApp=[[prefs objectForKey:@"Default"]stringValue];
		if([prefs objectForKey:@"Repeat"]) shouldRepeat=[[prefs objectForKey:@"Repeat"]boolValue];
		if([prefs objectForKey:@"Shuffle"]) shouldShuffle=[[prefs objectForKey:@"Shuffle"]boolValue];
	}else{
		prefs=[[[NSDictionary alloc]initWithObjectsAndKeys:
			[NSNumber numberWithBool:shouldPlay],@"Connect",
			[NSNumber numberWithBool:shouldPause],@"Disconnect",
			[NSNumber numberWithBool:useHeadphones],@"Headphones",
			[NSNumber numberWithBool:useBluetooth],@"Bluetooth",
			[NSNumber numberWithBool:useDock],@"Dock",
			volumeLimit,@"Limit",
			defaultApp,@"Default",
			[NSNumber numberWithBool:YES],@"Blacklist-com.apple.youtube",
			[NSNumber numberWithBool:shouldRepeat],@"Repeat",
			[NSNumber numberWithBool:shouldShuffle],@"Shuffle",
			nil]retain];
		[prefs writeToFile:prefpath atomically:YES];
	}
}
static void ADPCPrefsUpdate(CFNotificationCenterRef center,void *observer,CFStringRef name,const void *object,CFDictionaryRef userInfo){
	ADPCPrefsLoad();
}

%ctor{
	%init;
	defaultApp=kCFCoreFoundationVersionNumber>=661.00?@"com.apple.Music":@"com.apple.mobileipod";
	headphones=ADPCGetHeadphonesStatus();
	CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),NULL,&ADPCHeadphonesCallback,CFSTR("AVSystemController_HeadphoneJackIsConnectedDidChangeNotification"),NULL,CFNotificationSuspensionBehaviorDeliverImmediately);
	ADPCPrefsLoad();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),NULL,&ADPCPrefsUpdate,CFSTR("ws.hbang.plugication/ReloadPrefs"),NULL,0);
}
