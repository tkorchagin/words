//
//  MainViewController.m
//  Words
//
//  Created by ASPCartman on 17.01.13.
//  Copyright (c) 2013 Timofey Korchagin. All rights reserved.
//

#import "MainViewController.h"
#import <JSONKit/JSONKit.h>
#import <BlocksKit/BlocksKit.h>
#import <ViewDeck/IIViewDeckController.h>

@interface MainViewController ()
@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		// Обзервинг
		__block id pseudoSelf = self;
		[self addObserverForKeyPath:@"currentDict" task:^(id sender) {
			[self.dictName setText:self.currentDict animated:YES];
			[pseudoSelf update:nil];
		}];
		
		self.dictionaries = [self loadDictionaries];
	}
	
	return self;
}


- (NSDictionary*) loadDictionaries
{
	NSError * __autoreleasing *error = nil;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Dictionaries"
													 ofType:@"json"
												inDirectory:@"Dictionaries"];
	NSString *dictJSONList = [NSString stringWithContentsOfFile:path
									   encoding:NSUTF8StringEncoding
										error:error];
	if (error)
	{
		NSLog(@"Can't open the dictionaries list");
		return nil;
	}
	NSMutableDictionary *dictList = [dictJSONList mutableObjectFromJSONString];

	BKKeyValueTransformBlock parseDict = ^id(NSString *key, NSString *obj)
	{
		NSError * __autoreleasing *error = nil;
		
		NSString *fileName = obj;
		NSString *path = [[NSBundle mainBundle] pathForResource:fileName
														 ofType:@"json"
													inDirectory:@"Dictionaries"];
		NSString *fileContent = [NSString stringWithContentsOfFile:path
										  encoding:NSUTF8StringEncoding
										     error:error];
		if (error) return nil;
		
		NSArray *words = [fileContent objectFromJSONString];
		NSLog(@"%@",words);
		return words;
	};
	
	[dictList performMap:parseDict];
	return dictList;
}

- (void)viewDidLoad
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *lastDict = [defaults objectForKey:@"lastDict"];
	if (lastDict || [self.dictionaries.allKeys containsObject:lastDict])
	{
		self.currentDict = lastDict;
	} else {
		self.currentDict = self.dictionaries.allKeys[0]; // Тут ставим дефолтный дикт
	}
	
	self.label.font = [self.label.font fontWithSize:[self wordLabelFontSize]];
	self.prevLabel.font = [self.prevLabel.font fontWithSize:[self prevWordLabelFontSize]];
	self.dictName.font = [self.dictName.font fontWithSize:[self dictLabelFontSize]];
}

- (CGFloat) wordLabelFontSize
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return 60;
	else
		return 38;
}

- (CGFloat) prevWordLabelFontSize
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return 36;
	else
		return 22;
}

- (CGFloat) dictLabelFontSize
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return 32;
	else
		return 20;
}

#pragma mark GUI Stuff
- (IBAction)openLeftSide:(id)sender
{
	[self.viewDeckController openLeftViewAnimated:YES];
}

-(IBAction)openRightSide:(id)sender
{
	[self.viewDeckController openRightViewAnimated:YES];
}

- (IBAction)update:(id)sender
{

	if (![self.label.text isEqualToString:@""])
	{
		CGRect originalFrame = self.label.frame;
		UIFont *originalFont = self.label.font;
		UIColor *originalColor = self.label.textColor;
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIButton *button = (UIButton*)sender;
		button.enabled = NO;

		[UIView animateWithDuration:0.4 animations:^{
			self.label.frame = self.prevLabel.frame;
			self.label.font = self.prevLabel.font;
			self.label.textColor = self.prevLabel.textColor;
			
			CGRect frame = self.prevLabel.frame;
			frame.origin.y =  screenRect.size.height;
			self.prevLabel.frame = frame;

		} completion:^(BOOL finished) {
			self.prevLabel.text = @"";
			self.prevLabel.frame = originalFrame;
			self.prevLabel.font = originalFont;
			self.prevLabel.textColor = originalColor;
			
			AnimatedLabel *tmp = self.label;
			self.label = self.prevLabel;
			self.prevLabel = tmp;
			
			[self updateText];
			button.enabled = YES;
		}];
	}else{
		[self updateText];
	}
	
}

- (void) updateText
{
	NSArray *array = self.dictionaries[self.currentDict];
	NSInteger element = arc4random() % array.count;
	[self.label setText:array[element] animated:YES];
	
}
@end
