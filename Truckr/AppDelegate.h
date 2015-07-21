//
//  AppDelegate.h
//  Truckr
//
//  Created by Matthew Hendrickson on 6/5/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TheSidebarController.h"
#import "MapViewController.h"//center VC
#import "LeftVC.h"
#import "FavoritesTable.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) TheSidebarController* sidebarVC;
@property (nonatomic) UINavigationController * navC;
@property (nonatomic) MapViewController* mapVC;
@property (nonatomic) LeftVC * leftVC;
@property (nonatomic) FavoritesTable* favT;

@property (nonatomic) NSMutableArray* localFavoriteArray;

- (void) saveFavArrToParse;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

