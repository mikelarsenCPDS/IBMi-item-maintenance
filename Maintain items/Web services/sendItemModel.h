//
//  sendItemModel.h
//  Maintain items
//
//  Created by Michael D Larsen on 9/3/18.
//  Copyright © 2018 Smash Alley, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol sendItemModelProtocol <NSObject>

- (void)sendItemResponseWS:(NSArray *)sendItemResponse;
//- (void)sendItemResponseWS:(NSArray *)sendItemResponse;

@end

@interface sendItemModel : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, weak) id <sendItemModelProtocol> delegate;

- (void)sendItem:(NSMutableArray *)parmItemArray;

@end
