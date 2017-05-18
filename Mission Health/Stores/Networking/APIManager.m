//
//  APIManager.m
//  Mission Health
//
//  Created by Connor Krupp on 4/3/17.
//  Copyright © 2017 Connor Krupp. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "APIManager.h"
#import "AuthManager.h"
#import "GroupListManager.h"
#import "MHAccount.h"

@interface APIManager ()

@property (strong, nonatomic) NSURL *baseURL;

@end

@implementation APIManager

- (instancetype)init {
    if (self = [super init]) {
        #if TARGET_IPHONE_SIMULATOR
            _baseURL = [[NSURL alloc] initWithString:@"http://localhost:3000/v1"];
        #else
            _baseURL = [[NSURL alloc] initWithString:@"http://mission-health.herokuapp.com/api"];
        #endif
        
        self.authManager = [[AuthManager alloc] initWithAPIManager:self];
        self.groupListManager = [[GroupListManager alloc] initWithAPIManager:self];
    }
    
    return self;
}

#pragma mark - Public Networking Methods

- (void)secureTaskWithRoute:(NSString *)route
                usingMethod:(NSString *)method
             withParameters:(NSDictionary<NSString *, id> *)parameters
                 completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock {
    
    NSDictionary<NSString *, id> *headers = @{
                                              @"Authorization": [NSString stringWithFormat:@"Bearer %@", _account.token]
                                              };
    
    NSURLRequest *request = [APIManager createRequestForRoute:route atBaseURL:_baseURL withParameters:parameters withHeaders:headers usingHTTPMethod:method];
    
    [APIManager taskWithRequest:request completion:completionBlock];
}

+ (void)taskWithRoute:(NSString *)route
            atBaseURL:(NSURL *)baseURL
       withParameters:(NSDictionary<NSString *, id> *)parameters
          usingMethod:(NSString *)method
           completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock {
    
    if (![method isEqualToString:@"GET"] &&
        ![method isEqualToString:@"POST"] &&
        ![method isEqualToString:@"PUT"] &&
        ![method isEqualToString:@"PATCH"]) {
        
        NSLog(@"MUST IMPLEMENT METHOD");
        return;
    }
    
    NSURLRequest *request = [APIManager createRequestForRoute:route atBaseURL:baseURL withParameters:parameters withHeaders:nil usingHTTPMethod:method];
    
    [APIManager taskWithRequest:request completion:completionBlock];

}

+ (void)oauthTaskWithRoute:(NSString *)route
                 atBaseURL:(NSURL *)baseURL
                usingMethod:(NSString *)method
             withParameters:(NSDictionary<NSString *, id> *)parameters
            withConsumerKey:(NSString *)consumerKey
         withConsumerSecret:(NSString *)consumerSecret
           withAccessSecret:(NSString *)accessSecret
                 completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock {
    
    if (![method isEqualToString:@"GET"]) {
        NSLog(@"MUST IMPLEMENT METHOD");
        return;
    }
    
    /// Create request URL and parameter list
    NSURL *requestURL = [baseURL URLByAppendingPathComponent:route];
    NSMutableString *parameterString = [NSMutableString stringWithString:[self generateOAuthParameterStringWithParameters:parameters consumerKey:consumerKey]];
    
    /// Sign Request
    NSString *signatureBaseString = [self generateSignatureBaseStringWithMethod:method requestURL:requestURL parameterString:parameterString];
    NSString *signingKey = [NSString stringWithFormat:@"%@&%@", consumerSecret, accessSecret];
    NSString *signature = [self generateHMACSHA1DigestForText:signatureBaseString withSigningKey:signingKey];
    
    [parameterString appendString:[NSString stringWithFormat:@"&oauth_signature=%@", signature]];
    
    /// Generate URL Components
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:requestURL resolvingAgainstBaseURL:false];
    urlComponents.percentEncodedQuery = parameterString;
    
    /// Generate Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
    request.HTTPMethod = method;
    
    [self taskWithRequest:request completion:completionBlock];
}


