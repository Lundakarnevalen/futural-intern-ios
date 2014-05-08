//
//  ViewController.h
//  Camera
//
//  Created by Richard Luong on 2014-04-21.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"


@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, NSURLConnectionDataDelegate>

@end
