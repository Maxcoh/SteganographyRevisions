//
//  ViewController.h
//  SteganographyTestEncode
//
//  Created by Brendan Barnes on 7/17/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "Encoder.h"

@interface ViewController: UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate, MFMailComposeViewControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)camera:(id)sender;
- (IBAction)encodeMessage:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (strong, nonatomic) Encoder *encoder;
@property (strong, nonatomic)NSData *finalData;
@property (strong, nonatomic) SLComposeViewController* slComposer;
@end
