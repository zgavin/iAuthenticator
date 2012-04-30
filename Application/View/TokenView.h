//
//  TokenView.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authenticator+Custom.h"


@interface TokenView : UIView {
	IBOutlet UIView *view;
	IBOutlet UILabel* nameLabel;
	IBOutlet UIView* codesView;
	IBOutlet UIProgressView* progressView;
	
	Authenticator* authenticator;

}

@property (nonatomic,retain) Authenticator* authenticator;


@end
