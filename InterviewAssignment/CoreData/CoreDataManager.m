//
//  CoreDataManager.m
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+ (instancetype)sharedManager {
    static CoreDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[CoreDataManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCoreDataStack];
    }
    return self;
}

- (void)setupCoreDataStack {
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"InterviewAssignment"];
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load persistent stores: %@\n%@", error, [error userInfo]);
            abort();
        }
    }];
    
    _managedObjectContext = _persistentContainer.viewContext;
    _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil && [managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        NSLog(@"Failed to save changes: %@\n%@", error, [error userInfo]);
        abort();
    }
}

@end
