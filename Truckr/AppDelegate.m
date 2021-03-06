//
//  AppDelegate.m
//  Truckr
//
//  Created by Matthew Hendrickson on 6/5/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "TheSidebarController.h"
#import "MapViewController.h"//center VC
#import "LeftVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


//set up listener for internet connection to save favorite array as soon as internet connection is reestablished.
- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    Reachability * internetReachable;
    internetReachable = [Reachability reachabilityForInternetConnection];

    
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI");
            PFUser* user = [PFUser currentUser];
            //only try and save the fav array if someone is logged in otherwise it will crash
            if(user)
                [self saveFavArrToParse];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN!");
            break;
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //NSLog(@"did finish launching ");
    
    Reachability * internetReachable;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    // Set up Reachability
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    [Parse setApplicationId:@"q1z8UUnjXCYVN4bnNcDulVqF8ZaoInbQUkyzGWdk"
                  clientKey:@"Z6UUYyVdqOMR7POAif0HImojwueUdHy1OWiqXJHq"];
    
    
    PFUser* user = [PFUser currentUser];
    
    if (user) {
        
    
    
        PFQuery *query = [PFQuery queryWithClassName:@"PFFavoriteArray"];
        [query whereKey:@"user" equalTo:user];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        
            if(object != nil || object != Nil) {
            
            
                _localFavoriteArray = object[@"favoriteArray"];
            
                //NSLog(@"favoriteArray count %lu", [object[@"favoriteArray"] count]);
                //NSLog(@"loaded into _localfavs\n%@", _localFavoriteArray);

            
            }
            else {
                //NSLog(@"yo object is nil or Nil");
                NSString *errorString = [error userInfo][@"error"];
                //[self displayAlert:@"There's something wrong" message:errorString];
                //NSLog(@"%@", errorString);
            }
        
        }];

    
    }
    
    
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    _mapVC = [main instantiateViewControllerWithIdentifier:@"mapVC"];
    
 
    _navC = [[UINavigationController alloc] initWithRootViewController:_mapVC];
    
    _navC.navigationBar.barTintColor = [UIColor whiteColor];
    UIImage *logo = [UIImage imageNamed:@"truck-icon"];
    _navC.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];

    
    _leftVC = [main instantiateViewControllerWithIdentifier:@"leftVC"];
    
    _sidebarVC = [[TheSidebarController alloc] initWithContentViewController:_navC leftSidebarViewController:_leftVC storyboardsUseAutoLayout:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _sidebarVC;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) displayAlert:(NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) saveFavArrToParse {
    //save the _favorites array to the PFObject PFFavoritesArray
    PFUser* user = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"PFFavoriteArray"];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        
        if(object != nil || object != Nil) {
            
            object[@"favoriteArray"] = _localFavoriteArray;
            
            [object saveInBackground];
            
            NSLog(@"in did enter background favoriteArray count %lu", [object[@"favoriteArray"] count]);
            NSLog(@"AFTER SAVE\n%@", object);
            
            
        }
        else {
            NSLog(@"yo object is nil or Nil");
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
        
    }];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"application will resign active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    //save the _favorites array to the PFObject PFFavoritesArray
    [self saveFavArrToParse];
    
    
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"application will enter foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"application did becom active");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveFavArrToParse];
    NSLog(@"application will terminate");
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "CS378.Truckr" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Truckr" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Truckr.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
