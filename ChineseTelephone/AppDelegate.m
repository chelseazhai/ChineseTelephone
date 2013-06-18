//
//  AppDelegate.m
//  ChineseTelephone
//
//  Created by Ares on 13-5-22.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AppDelegate.h"

#import <CommonToolkit/CommonToolkit.h>

#import "CallRecordHistoryListTabContentViewController.h"
#import "DialTabContentViewController.h"
#import "ContactListTabContentViewController.h"
#import "MoreTabContentViewController.h"

@implementation AppDelegate

@synthesize rootViewController = _rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    // show status bar when application did finish launching
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // traversal addressBook
    [[AddressBookManager shareAddressBookManager] traversalAddressBook];
    
    // open Chinese telephone database which under application documents folder, if not existed then generate an new and checked it
    FMDatabase *_ChineseTelehoneDatabase = [FMDatabase databaseWithPath:[APP_DOCUMENTSPATH stringByAppendingPathComponent:CHINESETELEPHONE_DATABASENAME]];
    if ([_ChineseTelehoneDatabase open]) {
        // create call record table if not existed
        [_ChineseTelehoneDatabase executeUpdate:[NSString stringWithFormat:CALLRECORDSTABLE_CREATESTATEMENT, CALLRECORDS_TABLENAME, CALLRECORDSTABLE_ROWID_FIELDNAME, CALLRECORDSTABLE_NAME_FIELDNAME, CALLRECORDSTABLE_PHONE_FIELDNAME, CALLRECORDSTABLE_DATE_FIELDNAME, CALLRECORDSTABLE_DUDATION_FIELDNAME, CALLRECORDSTABLE_FLAGS_FIELDNAME]];
    }
    else {
        NSLog(@"open Chinese telephone database failed");
    }
    
    // close Chinese telephone database
    [_ChineseTelehoneDatabase close];
    
    // create, init tab bar controller and its all content view controller
    UITabBarController *_tabBarController = [[UITabBarController alloc] init];
    UINavigationController *_callRecordHistoryListTabContentViewController = [[UINavigationController alloc] initWithRootViewController:[[CallRecordHistoryListTabContentViewController alloc] init] andBarTintColor:NAVIGATIONBAR_TINTCOLOR];
    UIViewController *_dialTabContentViewController = [[DialTabContentViewController alloc] init];
    UINavigationController *_contactListTabContentViewController = [[UINavigationController alloc] initWithRootViewController:[[ContactListTabContentViewController alloc] init] andBarTintColor:NAVIGATIONBAR_TINTCOLOR];
    UINavigationController *_moreTabContentViewController = [[UINavigationController alloc] initWithRootViewController:[[MoreTabContentViewController alloc] init] andBarTintColor:NAVIGATIONBAR_TINTCOLOR];
    
    // set tab content view controller
    _tabBarController.viewControllers = [NSArray arrayWithObjects:_callRecordHistoryListTabContentViewController, _dialTabContentViewController, _contactListTabContentViewController, _moreTabContentViewController, nil];
    
    // set first selected tab, dial tab content view controller
    [_tabBarController setSelectedViewController:_dialTabContentViewController];
    
    // init application root view controller
    _rootViewController = [[AppRootViewController alloc] initWithPresentViewController:_tabBarController andMode:normalController];
    
    // set application window rootViewController and show the main window
    self.window.rootViewController = _rootViewController;
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
