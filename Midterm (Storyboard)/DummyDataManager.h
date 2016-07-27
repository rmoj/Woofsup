//
//  DummyDataManager.h
//  Midterm (Storyboard)
//
//  Created by Viviane Chan on 2016-07-25.
//  Copyright © 2016 LightHouse Labs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class Event, User;


@interface DummyDataManager : NSObject
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;
// all of your fetch and save methods
- (NSArray<Event *> *)fetchAllEvents;
- (NSArray<User *> *)fetchAllUsers;
@end
