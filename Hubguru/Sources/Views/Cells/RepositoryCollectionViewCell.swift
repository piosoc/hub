//
// RepositoryCollectionViewCell.swift
//
// Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import EasyPeasy
import UIKit
import Down

/// A collection view cell of `RepositoriesViewController`.
public final class RepositoryCollectionViewCell: UICollectionViewCell {

	// MARK: Properties - subviews

	public private(set) lazy var ownerLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: UIFontWeightLight)
		label.textColor = .black
		return label
	}()

	private lazy var slashLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: UIFontWeightLight)
		label.textColor = .black
		label.text = "/"
		return label
	}()

	public private(set) lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: UIFontWeightMedium)
		label.textColor = .black
		return label
	}()
    
    public private(set) lazy var watchersLabel: UILabel = UILabel.regularFontLabel()
    public private(set) lazy var starsLabel: UILabel = UILabel.regularFontLabel()
    public private(set) lazy var forksLabel: UILabel = UILabel.regularFontLabel()
    public private(set) lazy var readmeLabel: UILabel = UILabel.regularFontLabel()
    private weak var markdownView: DownView?

    public var markdownString: String? {
        didSet {
            try? markdownView?.update(markdownString: markdownString ?? "")
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        clipsToBounds = false
        layer.cornerRadius = 12.0
        layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
        markdownView?.roundCorners([.bottomLeft, .bottomRight], radius: layer.cornerRadius)
    }

	/// Set up view hierarchy inside this cell.
    func setupViewHierarchy() {
		contentView.addSubview(ownerLabel)
		contentView.addSubview(slashLabel)
		contentView.addSubview(nameLabel)

		ownerLabel <- [Top(16), Left(16)]
		slashLabel <- [FirstBaseline().to(ownerLabel), Left(4).to(ownerLabel)]
		nameLabel <- [FirstBaseline().to(slashLabel), Left(4).to(slashLabel)]
        
        // Watchers
        contentView.addSubview(watchersLabel)
        let watchersImageView = UIImageView(image: UIImage(named: "Watchers"))
        contentView.addSubview(watchersImageView)
        watchersImageView <- [Top(16).to(ownerLabel), Left(16), Width(16), Height(16)]
        watchersLabel <- [CenterY().to(watchersImageView), Left(4).to(watchersImageView)]
        
        // Stars
        contentView.addSubview(starsLabel)
        let starsImageView = UIImageView(image: UIImage(named: "Stars"))
        contentView.addSubview(starsImageView)
        starsImageView <- [CenterY().to(watchersLabel), Left(16).to(watchersLabel), Width(16), Height(16)]
        starsLabel <- [CenterY().to(starsImageView), Left(4).to(starsImageView)]
        
        // Forks
        contentView.addSubview(forksLabel)
        let forksImageView = UIImageView(image: UIImage(named: "Forks"))
        contentView.addSubview(forksImageView)
        forksImageView <- [CenterY().to(starsLabel), Left(16).to(starsLabel), Width(16), Height(16)]
        forksLabel <- [CenterY().to(forksImageView), Left(4).to(forksImageView)]
        
        // ReadMe
        readmeLabel.text = "README.md"
        contentView.addSubview(readmeLabel)
        let readmeImageView = UIImageView(image: UIImage(named: "Markdown"))
        contentView.addSubview(readmeImageView)
        readmeImageView <- [Top(26).to(watchersLabel), Left(16), Width(16), Height(16)]
        readmeLabel <- [CenterY().to(readmeImageView), Left(4).to(readmeImageView)]
        
        [watchersImageView, starsImageView, forksImageView, readmeImageView].forEach { $0.contentMode = .center }
        
        // Separator
        let separatorView = UIView()
        separatorView.backgroundColor = .black
        contentView.addSubview(separatorView)
        separatorView <- [Left(), Right(), Height(1), Top(8).to(readmeLabel)]
        
        // Markdown
        guard let markdownView = try? DownView(frame: .zero, markdownString: "") else { return }
        addSubview(markdownView)
        self.markdownView = markdownView
        markdownView <- [Top().to(separatorView), Left(), Right(), Bottom()]
        markdownView.clipsToBounds = true
	}
}
