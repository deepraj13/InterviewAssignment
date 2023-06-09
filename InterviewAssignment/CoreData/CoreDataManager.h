//
//  CoreDataManager.h
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedManager;
- (void)saveContext;

@end
