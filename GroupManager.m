//
//  GroupManager.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupManager.h"

@interface GroupManager ()

@property (strong, nonatomic) NSURL *baseURL;

@end


@implementation GroupManager


- (instancetype)init {
    if (self = [super init]) {
        self.baseURL = [[NSURL alloc] initWithString:@"http://localhost:3000/api"];
        //self.baseURL = [[NSURL alloc] initWithString:@"http://mission-health.herokuapp.com/api/groups"];
    }
    
    return self;
}

- (void)getGroups {
    [self taskWithRoute:@"/users/1/groups" parameters:nil usingMethod:@"GET" completion:^(NSDictionary<NSString *,id> *json) {
        
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        for (NSDictionary *data in json[@"data"]) {
            MHGroup *group = [[MHGroup alloc] init];
              
            group.groupId = [(NSNumber *)data[@"group_id"] intValue];
            group.name = data[@"name"];
            
            for (NSDictionary *user in data[@"users"]) {
                MHMember *member = [[MHMember alloc] init];
                
                member.memberId = [(NSNumber *)user[@"id"] intValue];
                member.name = user[@"name"];
                
                [group.members addObject:member];
            }
            
              
            [groups addObject:group];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groups = groups;
            [self.delegate groupManagerDidLoadGroups:self];
        });
    }];
}

- (void)createGroup:(NSString *)name {
    NSDictionary<NSString *, id> *parameters = @{@"name": name, @"user_id": @1};
    [self taskWithRoute:@"/groups" parameters:parameters usingMethod:@"POST" completion:^(NSDictionary<NSString *,id> *json) {
        
        [self getGroups];
    }];
}

- (void)joinGroup:(int)groupId {
    NSDictionary<NSString *, id> *parameters = @{@"user_id": @1};
    [self taskWithRoute:[NSString stringWithFormat:@"/groups/%d/join", groupId] parameters:parameters usingMethod:@"POST" completion:^(NSDictionary<NSString *,id> *json) {
        
        [self getGroups];
    }];
}


- (NSURLRequest *)createRequestForRoute:(NSString *)route parameters:(NSDictionary<NSString *, id> *)parameters usingHTTPMethod:(NSString *)method {
    
    // Generate URL Components
    NSURLComponents *urlComponenets = [[NSURLComponents alloc] initWithURL:[self.baseURL URLByAppendingPathComponent:route] resolvingAgainstBaseURL:false];
    
    // Generate Query String
    NSMutableString *formData = [NSMutableString new];
    for (NSString *key in parameters) {
        [formData appendString:[NSString stringWithFormat:@"%@=%@&", key, parameters[key]]];
    }
    if ([formData length] > 0) {
        [formData deleteCharactersInRange:NSMakeRange([formData length] - 1, 1)];
    }
    
    if ([method isEqualToString:@"GET"]) {
        urlComponenets.query = formData;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponenets.URL];
    request.HTTPMethod = method;
    
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"] || [method isEqualToString:@"PATCH"]) {
        request.HTTPBody = [formData dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    return request;
}

- (void)taskWithRoute:(NSString *)route parameters:(NSDictionary<NSString *, id> *)parameters usingMethod:(NSString *)method completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock {
    
    if (![method isEqualToString:@"GET"] &&
        ![method isEqualToString:@"POST"] &&
        ![method isEqualToString:@"PUT"] &&
        ![method isEqualToString:@"PATCH"]) {
        
        NSLog(@"MUST IMPLEMENT METHOD");
        return;
    }
    
    NSURLRequest *request = [self createRequestForRoute:route parameters:parameters usingHTTPMethod:method];
    
    // TODO Show network indicator
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        
        if (statusCode == 403 || statusCode == 401) {
            NSLog(@"Permission Denied");
            return;
        }
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        
        // TODO add handling for errors
        
        NSDictionary<NSString *, id> *json = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableLeaves error: nil];
        
        if (completionBlock) {
            completionBlock(json);
        }
    }];
    [task resume];
}


- (void)getGroupInfo:(int)groupId {
    NSURL *url = [self.baseURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%d", groupId]];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
      
        NSMutableArray<MHMember> *groupMembers = [[NSMutableArray<MHMember> alloc] init];
        NSDictionary *dict = jsonResponse[@"data"];
        for (NSDictionary *memberDict in dict[@"members"]) {
            MHMember *member = [[MHMember alloc] init];
            member.memberId = [(NSNumber *)memberDict[@"id"] intValue];
            member.name = memberDict[@"name"];
            
            [groupMembers addObject:member];
        }
              
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //MHGroup *group = [self.groups objec];
            [self.delegate groupManagerDidLoadGroups:self];
        });
  }];
    
    [downloadTask resume];
}

@end
