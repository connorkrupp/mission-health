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
    NSString *dataUrl = @"http://localhost:3000/api/users/1";
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
      
        NSLog(@"%@", jsonResponse[@"data"]);
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in jsonResponse[@"data"]) {
            MHGroup *group = [[MHGroup alloc] init];
              
            group.groupId = [(NSNumber *)dict[@"group_id"] intValue];
            group.name = dict[@"name"];
              
            [groups addObject:group];
        }
        
        self.groups = groups;
      
        [self.delegate groupManagerDidLoadGroups:self];
  }];
    
    [downloadTask resume];
}

@end
