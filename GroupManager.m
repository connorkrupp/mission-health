//
//  GroupManager.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupManager.h"

@implementation GroupManager

- (void)getGroups {
    NSString *dataUrl = @"http://mission-health.herokuapp.com/api/users/1";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
      
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in jsonResponse[@"data"]) {
            MHGroup *group = [[MHGroup alloc] init];
              
            group.groupId = [(NSNumber *)dict[@"group_id"] intValue];
            group.name = dict[@"name"];
              
            [groups addObject:group];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.groups = groups;
            [self.delegate groupManagerDidLoadGroups:self];
        });
  }];
    
    [downloadTask resume];
}

- (void)createGroup:(NSString *)name {
    //Init the NSURLSession with a configuration
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //Create an URLRequest
    NSString *dataUrl = @"http://mission-health.herokuapp.com/api/groups";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    //Create POST Params and add it to HTTPBody
    NSString *params = [NSString stringWithFormat:@"name=%@&user_id=1", name];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Create task
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self getGroups];
    }];
    
    [dataTask resume];
}

- (void)joinGroup:(int)groupId{
}

@end
