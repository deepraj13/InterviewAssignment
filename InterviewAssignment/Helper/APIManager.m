//
//  APIManager.m
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import "APIManager.h"

@implementation APIManager

+ (instancetype)sharedManager {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)fetchUsersWithCompletion:(void (^)(NSArray *users, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://randomuser.me/api/?results=100"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            completion(nil, jsonError);
            return;
        }
        
        NSArray *results = json[@"results"];
        completion(results, nil);
    }];
    
    [dataTask resume];
}

@end
