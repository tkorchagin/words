//
//  AnimatedLabel.m
//  Words
//
//  Created by ASPCartman on 17.01.13.
//  Copyright (c) 2013 Timofey Korchagin. All rights reserved.
//

#import "AnimatedLabel.h"
#define DELAY 0.01
@interface AnimatedLabel ()
@property (strong) NSOperationQueue *operationQueue;

@end


@implementation AnimatedLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.operationQueue = [[NSOperationQueue alloc] init];
		self.operationQueue.maxConcurrentOperationCount	= 1;
	}
	return self;
}

- (void)setText:(NSString *)text animated:(BOOL)animated
{
	if (!animated) return [self setText:text];
	[self.operationQueue cancelAllOperations];
	NSInvocationOperation *clearing = [[NSInvocationOperation	alloc] initWithTarget:self
											 selector:@selector(clearStringWithDelay)
											   object:nil];
	NSInvocationOperation *writing = [[NSInvocationOperation alloc] initWithTarget:self
												    selector:@selector(write:)
													object:text];
	[writing addDependency:clearing];
	for (NSInvocationOperation *inv in self.operationQueue.operations) {
		[clearing addDependency:inv];
		[writing addDependency:inv];
	}
	[self.operationQueue addOperations:@[clearing,writing] waitUntilFinished:NO];
	
}

#pragma mark Writing
- (void) write:(NSString*)newString
{
	if (newString.length == 0) return;
	
	[self performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:YES];
	for (int i=0; i<newString.length; ++i)
	{
		NSString *tempString = [newString stringByPaddingToLength:i+1 withString:@"" startingAtIndex:0];
		[self performSelectorOnMainThread:@selector(setText:) withObject:tempString waitUntilDone:YES];
		[NSThread sleepForTimeInterval:DELAY];
	}
	return;
}

#pragma mark Cleraing
- (void) clearStringWithDelay
{
	while ([self deleteOneSymbol]) {
		[NSThread sleepForTimeInterval:DELAY];
	}
}

- (BOOL) deleteOneSymbol
{
	NSString *currentText = self.text;
	NSInteger length = currentText.length;
	if (length == 0) return NO;
	
	NSString *newText = [currentText stringByPaddingToLength:length-1 withString:@"" startingAtIndex:0];
	[self performSelectorOnMainThread:@selector(setText:) withObject:newText waitUntilDone:YES];
	return YES;
}
@end
