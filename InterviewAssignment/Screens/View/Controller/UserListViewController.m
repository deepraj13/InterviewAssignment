//
//  UserListViewController.m
//  InterviewAssignment
//
//  Created by Deepraj Chowrasia on 09/06/23.
//

#import "UserListViewController.h"
#import "UserListViewModel.h"
#import "InterviewAssignment-Swift.h"
#import "UserListTableViewCell.h"
#import <SDWebImage/SDWebImage.h>


@interface UserListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UserListViewModel *userListViewModel;

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Users List";

    [self.tableView registerNib:[UINib nibWithNibName:@"UserListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension; // Set default row height

    _tableView.delegate = self;
    _tableView.dataSource = self;

    self.userListViewModel = [[UserListViewModel alloc] init];
    [self setupBindings];
    [self setupNavigationBar];
    [self addBackButton];
    [self addNewMessageButton];
    [self.userListViewModel fetchUsers];
}

- (void)setupBindings {
    [self.userListViewModel addObserver:self forKeyPath:@"users" options:NSKeyValueObservingOptionNew context:nil];
    [self.userListViewModel addObserver:self forKeyPath:@"error" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [self.userListViewModel removeObserver:self forKeyPath:@"users"];
    [self.userListViewModel removeObserver:self forKeyPath:@"error"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"users"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } else if ([keyPath isEqualToString:@"error"]) {
        NSError *error = self.userListViewModel.error;
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithTitle:@"Error" message:error.localizedDescription];

            });
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userListViewModel.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    User *user = self.userListViewModel.users[indexPath.row];
    cell.name.text = user.name;
    cell.emailID.text = [NSString stringWithFormat:@"%@", user.email];
    cell.country.text = [NSString stringWithFormat:@"Country| %@", user.country];
    cell.dated.text = user.registrationDate;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.pictureURL]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *selectedUser = self.userListViewModel.users[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"UserDetailViewController"];
    detailViewController.user = selectedUser;


    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80; // Set your desired row height here
}



#pragma mark - Navigation and UI Customization

- (void)setupNavigationBar {
    self.navigationItem.title = @"User List";
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];

}

- (void)addBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)addNewMessageButton {
    UIBarButtonItem *newMessageButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_message_icon"] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = newMessageButton;
}


- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
