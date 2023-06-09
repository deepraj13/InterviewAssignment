//
//  APIManager.h
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

+ (instancetype)sharedManager;

- (void)fetchUsersWithCompletion:(void (^)(NSArray *users, NSError *error))completion;

@end
