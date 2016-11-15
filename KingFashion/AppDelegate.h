//
//  AppDelegate.h
//  KingFashion
//
//  Created by Anh Vu Mai on 10/18/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

