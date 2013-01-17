//
//  DictionariesListViewController.m
//  Words
//
//  Created by ASPCartman on 17.01.13.
//  Copyright (c) 2013 Timofey Korchagin. All rights reserved.
//

#import "DictionariesListViewController.h"
#import "MainViewController.h"
#import <ViewDeck/IIViewDeckController.h>

@interface DictionariesListViewController ()
@property (strong,nonatomic) NSDictionary *dictionaries;
@property (strong,nonatomic) NSArray *dictNames;
@property (weak) MainViewController *mainVC;
@end

@implementation DictionariesListViewController

- (void)viewDidLoad
{

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	self.mainVC = (MainViewController*)self.viewDeckController.centerController;
	
	self.dictionaries = self.mainVC.dictionaries;
	NSArray *keys = self.dictionaries.allKeys;
	
	self.dictNames = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2)
	{
		static NSString *normal = @"Normal";
		static NSString *hard = @"Hard";
		BOOL isException =
		([obj1 isEqualToString:normal] || [obj1 isEqualToString:hard]) &&
		([obj2 isEqualToString:normal] || [obj2 isEqualToString:hard]);
		if (isException)
		{
			return -[obj1 compare:obj2];
		} else {
			return [obj1 compare:obj2];
		}
	}];
	[self.tableView reloadData];
}


#pragma mark - Table view data 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dictionaries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	NSString *dictName = self.dictNames[indexPath.row];
	NSInteger dictCount = [self.dictionaries[dictName] count];
	
	cell.textLabel.text = dictName;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",dictCount];
	
	return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success)
	{
		if (!success) return;
		self.mainVC.currentDict = self.dictNames[indexPath.row];
	}];

}

@end
