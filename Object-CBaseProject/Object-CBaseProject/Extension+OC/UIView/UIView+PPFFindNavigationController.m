//
//  UIView+PPFFindNavigationController.m
//  PPF_Start
//
//  Created by 尚锦信息 on 2017/4/4.
//  Copyright © 2017年 SunKing. All rights reserved.
//

#import "UIView+PPFFindNavigationController.h"

@implementation UIView (PPFFindNavigationController)

- (UINavigationController *)findNavController {
    
    UIResponder *responder = self.nextResponder;
    
    while (responder != nil) {
        
        if ([responder isKindOfClass:[UINavigationController class]]) {
            
            return (UINavigationController *)responder;
        } else {
        
            responder = responder.nextResponder;
            
        }
    }

    return nil;
}

- (UIViewController *)findViewController {


    UIResponder *responder = self.nextResponder;
    
    while (responder != nil) {
        
        if ([responder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)responder;
        } else {
            
            responder = responder.nextResponder;
            
        }
    }
    
    return nil;

}

- (UITabBarController *)findTabBarController {
    
    UIResponder *responder = self.nextResponder;
    
    while (responder != nil) {
        
        if ([responder isKindOfClass:[UITabBarController class]]) {
            
            return (UITabBarController *)responder;
        } else {
            
            responder = responder.nextResponder;
            
        }
    }
    
    return nil;
}

@end













