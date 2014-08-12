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
    _image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *newImage;
    [self dismissViewControllerAnimated:YES completion:NULL];
    if(_image.size.height > _imageView.frame.size.height || _image.size.width > _imageView.frame.size.width){
    if(_image.size.width > _image.size.height){
        float iWidth = _imageView.frame.size.width;
        float ratio = iWidth/_image.size.width;
        
        float newHeight = _image.size.height * ratio;
        
        UIGraphicsBeginImageContext(CGSizeMake(iWidth, newHeight));
        [_image drawInRect:CGRectMake(0, 0, iWidth, newHeight)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    else
    {
        float iHeight = _imageView.frame.size.height;
        float ratio = iHeight/_image.size.height;
        
        float newWidth = _image.size.width * ratio;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, iHeight));
        [_image drawInRect:CGRectMake(0, 0, newWidth, iHeight)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    _imageView.image = newImage;
    }
    else{
        _imageView.image = _image;
    }
    
}

- (IBAction)decodeImage:(id)sender {
    
    Decoder *decoder = [[Decoder alloc] init];
    
    NSString *decodedText = [decoder decodeMessage:_image];
    _textView.text = decodedText;
}
@end
