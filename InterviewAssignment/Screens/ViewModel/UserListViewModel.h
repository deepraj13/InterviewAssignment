//
//  UserListViewModel.h
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import <Foundation/Foundation.h>


@interface UserListViewModel : NSObject

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSError *error;

- (void)fetchUsers;
- (void)fetchUsersFromDatabase;


@end
