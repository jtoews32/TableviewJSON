//
//  ViewController.m
//  TableviewJSON
//
//  Created by Jon Toews on 8/11/15.
//  Copyright (c) 2015 Jon Toews. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void) loadView {
    [super loadView]; 
    
    _mutableArray= [[NSMutableArray alloc] init];
    _mutableImageArray = [[NSMutableArray alloc] init];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/3);
    _spinner.tag = 20;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    
    
    CGRect frame = CGRectMake(0, 30, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-70);
    
    _tableView = [[UITableView alloc] initWithFrame: frame];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = FALSE;
    
    
    
 
    
    

    dispatch_queue_t backgroundQueue = dispatch_queue_create("dispatch.test.queue", 0);
    
    dispatch_async(backgroundQueue, ^{

        NSError *error;
        NSURLResponse *response;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dev.socialsource.co/kids.json"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        

        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSDictionary *jsonDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        

        dispatch_async(dispatch_get_main_queue(), ^{

            [_spinner stopAnimating];
            [self.view addSubview:_tableView];
            
            NSArray *peopleDict = [jsonDict objectForKey:@"kids"];
            
            for (NSDictionary *person in peopleDict)
            {
                NSString *name = [person objectForKey:@"nickname"];
                NSString *imageUrl = [person objectForKey:@"avatarUrl"];
                

                [_mutableImageArray addObject:imageUrl];
                [_mutableArray addObject:name];
                
                [_tableView reloadData];
            }

        });
    });
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark table view data source protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mutableArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     //       cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    NSError *error;
    NSURL* url = [NSURL URLWithString:[_mutableImageArray objectAtIndex:indexPath.row]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0f];
    
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
            
    cell.textLabel.text = [_mutableArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:data];
    
  
    return cell;
}


#pragma mark table view delegate protocol


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (indexPath.row == 0)
    {
        if (!self.pentagonViewController)
            self.pentagonViewController = [[PentagonViewController alloc] initWithNibName:nil bundle:nil];
        
        [self.navigationController pushViewController:self.pentagonViewController animated:YES];
    }
    */
    
}


@end
