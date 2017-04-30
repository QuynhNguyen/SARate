//
//  SARateViewController.m
//
// This code is distributed under the terms and conditions of the MIT license.
//
// Copyright (c) 2014 Andrei Solovjev - andrei@solovjev.com, http://solovjev.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//

@import iRate;
#import "SARateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface UIAlertController (Window)

- (void)hide;
- (void)show;
- (void)show:(BOOL)animated;

@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end

@implementation UIAlertController (Private)

@dynamic alertWindow;

- (void)setAlertWindow:(UIWindow *)alertWindow {
    objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
    return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end

@implementation UIAlertController (Window)

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    // Applications that does not load with UIMainStoryboardFile might not have a window property:
    if ([delegate respondsToSelector:@selector(window)]) {
        // we inherit the main window's tintColor
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    
    // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // precaution to insure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

- (void)hide {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.alertWindow.rootViewController dismissViewControllerAnimated:NO completion:nil];
    // precaution to insure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

@end

@interface SARateViewController ()

@property (nonatomic, strong) UIButton *star1;
@property (nonatomic, strong) UIButton *star2;
@property (nonatomic, strong) UIButton *star3;
@property (nonatomic, strong) UIButton *star4;
@property (nonatomic, strong) UIButton *star5;

@property (nonatomic, assign) int mark;

@end

@implementation SARateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mark = 0;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    
    float width = 260.0;
    float height = 190.0;
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(width/2), (self.view.frame.size.height/2)-(height/2), width, height)];
    alertView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1];
    alertView.layer.masksToBounds = YES;
    alertView.layer.cornerRadius = 10.0;
    [self.view addSubview:alertView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, width-10, 30)];
    headerLabel.numberOfLines = 1;
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.text = _headerLabelText;
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:headerLabel];
    
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, width-10, 60)];
    descriptionLabel.numberOfLines = 2;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = _descriptionLabelText;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:descriptionLabel];
    

    float starWeight = 30.0;
    float starHeight = 30.0;
    float starY = 85.0;
    float separatorWidth = 5.0;
    
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:[self class]];

    
    _star1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_star1 setImage:[UIImage imageNamed:@"star-gray.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_star1 setImage:[UIImage imageNamed:@"star.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_star1 addTarget:self action:@selector(setRating:) forControlEvents:UIControlEventTouchUpInside];
    _star1.tag = 1;
    _star1.frame = CGRectMake(43, starY, starWeight, starHeight);
    [alertView addSubview:_star1];
    // 30 на 30
    
    
    _star2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_star2 setImage:[UIImage imageNamed:@"star-gray.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_star2 setImage:[UIImage imageNamed:@"star.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_star2 addTarget:self action:@selector(setRating:) forControlEvents:UIControlEventTouchUpInside];
    _star2.tag = 2;
    _star2.frame = CGRectMake(_star1.frame.origin.x+starWeight+separatorWidth, starY, starWeight, starHeight);
    [alertView addSubview:_star2];
    
    
    _star3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_star3 setImage:[UIImage imageNamed:@"star-gray.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_star3 setImage:[UIImage imageNamed:@"star.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_star3 addTarget:self action:@selector(setRating:) forControlEvents:UIControlEventTouchUpInside];
    _star3.tag = 3;
    _star3.frame = CGRectMake(_star2.frame.origin.x+starWeight+separatorWidth, starY, starWeight, starHeight);
    [alertView addSubview:_star3];
    
    
    _star4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_star4 setImage:[UIImage imageNamed:@"star-gray.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_star4 setImage:[UIImage imageNamed:@"star.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_star4 addTarget:self action:@selector(setRating:) forControlEvents:UIControlEventTouchUpInside];
    _star4.tag = 4;
    _star4.frame = CGRectMake(_star3.frame.origin.x+starWeight+separatorWidth, starY, starWeight, starHeight);
    [alertView addSubview:_star4];
    
    
    _star5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_star5 setImage:[UIImage imageNamed:@"star-gray.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_star5 setImage:[UIImage imageNamed:@"star.png" inBundle:frameWorkBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_star5 addTarget:self action:@selector(setRating:) forControlEvents:UIControlEventTouchUpInside];
    _star5.tag = 5;
    _star5.frame = CGRectMake(_star4.frame.origin.x+starWeight+separatorWidth, starY, starWeight, starHeight);
    [alertView addSubview:_star5];
    
    
    UIButton *rateButton;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        rateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    } else {
        rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    rateButton.frame = CGRectMake(width-(width/2)+1, height-44+1, width/2, 44.0);
    [rateButton setTitle:_rateButtonLabelText forState:UIControlStateNormal];
    rateButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    rateButton.titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:134.0/255.0 blue:252.0/255.0 alpha:1];
    [rateButton addTarget:self action:@selector(setRating) forControlEvents:UIControlEventTouchUpInside];
    rateButton.layer.borderWidth = 1;
    rateButton.layer.borderColor = [[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    [alertView addSubview:rateButton];
    
    
    UIButton *cancelButton;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    } else {
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    cancelButton.frame = CGRectMake(-1, height-44+1, width/2+3, 44.0);
    [cancelButton setTitle:_cancelButtonLabelText forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    cancelButton.titleLabel.textColor = [UIColor colorWithRed:26.0/255.0 green:134.0/255.0 blue:252.0/255.0 alpha:1];
    [cancelButton addTarget:self action:@selector(hideRating) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = [[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    [alertView addSubview:cancelButton];
    
    _isShowed = YES;
    
}



- (void)setRating:(id)object {
    if ([object isKindOfClass:[UIButton class]]) {
        UIButton *currentButton = (UIButton *)object;
        _mark = (int) currentButton.tag;
        _star1.selected = (currentButton.tag >= _star1.tag);
        _star2.selected = (currentButton.tag >= _star2.tag);
        _star3.selected = (currentButton.tag >= _star3.tag);
        _star4.selected = (currentButton.tag >= _star4.tag);
        _star5.selected = (currentButton.tag >= _star5.tag);
    }
}


-(void)hideRating{
    [iRate sharedInstance].lastReminded = [NSDate date];
    _isShowed = NO;
    [self.view removeFromSuperview];
}


-(void)setRating{
    if (_mark == 0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_setRatingAlertTitle message:_setRatingAlertTitle preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:doneAction];
        [alertController show];
        return;
    } else if (_mark >= _minAppStoreRating){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_appstoreRatingAlertTitle message:_appstoreRatingAlertMessage preferredStyle:UIAlertControllerStyleAlert];
        
        __weak SARateViewController *weakSelf = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:_appstoreRatingCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            SARateViewController *strongSelf = weakSelf;
            strongSelf.isShowed = NO;
        }];
        
        UIAlertAction *rateAction = [UIAlertAction actionWithTitle:_appstoreRatingButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SARateViewController *strongSelf = weakSelf;
            strongSelf.isShowed = NO;
            [[iRate sharedInstance] openRatingsPageInAppStore];
            [alertController hide];
            [self dismissViewControllerAnimated:NO completion:nil];
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:rateAction];
        [alertController show];
        
        return;
        
        
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_disadvantagesAlertTitle message:_disadvantagesAlertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:doneAction];
    [alertController show];
    
    [self sendMail];
    
}


#pragma mark - Mail

- (void)sendMail{
    if ([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:_email, nil];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:_emailSubject];
        NSString *emailBody = _emailText;
        [mailer setMessageBody:emailBody isHTML:YES];
        mailer.mailComposeDelegate = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        }
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_emailErrorAlertTitle message:_emailErrorAlertText preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:doneAction];
        [alertController show];
    }

}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [controller dismissViewControllerAnimated:YES completion:^{
        [iRate sharedInstance].ratedThisVersion = YES;
        _isShowed = NO;
        [self.view removeFromSuperview];
    }];
    
}


@end
