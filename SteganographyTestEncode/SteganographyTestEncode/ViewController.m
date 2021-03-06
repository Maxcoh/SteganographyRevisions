//
//  ViewController.m
//  SteganographyTestEncode
//
//  Created by Brendan Barnes on 7/17/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Share:(id)sender {
    [self displaySMSComposerSheet];
    
}


-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    
    if([MFMessageComposeViewController canSendText]) {
    [picker setMessageComposeDelegate:self];
    NSData *myData = UIImagePNGRepresentation(_imgView.image);
	[picker addAttachmentData:myData typeIdentifier:@"public.data" filename:@"image.png"];
        
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    NSArray *recipentsArray = [[NSArray alloc]initWithObjects:@"rixu9oozzoww0@tumblr.com", nil];
    
	[picker setToRecipients:recipentsArray];
    
	[picker setSubject:@"My Encoded Image!"];
	
	// Attach an image to the email
    NSData *myData = UIImagePNGRepresentation(_imgView.image);
	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"encodedImage"];
	
	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)camera:(id)sender {
    [_textView resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload a picture" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Take a photo", @"Choose existing", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
    if(buttonIndex == 2){
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        [self presentViewController:imagePicker2 animated:YES completion:NULL];
    }
}



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage;
    [self dismissViewControllerAnimated:YES completion:NULL];
    if(image.size.height > _imgView.frame.size.height || image.size.width > _imgView.frame.size.width){
        if(image.size.width > image.size.height){
            float iWidth = _imgView.frame.size.width;
            float ratio = iWidth/image.size.width;
            
            float newHeight = image.size.height * ratio;
            
            UIGraphicsBeginImageContext(CGSizeMake(iWidth, newHeight));
            [image drawInRect:CGRectMake(0, 0, iWidth, newHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
        }
        else
        {
            float iHeight = _imgView.frame.size.height;
            float ratio = iHeight/image.size.height;
            
            float newWidth = image.size.width * ratio;
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, iHeight));
            [image drawInRect:CGRectMake(0, 0, newWidth, iHeight)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        _imgView.image = newImage;
    }
    else{
        _imgView.image = image;
    }
    
}

- (IBAction)encodeMessage:(id)sender {
    
    
    _encoder = [[Encoder alloc] init];
    _imgView.image = [_encoder encodeMessage:_imgView.image :_textView.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your image is encoded!" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



@end
