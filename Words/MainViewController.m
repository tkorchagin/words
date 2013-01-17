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
	NSString *dictJSONList = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Dictionaries"
																  ofType:@"json"
															   inDirectory:@"Dictionaries"]
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
		NSString *fileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName
																	 ofType:@"json"
																  inDirectory:@"Dictionaries"]
										  encoding:NSUTF8StringEncoding
										     error:error];
		if (error) return nil;
		
		NSArray *words = [fileContent objectFromJSONString];
		return words;
	};
	
	[dictList performMap:parseDict];
	return dictList;
}

- (void)viewDidAppear:(BOOL)animated
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *lastDict = [defaults objectForKey:@"lastDict"];
	if (lastDict || [self.dictionaries.allKeys containsObject:lastDict])
	{
		self.currentDict = lastDict;
	} else {
		self.currentDict = self.dictionaries.allKeys[0]; // Тут ставим дефолтный дикт
	}
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
	NSArray *array = self.dictionaries[self.currentDict];
	NSInteger element = arc4random() % array.count;
	[self.label setText:array[element] animated:YES];
}
@end
