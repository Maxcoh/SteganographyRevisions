//
//  Encoder.h
//  SteganographyTestEncode
//
//  Created by Brendan Barnes on 7/18/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encoder : NSObject

@property (nonatomic) NSUInteger messageSize;

-(UIImage *)encodeMessage:(UIImage *)img :(NSString *) message;


@end
