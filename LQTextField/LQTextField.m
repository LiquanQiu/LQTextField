//
//  LQTextField.m
//  UITextField
//
//  Created by LiquanQiu on 2017/8/27.
//  Copyright © 2017年 QLQ. All rights reserved.
//

#import "LQTextField.h"

@implementation LQTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    _maxLength = 0;
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.delegate = self;
}

/**
 主要是用于中文输入的场景
 剩余的允许输入的字数较少时，限制拼音字符的输入，提升体验
 */
- (NSInteger)allowMaxMarkLength:(NSInteger)remainLength
{
    NSInteger length = 0;
    if(remainLength > 2){
        length = NSIntegerMax;
    }else if(remainLength > 0){
        length = remainLength * 6;  //一个中文对应的拼音一般不超过6个
    }
    
    return length;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(_maxLength <= 0){
        return;
    }
    
    NSString *text = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文/emoj被截断
    if (!position){
        if (text.length > _maxLength){
            NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:_maxLength];
            if (rangeIndex.length == 1){
                textField.text = [text substringToIndex:_maxLength];
            }else{
                if(_maxLength == 1){
                    textField.text = @"";
                }else{
                    NSRange rangeRange = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength - 1 )];
                    textField.text = [text substringWithRange:rangeRange];
                }
            }
            
        }
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([_bridgeDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
        return [_bridgeDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    if(_maxLength <= 0){
        return YES;
    }
    
    UITextRange *selectedRange = [textField markedTextRange];//高亮选择的字
    UITextPosition *startPos = [textField positionFromPosition:selectedRange.start offset:0];
    UITextPosition *endPos = [textField positionFromPosition:selectedRange.end offset:0];
    NSInteger markLength = [textField offsetFromPosition:startPos toPosition:endPos];
    
    NSInteger confirmlength =  textField.text.length - markLength - range.length;//已经确认输入的字符长度
    if(confirmlength >= _maxLength ){
        return NO;
    }
    
    NSInteger allowMaxMarkLength = [self allowMaxMarkLength:_maxLength - confirmlength];
    if(markLength > allowMaxMarkLength ){// && string.length > 0){
        return NO;
    }
    return YES;
}




// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([_bridgeDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]){
        return [_bridgeDelegate textFieldShouldBeginEditing:textField];
    }else{
        return YES;
    }
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([_bridgeDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]){
        [_bridgeDelegate textFieldDidBeginEditing:textField];
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if([_bridgeDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]){
        return [_bridgeDelegate textFieldShouldEndEditing:textField];
    }else{
        return YES;
    }
    
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([_bridgeDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]){
        [_bridgeDelegate textFieldDidEndEditing:textField];
    }
}

// called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if([_bridgeDelegate respondsToSelector:@selector(textFieldShouldClear:)]){
        return [_bridgeDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([_bridgeDelegate respondsToSelector:@selector(textFieldShouldReturn:)]){
        return [_bridgeDelegate textFieldShouldReturn:textField];
    }
    return NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
