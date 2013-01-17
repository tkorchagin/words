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

@interface MainViewController ()
@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
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

@end
