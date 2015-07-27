#import "HBHeaderView.h"

@interface HBHeaderView ()

@property (nonatomic, retain) UILabel *tweakName;
@property (nonatomic, retain) UILabel *authorName;

@end

@implementation HBHeaderView

- (instancetype)initWithTweakName:(NSString *)tweakName author:(NSString *)author {
	if (self = [super init]) {

		self.tweakName = [[UILabel alloc] init];
		self.tweakName.text = tweakName;
		self.tweakName.textAlignment = NSTextAlignmentCenter;
		self.tweakName.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
		self.tweakName.font = [UIFont fontWithName:@"HelveticaNeue" size:45.0];
		[self addSubview:self.tweakName];

		self.authorName = [[UILabel alloc] init];
		self.authorName.text = author;
		self.authorName.textAlignment = NSTextAlignmentCenter;
		self.authorName.textColor = [UIColor colorWithWhite:0.2 alpha:0.7];
		self.authorName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0];
		[self addSubview:self.authorName];

		self.tweakName.translatesAutoresizingMaskIntoConstraints = 
		self.authorName.translatesAutoresizingMaskIntoConstraints = NO;

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tweakName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.2 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.tweakName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.authorName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.tweakName attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.authorName attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];


	}
	return self;
}

@end