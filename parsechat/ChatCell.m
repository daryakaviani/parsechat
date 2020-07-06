//
//  ChatCell.m
//  parsechat
//
//  Created by dkaviani on 7/6/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bubbleView.layer.cornerRadius = 16;
    self.bubbleView.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
