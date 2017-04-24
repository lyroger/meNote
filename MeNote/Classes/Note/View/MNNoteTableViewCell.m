//
//  MNNoteTableViewCell.m
//  MeNote
//
//  Created by 罗琰 on 2017/4/24.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNNoteTableViewCell.h"

@interface MNNoteTableViewCell()
{
    UIImageView *lineImage;
    UILabel *descLabel;
    UIImageView *noteImage;
    UIView *contentView;
}
@end

@implementation MNNoteTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorHex(0xf5f6f8);
        lineImage = [UIImageView new];
        lineImage.image = [UIImage imageNamed:@"timeaxis_line"];
        [self.contentView addSubview:lineImage];
        
        contentView = [UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 4;
        contentView.layer.masksToBounds = YES;
        [self.contentView addSubview:contentView];
        
        descLabel = [UILabel new];
        descLabel.textColor = UIColorHex(0x4a4a4a);
        descLabel.numberOfLines = 2;
        descLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:16];
        [contentView addSubview:descLabel];
        
        noteImage = [UIImageView new];
        noteImage.clipsToBounds = YES;
        noteImage.layer.cornerRadius = contentView.layer.cornerRadius;
        noteImage.contentMode = UIViewContentModeScaleAspectFill;
        [contentView addSubview:noteImage];
        
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@20);
            make.height.equalTo(@8);
            make.width.equalTo(@3);
        }];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineImage.mas_bottom);
            make.left.equalTo(@5);
            make.right.equalTo(@(-5));
            make.bottom.equalTo(@0);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@(-10));
            make.top.equalTo(@10);
            make.bottom.equalTo(noteImage.mas_top).offset(-10);
        }];
        
        [noteImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descLabel.mas_bottom).offset(10);
            make.bottom.equalTo(@(-5));
            make.left.equalTo(@5);
            make.right.equalTo(@(-5));
            
        }];
    }
    return self;
}

- (void)noteModel:(MNNoteListModel*)model
{
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:model.noteDes];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:5];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [model.noteDes length])];
    [descLabel setAttributedText:attributedString1];
    [descLabel sizeToFit];
    
//    descLabel.text = model.noteDes;
    
    noteImage.image = [UIImage imageNamed:[model.noteImages objectAtIndex:0]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
