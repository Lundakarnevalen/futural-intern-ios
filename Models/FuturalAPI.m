//
//  FuturalAPI.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-17.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "FuturalAPI.h"


@interface FuturalAPI() {
    
    NSString * responseFormat; //the string to append when requesting API-data.
    
}
@end

@implementation FuturalAPI

//implement news feed in the near feature? http://www.lundakarnevalen.se/category/nyheter/feed/
NSString *const API_URL = @"http://www.karnevalist.se";
//NSString *const API_URL = @"http://karnevalist-stage.herokuapp.com";

- (FuturalAPI *)initFuturalAPIWithDownloadDelegate:(id<NSURLConnectionDataDelegate>)desiredConnectionDelegate { //designated initializer
    
    self = [super init];
    
    if(self) {
        
        NSLog(@"futuralAPI instantiated at %@", [self class]);
        
        responseFormat = @"json";
        self.connectionDelegate = desiredConnectionDelegate;
        
    }
    
    return self;
    
}

- (BOOL)isSignedIn {
    
    return [self.karnevalist token] != nil;
    
}

- (void)fetchNotifications {
    
    NSString *appendUrl = [NSString stringWithFormat:@"api/notifications?token=%@", [self.karnevalist token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:appendUrl withFormatAppended:NO]];
    
    [request setTimeoutInterval:15];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    /*Calls the delegate and delivers the request*/
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

- (void)fetchMapCoordinates {
    
    NSString *appendUrl = [NSString stringWithFormat:@"api/clusters?token=%@", [self.karnevalist token]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:appendUrl withFormatAppended:NO]];
    
    [request setTimeoutInterval:15];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
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

- (void)resetPassword:(NSString *)email {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:@"api/users/password" withFormatAppended:NO]];
    
    //NSLog(@"password reset with token: %@", [self.karnevalist token]);
    
    //parameter template
    NSString *json = @"{"
        "\"user\": {"
            "\"email\": \"%@\""
        "}"
    "}";
    
    //insert email and password into parameter template.
    json = [NSString stringWithFormat:json, email];
    
    //data sent to the API.
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:15];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:data];
    
    //launch that mf.
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

-(void)sendAppleToken:(NSString *)token {
    NSString *appendPath = [NSString stringWithFormat:@"api/karnevalister/%d", [self.karnevalist identifier]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:appendPath withFormatAppended:NO]];
    
    //parameter template
    NSString *json = @"{"
        "\"token\": \"%@\","
        "\"karnevalist\": {"
            "\"ios_token\": \"%@\""
        "}"
    "}";
    
    
    //insert email and password into parameter template.
    json = [NSString stringWithFormat:json, [self.karnevalist token], token];
    
    //data sent to the API.
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    //configure the request
    [request setHTTPMethod:@"PUT"];
    [request setValue:[NSString stringWithFormat:@"%d", (int) data.length] forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:data];
    
    //launch that mf.
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
}

- (BOOL)hasCreatedCluster { //to see if we need to update or create the cluster.
    
    return [self.karnevalist.cluster isAvailable];
    
}

- (NSString *)clusterIdentifier {
    
    return self.karnevalist.cluster.identifier;
    
}

- (void)updateLocation:(CLLocation *)location {
    
    //data retrieved at run-time.
    NSString *appendURL;
    NSString *method;
    
    if([self hasCreatedCluster]) { //if cluster-data is available
        
        //update cluster
        appendURL = [NSString stringWithFormat:@"api/clusters/%@", [self clusterIdentifier]];
        method = @"PUT";
        
    } else {
        
        //create cluster
        appendURL = [NSString stringWithFormat:@"api/clusters/"];
        method = @"POST";
        
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:appendURL withFormatAppended:NO]];
    
    //lat, long and token sent.
    NSString *json = @"{"
                        "\"cluster\": {"
                            "\"lat\": \"%f\","
                            "\"lng\": \"%f\""
                        "},"
                        "\"token\":\"%@\""
                    "}";
    
    //insert lat, long and token
    json = [NSString stringWithFormat:json, location.coordinate.latitude, location.coordinate.longitude, [self.karnevalist token]];
    
    NSLog(@"Preparing to send coordinates with %@-method and the url %@ and of course json: \n%@", method, [[request URL] absoluteString], json);
    
    //data sent to the API.
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    //configure the request
    [request setHTTPMethod:method]; //dynamically handled
    [request setValue:[NSString stringWithFormat:@"%d", (int) data.length] forHTTPHeaderField:@"Content-length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:data];
    
    //launch that mf.
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self.connectionDelegate startImmediately:YES];
    
}

- (void)signOut { //should be in karnevalist, but, what the hell.
    
    NSString *appendUrl = [NSString stringWithFormat:@"api/users/sign_out?token=%@", [self.karnevalist token]];
    
    NSLog(@"sign out with token: %@", [self.karnevalist token]);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[self urlWithAppendedPath:appendUrl withFormatAppended:NO]];
    
    [request setHTTPMethod:@"DELETE"];
    [request setTimeoutInterval:15];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [self.karnevalist destroyData]; //remove the token from db and memory.
    
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
    
    NSString *newURLString = [[self.url absoluteString] stringByAppendingPathComponent:path];
    NSURL *url = [NSURL URLWithString:newURLString];
    
    return url;
    
}

#pragma mark ClassMethods

+ (NSDictionary *)parseJSONData:(NSData *)jsonData {
    
    if(jsonData) {
    
        NSError *error = nil;
        
        id parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        if(!error) {
            
            if([parsedData isKindOfClass:[NSDictionary class]]) { //hopefully a dictionary, otherwise kill it with fire.
                
                return parsedData;
                
            }
            
        }
        
    }
    
    return nil;
    
}

+ (NSString *)methodFromURLConnection:(NSURLConnection *)connection {
    
    if(!connection) {
        
        return nil; //die.
        
    }
    
    return [[connection currentRequest] HTTPMethod]; //put, post, delete, get etc.
    
}

+ (NSString *)stringIdentifierFromUrlConnection:(NSURLConnection *)connection { //use this to see what kind of request that was being made when it enters the delegate method.
    
    if(!connection) { //no connection? DIE DIE.
        
        return nil;
        
    }
    
    NSString *identifier = [[[connection currentRequest] URL] absoluteString];
    
    /*key = part of url,
    value = identifier to return*/
    NSDictionary *urlStrings = @{
                                 
                                 @"sign_out":@"sign_out",
                                 @"sign_in":@"sign_in",
                                 @"users/password":@"reset_password",
                                 @"notifications":@"notifications",
                                 @"clusters":@"maps"
                                 
                                 };
    
    for(NSString *key in urlStrings) {
        
        if([identifier rangeOfString:key].location != NSNotFound) {
            
            return urlStrings[key];
            
        }
        
    }
    
    return nil;
    
}

@end
