//
//  Decoder.m
//  SteganographyTestDecode
//
//  Created by Brendan Barnes on 7/18/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import "Decoder.h"

@implementation Decoder

-(NSString *)decodeMessage:(UIImage *)img
{
    CGImageRef imageRef = img.CGImage;
    NSData *picData = UIImagePNGRepresentation(img);
    img = [[UIImage alloc] initWithData:picData];
    imageRef = img.CGImage;
    NSUInteger nWidth = CGImageGetWidth(imageRef);
    NSUInteger nHeight = CGImageGetHeight(imageRef);
    NSUInteger nBytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, img.size.width, img.size.height, 8,nBytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = nWidth, .size.height = nHeight}, imageRef);
    
    
    UInt8* imgBytes = (UInt8*)CGBitmapContextGetData(bmContext);
    NSUInteger numImgBits = (nBytesPerRow*nHeight)*8;
    CFBitVectorRef imgBits = CFBitVectorCreate(kCFAllocatorDefault, imgBytes, numImgBits);
    
    CFMutableBitVectorRef bitStream = CFBitVectorCreateMutableCopy(kCFAllocatorDefault, numImgBits, imgBits);
    CFBitVectorSetAllBits(bitStream, 0);
    
    NSMutableData *decodedDataMut = [[NSMutableData alloc] init];
    uint8_t currentByte = '\0';
    CFBit currentBit;
    NSUInteger i = 0;
    BOOL startDecoding = NO;
    
    while (currentByte != 3)
    {
        currentBit = CFBitVectorGetBitAtIndex(imgBits, (((i+1)*8)-1));
        CFBitVectorSetBitAtIndex(bitStream, i, currentBit);
        
        if(startDecoding == NO)
        {
            if((i+1)%4 == 0 && CFBitVectorGetCount(bitStream) > 4)
            {
                CFRange range = CFRangeMake((i-7), 8);
                CFBitVectorGetBits(bitStream, range, &currentByte);
                if(currentByte == 2)
                {
                    startDecoding = YES;
                }
            }
        }
        else
        {
            if((i+1)%8 == 0)
            {
                CFRange range = CFRangeMake((i-7), 8);
                CFBitVectorGetBits(bitStream, range, &currentByte);
                [decodedDataMut appendBytes:&currentByte length:1];
            }
        }
        i++;
    }
    
    NSData *decodedData = [NSData dataWithData:decodedDataMut];
    NSString *picString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    CGContextRelease(bmContext);
    
    return picString;
}

@end
