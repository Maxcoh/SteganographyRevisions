//
//  ViewController.h
//  SteganographyTestDecode
//
//  Created by Brendan Barnes on 7/18/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decoder.h"


@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)camera:(id)sender;
- (IBAction)decodeImage:(id)sender;

@end
