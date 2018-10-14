//
//  sendItemModel.m
//  Maintain items
//
//  Created by Michael D Larsen on 9/3/18.
//  Copyright © 2018 Smash Alley, LLC. All rights reserved.
//

#import "sendItemModel.h"
#import "sendItemInfo.h"

@interface sendItemModel()

{
    NSMutableArray *_arrItemArray;
    NSMutableArray *_arrSendItemResponse;
}

@end

@implementation sendItemModel

- (void)sendItem:(NSMutableArray *)parmItemArray
{
    _arrItemArray = parmItemArray;
    
    if([_arrItemArray count] != 0)
    {
        _arrSendItemResponse = [[NSMutableArray alloc] init];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:_arrItemArray options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *post = [NSString stringWithFormat:@"&param=%@",postData];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        sessionConfiguration.HTTPAdditionalHeaders = @{@"Content-Type" : @"application/json",
                                                       @"Accept" : @"application/json",
                                                       @"Content-Length" : postLength};
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        
        NSString *strUrl = @"http://YOUR_URL:YOUR_PORT/web/services/ITEM_MAINT";
        
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPBody = postData;
        
        request.HTTPMethod = @"POST";
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
            {
                // get response
                {
                    if (!error)
                    {
                        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                                          
                        if (httpResp.statusCode == 200)
                        {
                            // Create a new sendItemInfo object and set its props to string properties
                            
                            sendItemInfo *newSendItemInfo = [[sendItemInfo alloc] init];
                            
                            // the status of the item maintenance comes back as Json,
                            // as NsData.  This will convert NsData to Json so we can parse the
                            // value out to a string and use it later in the process.
                            
                            NSDictionary *statusJson = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                            error:nil];
                            
                            // get the value of the status Json into a string
                            
                            newSendItemInfo.sendItemStatus    = [statusJson objectForKey:@"outStatus"];
                            newSendItemInfo.WSResponseMessage = @"Successful connection to server";
                                                              
                            // Add this to the item array
                            
                            [self->_arrSendItemResponse addObject:newSendItemInfo];
                        }
                        else
                        {
                            // bad response
                            
                            sendItemInfo *newSendMessageInfo = [[sendItemInfo alloc] init];
                                                              
                            newSendMessageInfo.WSResponseMessage = @"Can't connect to server";
                            
                            [self->_arrSendItemResponse addObject:newSendMessageInfo];
                        }
                    
                    }
                    else
                    {
                        // bad response. error with IP address?
                        
                        sendItemInfo *newSendMessageInfo = [[sendItemInfo alloc] init];
                        
                        newSendMessageInfo.WSResponseMessage = @"Can't connect to server";
                        
                        [self->_arrSendItemResponse addObject:newSendMessageInfo];
                    }
                }
                [self.delegate sendItemResponseWS:self->_arrSendItemResponse];
                                                  
            }];
        
        [postDataTask resume];
        
        // Ready to notify delegate that data is ready and pass back items.
        
        if (self.delegate)
        {
           
        }
    }
    else
    {
        // TODO: set a flag here to send back to caller
    }
    
}

@end
