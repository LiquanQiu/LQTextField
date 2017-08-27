//
//  LQTextField.h
//  UITextField
//
//  Created by LiquanQiu on 2017/8/27.
//  Copyright © 2017年 QLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQTextField : UITextField<UITextFieldDelegate>

/// 最大字数，emoji算两个字，中英文都算一个字。
@property(nonatomic, assign) NSInteger maxLength;

/// 如果需要自定义UITextField的delegate，请用textField.bridgeDelegate = self 代替 textField.delegate = self
@property(nonatomic, weak) id<UITextFieldDelegate> bridgeDelegate;

@end
