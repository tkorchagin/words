//
//  MainViewController.h
//  Words
//
//  Created by ASPCartman on 17.01.13.
//  Copyright (c) 2013 Timofey Korchagin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimatedLabel.h"

@interface MainViewController : UIViewController
@property (strong,nonatomic) NSDictionary *dictionaries;
@property (strong,nonatomic) NSString *currentDict;
@property (assign, atomic) IBOutlet AnimatedLabel	*label;
@property (assign, atomic) IBOutlet AnimatedLabel	*prevLabel;
@property (assign) IBOutlet AnimatedLabel *dictName;
@end
