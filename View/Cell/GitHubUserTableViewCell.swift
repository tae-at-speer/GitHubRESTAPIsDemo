//
//  GitHubUserTableViewCell.swift
//  GitHubRESTAPIsDemo
//
//  Created by Heaven Yip on 2022-09-12.
//

import UIKit

class GitHubUserTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imageViewMain: UIImageView!
    @IBOutlet weak var lblLoginName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var cellViewModel: GitHubUserCellViewModel? {
        didSet {
            lblLoginName.text = cellViewModel?.getLoginName()
            imageViewMain.sd_setImage(with: cellViewModel?.getAvatarUrl(), placeholderImage: nil, options: .avoidAutoSetImage) { [weak self] image, error, type, url in
                if url == self?.cellViewModel?.getAvatarUrl()
                {
                    self?.imageViewMain.image = image
                }
            }
        }
    }
    
}
