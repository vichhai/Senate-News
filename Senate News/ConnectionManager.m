//
//  ConnectionManager.m
//  Senate News
//
//  Created by vichhai on 9/7/15.
//  Copyright (c) 2015 GITS. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager ()

{
    NSMutableData *responseData;
}
@end

@implementation ConnectionManager

-(void)sendTranData:(NSDictionary *)reqDictionary{
    // Create the request
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://schedule-darapenhchet-3.c9.io/index.php/api"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"2a1814171e4c995cbc1a7950a67d3db45b4fd139" forHTTPHeaderField:@"X-API-KEY"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqDictionary options:0 error:nil];
    
    // Checking the format
    NSString *urlString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // Convert your data and set your request's HTTPBody property
    //    NSString *stringData = [[NSString alloc] initWithFormat:@"jsonRequest=%@", urlString];
    NSString *stringData = [[NSString alloc] initWithFormat:@"%@",urlString];
    
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    request.HTTPBody = requestBodyData;
    
    // Create url connection and fire request
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!theConnection) {
        // Release the receivedData object.
        //       responseData = nil;
    }
    
}

#pragma mark - NSURLConnection Delegate method
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [responseData appendData:data];
    
    NSError *error=nil;
    
    // Convert JSON Object into Dictionary
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseData options:
                          NSJSONReadingMutableContainers error:&error];
    
    //    NSLog(@"Response %@",JSON);
    
    //    [self.delegate sharePopTableViewController:self didSelectRowAtIndexPath:indexPath];
    [self.delegate returnResult:JSON];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connection did finish loading: %@",connection);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"fail with error : %@",error);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

@end
