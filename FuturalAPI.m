//
//  FuturalAPI.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-17.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "FuturalAPI.h"

#import "Lundakarneval.h"

@interface FuturalAPI() {
    
    NSString * responseFormat; //the string to append when requesting API-data.
    
}
@end

@implementation FuturalAPI

//implement news feed in the near feature? http://www.lundakarnevalen.se/category/nyheter/feed/
//NSString *const API_URL = @"http://www.karnevalist.se/";
NSString *const API_URL = @"http://karnevalist-stage.herokuapp.com";

- (FuturalAPI *)initFuturalAPIWithDownloadDelegate:(id<NSURLConnectionDataDelegate>)desiredConnectionDelegate { //designated initializer
    
    self = [super init];
    
    if(self) {
        
        NSLog(@"lundakarneval: %@\n", [Lundakarneval timeLeftUntil:@"lundakarnevalen"]);
        
        responseFormat = @"json";
        self.connectionDelegate = desiredConnectionDelegate;
        
    }
    
    return self;
    
}

- (BOOL)isSignedIn {
    
    return [self.karnevalist token] != nil;
    
}

- (void)fetchNotifications {
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[self urlWithAppendedPath:@"notifications" withFormatAppended:YES]];
    
    /*Calls the delegate and delivers the request*/
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

- (void)authenticateUser:(NSString *)userIdentification withPassword:(NSString *)password { //should be in karnevalist too.
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:@"api/users/sign_in" withFormatAppended:NO]];
    
    //parameter template
    NSString *json = @"{"
                        "\"user\": {"
    
                            "\"email\": \"%@\","
                            "\"password\": \"%@\""
    
                        "}"
                    "}";
    
    //escape certain characters.
    userIdentification = [userIdentification stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //insert email and password into parameter template.
    json = [NSString stringWithFormat:json, userIdentification, password];
    
    //data sent to the API.
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    //configure the request
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", (int) data.length] forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:data];
    
    //launch that mf.
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

- (void)resetPassword {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:@"api/users/password" withFormatAppended:NO]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //launch that mf.
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

- (void)signOut { //should be in karnevalist, but, what the hell.
    
    NSString *appendUrl = [NSString stringWithFormat:@"api/users/sign_out?token=%@", [self.karnevalist token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:appendUrl withFormatAppended:NO]];
    
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

#pragma mark LazyInstantiations

- (NSURL *)url {
    
    if(!_url) {
        
        _url = [[NSURL alloc] initWithString:API_URL];
        
    }
    
    return _url;
    
}

- (Karnevalist *)karnevalist {
    
    if(!_karnevalist) {
        
        _karnevalist = [[Karnevalist alloc] init];
        
    }
    
    return _karnevalist;
    
}

- (NSURL *)urlWithAppendedPath:(NSString *)path withFormatAppended:(BOOL)formatAppended {
    
    if(formatAppended == YES && [path rangeOfString:responseFormat].location == NSNotFound) { //check if path already contains the responseFormat.
        
        path = [path stringByAppendingString:[NSString stringWithFormat:@".%@", responseFormat]]; //append ".responseFormat".
        
    }
    
    return [self.url URLByAppendingPathComponent:path];
    
}

#pragma mark ClassMethods

+ (NSDictionary *)parseJSONData:(NSData *)jsonData {
    
    NSError *error = nil;
    id parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&error];
    
    if(!error) {
    
        if([parsedData isKindOfClass:[NSDictionary class]]) { //hopefully a dictionary, otherwise kill it with fire.
            
            return parsedData;
            
        }
        
    }
    
    return nil;
    
}

+ (NSString *)stringIdentifierFromUrlConnection:(NSURLConnection *)connection { //use this to see what kind of request that was being made when it enters the delegate method.
    
    if(!connection) { //no connection? DIE DIE.
        
        return nil;
        
    }
    
    NSString *identifier = [[[connection currentRequest] URL] absoluteString];
    
    //From now on I understand the suckiness of Objective-C not supporting switch blocks with strings...
    
    //is it a sign_out request?
    if([identifier rangeOfString:@"sign_out"].location != NSNotFound) {
        
        return @"sign_out";
        
    }
    
    //is it a sign_in request?
    if([identifier rangeOfString:@"sign_in"].location != NSNotFound) {
        
        return @"sign_in";
        
    }
    
    //a password reset maybe?
    if([identifier rangeOfString:@"users/password"].location != NSNotFound) {
        
        return @"reset_password";
        
    }
    
    //notifications maybeee?
    if([identifier rangeOfString:@"notifications"].location != NSNotFound) {
        
        return @"notifications";
        
    }
    
    return nil;
    
}

@end
