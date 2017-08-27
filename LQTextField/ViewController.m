//
//  ViewController.m
//  LQTextField
//
//  Created by LiquanQiu on 2017/8/27.
//  Copyright © 2017年 QLQ. All rights reserved.
//

#import "ViewController.h"
#import "LQTextField.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet LQTextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:tap];
    
    _textField.maxLength = 11;
//    _textField.bridgeDelegate = self;
}

- (void)click:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
