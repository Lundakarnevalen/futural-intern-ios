//
//    Copyright (c) 2013 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "IKMediaViewController.h"
#import "IKMediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "InstagramKit.h"

@interface IKMediaViewController ()
{
    BOOL liked;
}
@end

@implementation IKMediaViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"@%@",self.media.user.username];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger retVal = 0;
    switch (indexPath.row) {
        case 0:
            retVal = 320;
            break;
            
        default:
            retVal = [self.media.caption.text length] / 30 * 14 + 70;
            break;
    }
    return retVal;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        IKMediaCell *cell = (IKMediaCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaCell" forIndexPath:indexPath];
        [cell.mediaImageView setImageWithURL:self.media.thumbnailURL];
        [cell.mediaImageView setImageWithURL:self.media.standardResolutionImageURL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            cell.textLabel.text = self.media.caption.text;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
