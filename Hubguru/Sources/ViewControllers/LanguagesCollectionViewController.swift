//
//  LanguagesCollectionViewController.swift
//  Hubguru
//
//  Copyright © 2016 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import RxSwift

protocol LanguagesCollectionViewControllerDelegate: class {
    func didSelect(language: Language)
}

final class LanguagesCollectionViewController: UICollectionViewController {
    
    weak var delegate: LanguagesCollectionViewControllerDelegate?
    
    private let disposeBag = DisposeBag()
    
    convenience init(delegate: LanguagesCollectionViewControllerDelegate?) {
        self.init(collectionViewLayout: CollectionViewLanguageLayout())
        self.delegate = delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = NSLocalizedString("LanguagesCollectionViewController.title", comment: "Languages")
        
        guard let collectionView = collectionView else { return }
        collectionView.register(LanguageCollectionViewCell.self, forCellWithReuseIdentifier: LanguageCollectionViewCell.identifier)

        Observable.just(Language.allValues)
            .bind(to: collectionView.rx.items(cellIdentifier: LanguageCollectionViewCell.identifier)) { _, language, cell in
                (cell as? LanguageCollectionViewCell)?.language = language
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.collectionView?.cellForItem(at: indexPath) as? LanguageCollectionViewCell,
                    let language = cell.language else { return }
                self?.delegate?.didSelect(language: language)
            })
            .disposed(by: disposeBag)
    }
}
