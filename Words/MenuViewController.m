//
//  DictionariesListViewController.m
//  Words
//
//  Created by ASPCartman on 17.01.13.
//  Copyright (c) 2013 Timofey Korchagin. All rights reserved.
//

#import "MenuViewController.h"
#import "MainViewController.h"
#import <ViewDeck/IIViewDeckController.h>

@interface MenuViewController ()
@property (strong,nonatomic) NSArray *menuStrings;
@property (weak) MainViewController *mainVC;
@end

@implementation MenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.menuStrings = @[@"Правила", @"Частности", @"Философия"];
	}
	return self;
}

- (void)viewDidLoad
{
	self.clearsSelectionOnViewWillAppear = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
}
#pragma mark - Table view data

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.menuStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	cell.textLabel.text = self.menuStrings[indexPath.row];
	cell.detailTextLabel.text = @"";
	
	return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UINavigationController *navVC = self.navigationController;
	NSString *identifier = nil;
	switch (indexPath.row) {
		case 0:
			identifier = @"rules";
			break;
		case 1:
			identifier = @"details";
			break;
		case 2:
			identifier = @"philosophy";
			break;
	}
	
	id vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
	[navVC pushViewController:vc animated:YES];
}

@end
