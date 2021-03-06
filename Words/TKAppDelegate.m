//
//  TKAppDelegate.m
//  Words
//
//  Created by Timofey Korchagin on 17/01/2013.
//  Copyright (c) 2013 Timofey Korchagin. All rights reserved.
//

#import "TKAppDelegate.h"
#import <ViewDeck/IIViewDeckController.h>
#import <ViewDeck/IISideController.h>

@implementation TKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	IIViewDeckController *viewDeckVC = [IIViewDeckController alloc];
	
	id mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
	id dictSelVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DictSelect"];
	id menuVC = [mainStoryboard instantiateViewControllerWithIdentifier: @"Menu"];
	UINavigationController *menuNavVC = [[UINavigationController alloc] initWithRootViewController:menuVC];
	menuNavVC.navigationBar.barStyle = UIBarStyleBlack;
	viewDeckVC = [viewDeckVC initWithCenterViewController:mainVC
						     leftViewController:[[IISideController alloc] initWithViewController:dictSelVC]
						    rightViewController:[[IISideController alloc] initWithViewController:menuNavVC]];
	
	CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
	viewDeckVC.leftSize = screenWidth - 270;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		viewDeckVC.rightSize = screenWidth - 500;
	}else{
		viewDeckVC.rightSize = screenWidth - 270;
	}
	
	
	viewDeckVC.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
	self.window.rootViewController = viewDeckVC;
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
