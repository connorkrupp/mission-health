//
//  GroupManager.m
//  Mission Health
//
//  Created by Connor Krupp on 3/1/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#import "GroupManager.h"
#import "APIManager.h"
#import "MHGroup.h"
#import "MHMessage.h"
#import "NSDate+JSONFormat.h"

@interface GroupManager ()

@property (weak, nonatomic) APIManager *apiManager;
@property (strong, nonatomic) NSDictionary *messageIds;

@end

@implementation GroupManager

- (instancetype)initWithAPIManager:(APIManager *)apiManager group:(MHGroup *)group {
    if (self = [super init]) {
        _apiManager = apiManager;
        _group = group;
        
        [self updateMessageIds];
    }
    
    return self;
}

// Must be called on main thread
- (void)updateMessageIds {
    NSMutableDictionary *messageIds = [[NSMutableDictionary alloc] init];
    
    for (MHMessage *message in self.group.messages) {
        messageIds[message.messageId] = message.date;
    }
    
    self.messageIds = messageIds;
}

- (void)reloadGroupMessages {
    [self getGroupMessagesWithLimit:20000];
}

- (void)getGroupMessagesWithLimit:(int)limit {
    NSDictionary<NSString *, id> *parameters = @{
                                                 @"limit": [NSNumber numberWithInt:limit]
                                                 };
    [self.apiManager secureTaskWithRoute:[NSString stringWithFormat:@"/groups/%@/messages", _group.groupId] usingMethod:@"GET" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        
        if (json[@"status"]) {
            NSMutableArray<MHMessage *> *messagesToAdd = [[NSMutableArray alloc] init];
            
            for (NSDictionary *messageData in json[@"messages"]) {
                NSString *messageId = messageData[@"_id"];
                
                if (!self.messageIds[messageId]) {
                    MHMessage *message = [[MHMessage alloc] init];
                    message.messageId = messageData[@"_id"];
                    message.body = messageData[@"body"];
                    message.date = [NSDate dateFromJSONString:messageData[@"createdAt"]];
                    
                    //message.sender = messageData[@"sender"];
                    [messagesToAdd addObject:message];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (messagesToAdd.count > 0) {
                    RLMRealm *realm = [RLMRealm defaultRealm];
                    [realm transactionWithBlock:^{
                        for (MHMessage *message in messagesToAdd) {
                            [self.group.messages insertObject:message atIndex:0];
                        }
                    }];
                    
                    [self updateMessageIds];
                    [self.delegate groupManagerDidLoadMessages:self];
                } else {
                    [self.delegate groupManagerDidLoadMessagesWithNoChanges:self];
                }
            });
        }
        

    }];
}

- (void)composeMessageWithBody:(NSString *)body {
    NSDictionary<NSString *, id> *parameters = @{
                                                 @"message": body
                                                 };

    [self.apiManager secureTaskWithRoute:[NSString stringWithFormat:@"/groups/%@/messages", _group.groupId] usingMethod:@"POST" withParameters:parameters completion:^(NSDictionary<NSString *,id> *json) {
        //TODO
        [self reloadGroupMessages];
    }];
}

@end
