//
//  UserListViewModel.m
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import "UserListViewModel.h"
#import "InterviewAssignment-Swift.h"

//#import "User+CoreDataClass.swift"
#import "APIManager.h"
#import "CoreDataManager.h"

@implementation UserListViewModel



- (void)fetchUsers {
    NSManagedObjectContext *context = [CoreDataManager sharedManager].managedObjectContext;
    
    // Fetch users from Core Data
    NSFetchRequest *fetchRequest = [User fetchRequest];
    NSError *error = nil;
    NSArray *fetchedUsers = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        self.error = error;
    } else {
        if (fetchedUsers.count > 0) {
            self.users = fetchedUsers;
        }
        
        [[APIManager sharedManager] fetchUsersWithCompletion:^(NSArray *users, NSError *error) {
            if (error) {
                self.error = error;
            } else {
                // Save fetched users to Core Data
                for (NSDictionary *userData in users) {
                    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                    [self configureUser:user withData:userData];
                }
                
                [[CoreDataManager sharedManager] saveContext];
                
                // Fetch users again from Core Data
                NSArray *updatedUsers = [context executeFetchRequest:fetchRequest error:&error];
                
                if (error) {
                    self.error = error;
                } else {
                    self.users = updatedUsers;
                }
            }
        }];
    }
}

- (void)fetchUsersFromDatabase {
    NSManagedObjectContext *context = [CoreDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetchRequest = [User fetchRequest];
    
    NSError *error = nil;
    NSArray *fetchedUsers = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        self.error = error;
    } else {
        self.users = fetchedUsers;
    }
}

- (void)configureUser:(User *)user withData:(NSDictionary *)userData {
    NSDictionary *nameData = userData[@"name"];
    user.name = [NSString stringWithFormat:@"%@ %@",
                 nameData[@"first"],
                 nameData[@"last"]];
    user.email = userData[@"email"];
    user.country = userData[@"location"][@"country"];
    user.registrationDate = userData[@"registered"][@"date"];
    user.pictureURL = userData[@"picture"][@"medium"];
    user.city = userData[@"location"][@"city"];
    user.state = userData[@"location"][@"state"];
    user.age = userData[@"dob"][@"age"];
    user.dob = userData[@"dob"][@"date"];

    id postcodeValue = userData[@"location"][@"postcode"];
        if ([postcodeValue isKindOfClass:[NSNumber class]]) {
            user.postcode = [postcodeValue stringValue];
        } else if ([postcodeValue isKindOfClass:[NSString class]]) {
            user.postcode = postcodeValue;
        }
    
    // Calculate days ago, if registered yesterday, today, or more than one week ago
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *registrationDate = [dateFormatter dateFromString:user.registrationDate];
    NSDate *birthDayDate = [dateFormatter dateFromString:user.registrationDate];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    user.dob = [dateFormatter stringFromDate:birthDayDate];


    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL isToday = [calendar isDateInToday:registrationDate];
    BOOL isYesterday = [calendar isDateInYesterday:registrationDate];

    if (isToday) {
        [dateFormatter setDateFormat:@"h:mm a"];
        NSString *formattedTime = [dateFormatter stringFromDate:userData[@"registered"][@"date"]];
        user.registrationDate = [NSString stringWithFormat:@"%@", formattedTime];
    } else if (isYesterday) {
        [dateFormatter setDateFormat:@"h:mm a"];
        NSString *formattedTime = [dateFormatter stringFromDate:registrationDate];
        user.registrationDate = [NSString stringWithFormat:@"Yesterday, %@", formattedTime];
    } else {
        NSDate *currentDate = [NSDate date];
        NSTimeInterval timeDifference = [currentDate timeIntervalSinceDate:registrationDate];

        if (timeDifference >= 7 * 24 * 60 * 60) {
            // More than one week ago, display the actual date in "Month Date, Year" format
            [dateFormatter setDateFormat:@"MMMM d, yyyy"];
            user.registrationDate = [dateFormatter stringFromDate:registrationDate];
        } else {
            // Less than one week ago, display X days ago
            NSInteger daysAgo = timeDifference / (60 * 60 * 24);
            user.registrationDate = [NSString stringWithFormat:@"%ld days ago", (long)daysAgo];
        }
    }

}



@end
