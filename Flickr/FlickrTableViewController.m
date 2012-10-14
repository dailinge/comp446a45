//
//  FlickrTableViewController.m
//  Flickr
//
//  Created by Linge Dai on 10/2/12.
//  Copyright (c) 2012 Rice. All rights reserved.
//

#import "FlickrTableViewController.h"
#import "FlickrFetcher.h"
#import "FlickrModel.h"
#import "DetailFlickrViewController.h"

@interface FlickrTableViewController ()

@property (nonatomic, strong) FlickrModel *flickrModel;
@end

@implementation FlickrTableViewController

@synthesize flickrModel = _flickrModel;

- (FlickrModel *)flickrModel {
    if (!_flickrModel) _flickrModel = [[FlickrModel alloc] initWithEmptyData];
    return _flickrModel;
}

- (void)setFlickrModel:(FlickrModel *)flickrModel {
    if (_flickrModel != flickrModel) {
        _flickrModel = flickrModel;
        if (self.tableView.window) [self.tableView reloadData];
    }
}

- (IBAction)refresh:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] 
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr download queue1", NULL);
    dispatch_async(downloadQueue, ^{
        FlickrModel *flickrModel = [[FlickrModel alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem = sender;
            self.flickrModel = flickrModel;
        });
    });
    dispatch_release(downloadQueue);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Most Viewed";
    [self refresh:self.navigationItem.rightBarButtonItem];
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [self.flickrModel numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.flickrModel numberOfRow:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.flickrModel getSectionName:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *place = [self.flickrModel getPlace:indexPath.row sectionNumber:indexPath.section];
    cell.textLabel.text = [FlickrFetcher namePlace:place];
    cell.detailTextLabel.text = [FlickrFetcher descriptionPlace:place];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [self performSegueWithIdentifier:@"PhotoDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PhotoDetail"]) {
        NSIndexPath *cellPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *place = [self.flickrModel getPlace:cellPath.row sectionNumber:cellPath.section];
        [segue.destinationViewController setPlace:place];
        
    }
}


@end