#pragma mark - Networking Helpers

+ (void)taskWithRequest:(NSURLRequest *)request completion:(void (^)(NSDictionary<NSString *, id> *))completionBlock {
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

#pragma mark - Request Generation Helpers

+ (NSURLRequest *)createRequestForRoute:(NSString *)route
                              atBaseURL:(NSURL *)baseURL
                         withParameters:(NSDictionary<NSString *, id> *)parameters
                            withHeaders:(NSDictionary<NSString *, id> *)headers
                        usingHTTPMethod:(NSString *)method {
    
    // Generate URL Components
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:[baseURL URLByAppendingPathComponent:route] resolvingAgainstBaseURL:false];
    
    // Generate Query String
    NSString *parameterString = [self generateQueryStringWithParameters:parameters];
    
    if ([method isEqualToString:@"GET"]) {
        urlComponents.query = parameterString;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlComponents.URL];
    request.HTTPMethod = method;
    
    if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"] || [method isEqualToString:@"PATCH"]) {
        request.HTTPBody = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    if (headers) {
        for (NSString *header in headers) {
            [request addValue:headers[header] forHTTPHeaderField:header];
        }
    }
    
    return request;
}

+ (NSString *)generateQueryStringWithParameters:(NSDictionary<NSString *, id> *)parameters {
    
    NSMutableString *parameterString = [NSMutableString new];
    NSArray *sortedParameters = [[parameters allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    for (NSString *key in sortedParameters) {
        [parameterString appendString:[NSString stringWithFormat:@"%@=%@&", [self percentEncodeRFC3986:key], [self percentEncodeRFC3986:parameters[key]]]];
    }
    if ([parameterString length] > 0) {
        [parameterString deleteCharactersInRange:NSMakeRange([parameterString length] - 1, 1)];
    }
    
    return parameterString;
}

#pragma mark - OAuth 1.0 Helpers

+ (NSString *)generateOAuthParameterStringWithParameters:(NSDictionary<NSString *, id> *)parameters consumerKey:(NSString *)consumerKey {
    
    NSString *timestamp = [NSString stringWithFormat:@"%.f", ceil([[NSDate date] timeIntervalSince1970])];
    NSString *nonce = [NSString stringWithFormat:@"%d", arc4random_uniform(1000000)];
    
    NSDictionary<NSString *, id> *oauthParameters = @{
        @"oauth_consumer_key": consumerKey,
        @"oauth_timestamp": timestamp,
        @"oauth_nonce": nonce,
        @"oauth_signature_method": @"HMAC-SHA1",
        @"oauth_version": @"1.0"
    };
    
    NSMutableDictionary<NSString *, id> *fullParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [fullParameters addEntriesFromDictionary:oauthParameters];
    
    return [self generateQueryStringWithParameters:fullParameters];
}

+ (NSString *)generateSignatureBaseStringWithMethod:(NSString *)method requestURL:(NSURL *)url parameterString:(NSString *)parameterString {

    NSMutableString *signatureBaseString = [NSMutableString stringWithString:method];
    [signatureBaseString appendString:@"&"];
    [signatureBaseString appendString:[self percentEncodeRFC3986:[url absoluteString]]];
    [signatureBaseString appendString:@"&"];
    [signatureBaseString appendString:[self percentEncodeRFC3986:parameterString]];

    return signatureBaseString;
}

+ (NSString *)generateHMACSHA1DigestForText:(NSString *)text withSigningKey:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [text cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *base64Encoded = [HMACData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@" =\"#%/<>?@\\^`{}[]|&+"].invertedSet;
    return [base64Encoded stringByAddingPercentEncodingWithAllowedCharacters:allowed];
}

+ (NSString *)percentEncodeRFC3986:(id)obj {
    
    if ([obj isKindOfClass:[NSString class]]) {
        NSCharacterSet *allowed = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"];
        return [obj stringByAddingPercentEncodingWithAllowedCharacters:allowed];
    } else {
        return obj;
    }
}

@end
