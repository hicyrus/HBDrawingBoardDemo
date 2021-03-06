//
//  ViewController.m
//  DemoAntiAliasing
//
//  Created by Ralph Li on 8/31/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "ViewController.h"
#import "ZYQAssetPickerController.h"
#import "UIView+WHB.h"
#import "HBDrawView.h"

@interface ViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HBDrawViewDelegate>


@property (nonatomic, strong) HBDrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.drawView];
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self drawSetting:nil];
}
- (IBAction)drawSetting:(id)sender {
    [self.drawView setDrawBoardShapeType:((UIButton *)sender).tag];
    [self.drawView showSettingBoard];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.drawView setDrawBoardImage:image];
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *marray = [NSMutableArray array];
    
    for(int i=0;i<assets.count;i++){
        
        ALAsset *asset = assets[i];
        
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [marray addObject:image];
        
    }
    
    [self.drawView setDrawBoardImage:[marray firstObject]];
}
#pragma mark - HBDrawViewDelegate
- (void)drawView:(HBDrawView *)drawView action:(actionOpen)action
{
    switch (action) {
        case actionOpenAlbum:
        {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
            picker.maximumNumberOfSelection = 1;
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            
            break;
        case actionOpenCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
                
                pickVc.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickVc.delegate = self;
                [self presentViewController:pickVc animated:YES completion:nil];
                
            }else{
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
            break;
            
        default:
            break;
    }
}
- (HBDrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[HBDrawView alloc] initWithFrame:CGRectMake(0, 50, self.view.width, self.view.height)];
        _drawView.delegate = self;
    }
    return _drawView;
}

@end
