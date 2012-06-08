#import <Preferences/Preferences.h>

@interface PlugicationListController: PSListController {
}
@end

@implementation PlugicationListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Plugication" target:self] retain];
	}
	return _specifiers;
}

-(void)adtwitter:(id)param{
	if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetbot:"]]){
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetbot://user_profile/thekirbylover"]];
	}else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetings:"]]){
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=thekirbylover"]];
	}else if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter:"]]){
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=thekirbylover"]];
	}else{
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://twitter.com/thekirbylover"]];
	}	   
}
-(void)adglyphish:(id)param{
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://glyphish.com"]];
}
@end

// vim:ft=objc
