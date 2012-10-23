//
//  com_itaratoAppDelegate.m
//  TeamReward
//
//  Created by Peter Arato on 10/3/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//

#import "com_itaratoAppDelegate.h"

#import "TRMyListViewController.h"
#import "TRAddRewardViewController.h"
#import "TRHistoryViewController.h"
#import "TRSettingsViewController.h"
#import "TRLoginViewController.h"
#import "TRSystemConnect.h"
#import "TRUser.h"
#import "TRNode.h"
#import "TRNodeCreation.h"
#import "TRMainTabBarControllerViewController.h"
#import "TRNetworkIndicatorViewController.h"

@implementation com_itaratoAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Setting up RestKit mappings, objects and routes.
    [self setUpRestKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    UIViewController *myListViewController = [[TRMyListViewController alloc] initWithNibName:@"TRMyListViewController" bundle:nil];
    UIViewController *addRewardController = [[TRAddRewardViewController alloc] initWithNibName:@"TRAddRewardViewController" bundle:nil];
    UIViewController *historyViewController = [[TRHistoryViewController alloc] initWithNibName:@"TRHistoryViewController" bundle:nil];
    UIViewController *settingsViewController = [[TRSettingsViewController alloc] initWithNibName:@"TRSettingsViewController" bundle:nil];
    self.tabBarController = [[TRMainTabBarControllerViewController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             myListViewController,
                                             addRewardController,
                                             historyViewController,
                                             settingsViewController,
                                             nil];
    
    self.window.rootViewController = self.tabBarController;
    
    self->networkIndicator = [TRNetworkIndicatorViewController sharedIndicator];
    [self->networkIndicator.view setHidden:YES];
    [self.window.rootViewController.view addSubview:self->networkIndicator.view];
    
    [self.window makeKeyAndVisible];    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSession activeSession] handleOpenURL:url];
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark Custom actions

- (void)setUpRestKit {
    RKLogInitialize();
    RKLogConfigureFromEnvironment();
    
    // Initialize shared rest client.
    RKURL *serverBasePath = [RKURL URLWithString:kTRServerBasePath];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:serverBasePath];
    objectManager.client.baseURL = serverBasePath;
    
    // Mapping and routing for system connect.
    RKObjectMapping *systemConnectMapping = [RKObjectMapping mappingForClass:[TRSystemConnect class]];
    [systemConnectMapping mapKeyPathsToAttributes:
     @"sessid", @"sessid", nil];
    [objectManager.mappingProvider addObjectMapping:systemConnectMapping];
    [objectManager.mappingProvider setSerializationMapping:[systemConnectMapping inverseMapping] forClass:[TRSystemConnect class]];
    [objectManager.mappingProvider setObjectMapping:systemConnectMapping forResourcePathPattern:kTRServicePathSystemConnect];
    [objectManager.mappingProvider setObjectMapping:systemConnectMapping forResourcePathPattern:kTRServicePathUserLogin];
    
    // User mapping.
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[TRUser class]];
    [userMapping mapKeyPathsToAttributes:
     @"uid", @"uid",
     @"mail", @"mail",
     @"field_people_name_value", @"name",
     nil];
    [objectManager.mappingProvider addObjectMapping:userMapping];
    [objectManager.mappingProvider setSerializationMapping:[userMapping inverseMapping] forClass:[TRUser class]];
    [objectManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:kTRServicePathUser];
    [objectManager.mappingProvider setObjectMapping:userMapping forResourcePathPattern:kTRServicePathUsers];
    
    [systemConnectMapping hasOne:@"user" withMapping:userMapping];
    
    // Node mapping.
    RKObjectMapping *nodeMapping = [RKObjectMapping mappingForClass:[TRNode class]];
    [nodeMapping mapKeyPathsToAttributes:
     @"nid", @"nid",
     @"title", @"title",
     nil];
    [objectManager.mappingProvider addObjectMapping:nodeMapping];
    [objectManager.mappingProvider setSerializationMapping:[nodeMapping inverseMapping] forClass:[TRNode class]];
    [objectManager.mappingProvider setObjectMapping:nodeMapping forResourcePathPattern:kTRServicePathViewsMyRewards];
    [objectManager.mappingProvider setObjectMapping:nodeMapping forResourcePathPattern:kTRServicePathViewsMyReceivedRewards];
    
    // NodeSuccess mapping.
    RKObjectMapping *nodeCreationMapping = [RKObjectMapping mappingForClass:[TRNodeCreation class]];
    [nodeCreationMapping mapKeyPathsToAttributes:
     @"nid", @"nid",
     @"uri", @"uri",
     nil];
    [objectManager.mappingProvider addObjectMapping:nodeCreationMapping];
    [objectManager.mappingProvider setSerializationMapping:[nodeCreationMapping inverseMapping] forClass:[TRNodeCreation class]];
    [objectManager.mappingProvider setObjectMapping:nodeCreationMapping forResourcePathPattern:kTRServicePathNodeCreate];
    
    // Router for dynamic params.
    RKObjectRouter *router = [[RKObjectRouter alloc] init];
    [router routeClass:[TRUser class] toResourcePath:kTRServicePathUser];
    [router routeClass:[TRNode class] toResourcePath:kTRServicePathNode];
    objectManager.router = router;
    
    objectManager.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    objectManager.requestQueue.delegate = self;
}

#pragma mark RKRequestQueueDelegate

- (void)requestQueueDidBeginLoading:(RKRequestQueue *)queue {
    if (self->networkIndicator.view.isHidden) {
        [self->networkIndicator.view setHidden:NO];
    }
}

- (void)requestQueueDidFinishLoading:(RKRequestQueue *)queue {
    NSLog(@"FINISH with items in queue: %d", [queue count]);
    // For some reason sometimes it ends with 2 or more items in the queue that is also a full finish.
    [self->networkIndicator.view setHidden:YES];
}

@end
