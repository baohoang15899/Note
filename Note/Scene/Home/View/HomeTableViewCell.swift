//
//  HomeTableViewCell.swift
//  Note
//
//  Created by Toi Nguyen on 23/05/2022.
//

import UIKit



class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet private weak var lbTotal: UILabel!
    @IBOutlet private weak var lbName: UILabel!
    @IBOutlet weak var cstLeadingImageView: NSLayoutConstraint!
    @IBOutlet weak var cstLeadingLabel: NSLayoutConstraint!
    
    var onTapCheckbox: (() -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        lbTotal.text = "0"
        ivImage.image = UIImage(named: "circle")
        cstLeadingImageView.constant = -20
        ivImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        ivImage.addGestureRecognizer(tap)
        cstLeadingLabel.constant = 22
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(item: HomeTableViewCellViewModel, isEdit: Bool, isEditTap: Bool) {
        lbName.text = item.folder.name ?? ""
        if isEditTap {
            UIView.animate(withDuration: 0.3) {
                self.cstLeadingImageView.constant = isEdit ? 20 : -20
                self.cstLeadingLabel.constant = isEdit ? 8 : 22
                self.contentView.layoutIfNeeded()
            }
            UIView.transition(with: self.contentView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.ivImage.image = item.isChecked ?
                UIImage(named: "circleCheckmark") :
                UIImage(named: "circle")
            }, completion: nil)
        }
    }
    
    @objc
    func onTap() {
        onTapCheckbox?()
    }
}
