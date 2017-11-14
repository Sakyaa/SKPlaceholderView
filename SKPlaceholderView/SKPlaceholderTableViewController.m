//
//  SKPlaceholderTableViewController.m
//  SKPlaceholderView
//
//  Created by Sakya on 2017/11/14.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKPlaceholderTableViewController.h"
#import "UIView+PlaceholderView.h"


@interface SKPlaceholderTableViewController ()<PlaceholderViewDataSetSource>

@end

@implementation SKPlaceholderTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKPlaceholderViewConfiguration *configuartion = [SKPlaceholderViewConfiguration new];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"网络错误设置" attributes:attributes];
    configuartion.titleString = string2;
    
    NSMutableDictionary *attributes2 = attributes.mutableCopy;
    [attributes2 setObject:[UIColor brownColor] forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *buttonString = [[NSMutableAttributedString alloc] initWithString:@"点击重试" attributes:attributes2];
    
    configuartion.buttonString = buttonString;
    SKPlaceholderViewConfiguration.defaultConfiguration = configuartion;
    self.tableView.sk_dataSetSource = self;
    __weak typeof(self) weakSelf = self;
    self.tableView.sk_tapDectedBlock = ^{
        NSLog(@"重新加载了");
        [weakSelf.tableView sk_reloadPlaceholderData];
    };
}
- (NSInteger)sk_numberOfPlaceholderViewSetView:(UIView *)currentView {
    return 0;
}
- (UIImage *)sk_imageOfPlceholderViewSetView:(UIView *)currentView {
    return [UIImage imageNamed:@"home_partyzhengxianheader_icon"];
}
- (SKPlaceholderViewStyle)sk_styleOfPlaceholderViewSetView:(UIView *)currentView {
    return SKPlaceholderViewStyleRich;
}
- (NSAttributedString *)sk_titleOfPlceholderViewLabelSetView:(UIView *)currentView  {
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [attributes setObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
    [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    [attributes setObject:[UIColor yellowColor] forKey:NSForegroundColorAttributeName];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"网络错误设置" attributes:attributes];
    return string2;
}
//- (NSAttributedString *)sk_detailOfPlceholderViewLabelSetView:(UIView *)currentView {
//    return SKPlaceholderViewConfiguration.defaultConfiguration.detailString;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"CELLID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView sk_reloadPlaceholderData];
}
- (void)dealloc {
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
