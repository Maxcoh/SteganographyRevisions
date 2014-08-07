//
//  ViewController.m
//  SteganographyTestDecode
//
//  Created by Brendan Barnes on 7/18/14.
//  Copyright (c) 2014 Brendan Barnes. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)camera:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Choose an image to decode" message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Choose existing", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
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
    if(image.size.height > _imageView.frame.size.height || image.size.width > _imageView.frame.size.width){
    if(image.size.width > image.size.height){
        float iWidth = _imageView.frame.size.width;
        float ratio = iWidth/image.size.width;
        
        float newHeight = image.size.height * ratio;
        
        UIGraphicsBeginImageContext(CGSizeMake(iWidth, newHeight));
        [image drawInRect:CGRectMake(0, 0, iWidth, newHeight)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    else
    {
        float iHeight = _imageView.frame.size.height;
        float ratio = iHeight/image.size.height;
        
        float newWidth = image.size.width * ratio;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, iHeight));
        [image drawInRect:CGRectMake(0, 0, newWidth, iHeight)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    _imageView.image = newImage;
    }
    else{
        _imageView.image = image;
    }
    
}

- (IBAction)decodeImage:(id)sender {
    
    Decoder *decoder = [[Decoder alloc] init];
    
    NSString *decodedText = [decoder decodeMessage:_imageView.image];
    _textView.text = decodedText;
}
@end
