//
//  ViewController.h
//  TableviewJSON
//
//  Created by Jon Toews on 8/11/15.
//  Copyright (c) 2015 Jon Toews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    UITableView* _tableView;
}

@end

