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
@property (strong,nonatomic) NSString *currentDict;
@property (weak) MainViewController *mainVC;
@end

@implementation DictionariesListViewController

- (void)viewDidLoad
{
	self.clearsSelectionOnViewWillAppear = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	if (!self.mainVC) [self buidUpAList];
}

- (void) buidUpAList
{
	self.mainVC = (MainViewController*)self.viewDeckController.centerController;
	
	self.dictionaries = self.mainVC.dictionaries;
	NSArray *keys = self.dictionaries.allKeys;
	
	self.dictNames = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2)
				{
					static NSArray *maskArray = nil;
					if (!maskArray) maskArray = @[@"Простые",@"Нормальные",@"Сложные",@"Easy",@"Normal",@"Hard"];
					if ([maskArray containsObject:obj1] && [maskArray containsObject:obj2])
					{
						NSInteger pos1 = [maskArray indexOfObject:obj1];
						NSInteger pos2 = [maskArray indexOfObject:obj2];
						
						return [@(pos1) compare:@(pos2)];
					} else if ([maskArray containsObject:obj1]) {
						return NSOrderedAscending;
					} else if ([maskArray containsObject:obj2]) {
						return NSOrderedDescending;
					} else {
						return [obj1 compare:obj2];
					}
				}];
	self.currentDict = self.mainVC.currentDict;
	
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
	if ([dictName isEqualToString:self.currentDict])
	{
		cell.imageView.image = [UIImage imageNamed:@"circle-icon"];
		
	} else {
		cell.imageView.image = [UIImage imageNamed:@"circle-dashed-4-icon"];
	}
	
	return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success)
	 {
		 if (!success) return;
		 self.mainVC.currentDict = self.dictNames[indexPath.row];
		 self.currentDict = self.dictNames[indexPath.row];
		 [tableView reloadData];
		 [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	 }];
	
}

@end
