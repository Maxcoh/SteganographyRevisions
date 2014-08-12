//
//  Encoder.m
//  SteganographyTestEncode
//
//  Created by Brendan Barnes on 7/18/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import "Encoder.h"

@implementation Encoder
-(UIImage *)encodeMessage:(UIImage *)img :(NSString *)message
{
    const NSUInteger BIT_SIZE = 8;
    //get bits from input message
    NSData* stringData = [message dataUsingEncoding:NSUTF8StringEncoding];
    UInt8* stringBytes = (UInt8 *)stringData.bytes;
    CFBitVectorRef stringBits = CFBitVectorCreate(NULL, stringBytes, [stringData length]*8);
    
    //grabs image input in function
    NSData *picData = UIImagePNGRepresentation(img);
    img = [[UIImage alloc] initWithData:picData];
    CGImageRef imageRef = img.CGImage;
    NSUInteger nWidth = CGImageGetWidth(imageRef);
    NSUInteger nHeight = CGImageGetHeight(imageRef);
    NSUInteger nBytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, img.size.width, img.size.height, 8,nBytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = nWidth, .size.height = nHeight}, imageRef);
    
    
    //gets bytes from image
    UInt8* imgBytes = (UInt8*)CGBitmapContextGetData(bmContext);
    NSUInteger numImgBytes = (nBytesPerRow*nHeight);
    
    NSUInteger numStringBits = CFBitVectorGetCount(stringBits);
    
    NSUInteger numEncodes = numImgBytes/((numStringBits)+(2*BIT_SIZE));
    NSUInteger iter = 0;
    NSUInteger offset = 0;
    CFBit currentBit;
    
    //encodes the max number of times for the given image size
    for(NSUInteger curEncode = 0; curEncode < numEncodes; curEncode++)
    {
        //adding the UTF-8 start tag (value is 2) to the beginning of the message
        for(; iter < BIT_SIZE+offset; iter++)
        {
            if(iter == 6)
            {
                if(imgBytes[iter]%2 == 0)
                {
                    imgBytes[iter] ++;
                }
            }
            else
            {
                if(imgBytes[iter]%2 == 1)
                {
                    imgBytes[iter] --;
                }
            }
        }
        
        //encodeing message into image bits
        for (; iter < BIT_SIZE+numStringBits+offset; iter++)
        {
            currentBit = CFBitVectorGetBitAtIndex(stringBits, (iter-8));
            if(imgBytes[iter]%2 < currentBit)
            {
                imgBytes[iter]++;
            }
            if(imgBytes[iter]%2 > currentBit)
            {
                imgBytes[iter]--;
            }
        }
        
        //adding the UTF-8 start tag (value is 2) to the beginning of the message
        for(; iter < (BIT_SIZE*2)+numStringBits+offset; iter++)
        {
            if(iter < (numStringBits+8)+6)
            {
                if(imgBytes[iter]%2 == 1)
                {
                    imgBytes[iter] --;
                }
            }
            else
            {
                if(imgBytes[iter]%2 == 0)
                {
                    imgBytes[iter] ++;
                }
            }
        }
        //updating the offset value
        offset = iter;
    }
    
    //draws new image from data, returns said image
    bmContext = CGBitmapContextCreate(imgBytes, img.size.width, img.size.height, 8,nBytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage *imageNew = [[UIImage alloc] initWithCGImage:newImageRef];
    picData = UIImagePNGRepresentation(imageNew);
    imageNew = [[UIImage alloc] initWithData:picData];
    CGContextRelease(bmContext);
    return imageNew;
}

@end
