//
//  settingsTableView.h
//  Four in Line
//
//  Created by Vasilii Muravev on 11.09.16.
//  Copyright © 2016 Vasilii Muravev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewDelegate <NSObject>
-(void)setFieldSizeWithLines: (NSInteger *)lines andColumns: (NSInteger *)colimns;
@end

@interface settingsTableView : UITableView
//@property (weak, nonatomic) IBOutlet UITableViewSection *gameFieldSizeSection;

@end
