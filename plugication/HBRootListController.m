#import "HBRootListController.h"
#import "HBHeaderView.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileGestalt/MobileGestalt.h>

#define RGB(r, g, b) [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0]

static NSString *kTweakName = @"Plugication";
static NSString *kAuthorName = @"HASHBANG PRODUCTIONS";

@interface HBRootListController () <MFMailComposeViewControllerDelegate> {
	UIStatusBarStyle style;
}

@end

@implementation HBRootListController 

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationController.navigationBar.barTintColor = RGB(3, 71, 92);
	self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(twitterButtonTapped:)];

 	style = [[UIApplication sharedApplication] statusBarStyle];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
    PSTableCell *cell = [super tableView:arg1 cellForRowAtIndexPath:arg2];
    ((UILabel *)cell.titleLabel).textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    ((UIImageView *)cell.imageView).layer.masksToBounds = YES;
    ((UIImageView *)cell.imageView).layer.cornerRadius = 7.0;
    return cell;
}

- (void)viewDidLoad {

	[super viewDidLoad];

    self.navigationItem.titleView = [UIView new];
    self.navigationItem.titleView.alpha = 0;

    [UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = RGB(38, 96, 114);
    [UISegmentedControl appearanceWhenContainedIn:self.class, nil].tintColor = RGB(38, 96, 114);

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.navigationController.navigationController.navigationBar.barTintColor = nil;
	self.navigationController.navigationController.navigationBar.tintColor = nil;

	self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;

	self.navigationItem.rightBarButtonItem = nil;

	[[UIApplication sharedApplication] setStatusBarStyle:style];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return section == 0 ? [[HBHeaderView alloc] initWithTweakName:kTweakName author:kAuthorName] : nil;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return section == 0 ? 115.0 : 0.0;
}

- (void)twitterButtonTapped:(UIBarButtonItem *)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [composeController setInitialText:@"I'm using Plugication by @hbangws to play music when my headphones are plugged in. Available free in the BigBoss repo!"];
        
        [self presentViewController:composeController animated:YES completion:nil];
       
        composeController.completionHandler = ^(SLComposeViewControllerResult result) {
			[composeController dismissViewControllerAnimated:YES completion:nil];
        };
    }
}

- (void)emailHashbangSupport {
    MFMailComposeViewController *emailHB = [[MFMailComposeViewController alloc] init];
    [emailHB setSubject:@"Plugication Support"];
    [emailHB setToRecipients:@[@"HASHBANG support <support@hbang.ws>"]];
    
    NSString *product = (NSString *)MGCopyAnswer(kMGProductType);
    NSString *version = (NSString *)MGCopyAnswer(kMGProductVersion);
    NSString *build = (NSString *)MGCopyAnswer(kMGBuildVersion);

    [emailHB setMessageBody:[NSString stringWithFormat:@"\n\nCurrent Device: %@, iOS %@ (%@)", product, version, build] isHTML:NO];

    [emailHB addAttachmentData:[NSData dataWithContentsOfFile:@"/var/mobile/Library/Preferences/ws.hbang.plugication.plist"] mimeType:@"application/xml" fileName:@"PlugicationPrefs.plist"];
    system("/usr/bin/dpkg -l >/tmp/dpkgl.log");
    [emailHB addAttachmentData:[NSData dataWithContentsOfFile:@"/tmp/dpkgl.log"] mimeType:@"text/plain" fileName:@"dpkgl.txt"];
    [self.navigationController presentViewController:emailHB animated:YES completion:nil];
    emailHB.mailComposeDelegate = self;
    [emailHB release];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openHashbangSupportFAQ {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.hbang.ws/faq/"]];
}

- (void)openTwitterAccount:(NSString *)username {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:username]]];
	}
    
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:username]]];
    }
    
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:username]]];
    }
    
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:username]]];
    }
    
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]]];
    }
}

- (void)openHashbangTwitter {
	[self openTwitterAccount:@"hbangws"];
}

- (void)openBenTwitter {
	[self openTwitterAccount:@"benr9500"];
}

- (void)openKirbTwitter {
	[self openTwitterAccount:@"hbkirb"];
}

@end
