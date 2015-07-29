//
//  AppDelegate.h
//  VoucherCollection
//
//  Created by ooo on 14-11-10.
//  Copyright (c) 2014年 zy. All rights reserved.
// 凭证核对全选自动进入下一条凭证

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Harpy.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

