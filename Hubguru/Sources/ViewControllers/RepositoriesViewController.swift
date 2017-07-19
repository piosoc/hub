//
// RepositoriesViewController.swift
//
// Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import EasyPeasy

public protocol RepositoriesViewControllerDelegate: class {
    func didTapSortButton()
}

/// A view controller responsible for displaying repositories.
public final class RepositoriesViewController: UIViewController {
    
    // MARK: Properties
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewWalletLayout())
    
    //MMCollectionView(frame: .zero, collectionViewLayout: CollectionViewWalletLayout())
    private let disposeBag = DisposeBag()
    fileprivate var viewModel: RepositoriesViewModel!

	// MARK: Initializers

	/// Initialize an instance with a view model.
	///
	/// - Parameters:
	///     - viewModel: An instance of a view model.
    convenience init(viewModel: RepositoriesViewModel) {
        self.init()
		self.viewModel = viewModel
	}

    // MARK: Overrides
    
    /// - SeeAlso: UIViewController.viewDidLoad()
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupReactiveBindings()
    }
    
	// MARK: Setup

    private func setupUI() {
        title = "\(viewModel.language?.rawValue ?? "") \(NSLocalizedString("RepositoriesViewController.repositories", comment: "Repositories"))"
        
        view.addSubview(collectionView)
        collectionView <- [Top(16), Left(16), Right(16), Bottom()]
        
        collectionView.register(RepositoryCollectionViewCell.self, forCellWithReuseIdentifier: viewModel.collectionViewCellReuseIdentifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("RepositoriesViewController.sort", comment: "Sort"), style: .plain, target: nil, action: nil)
        
        guard let layout = collectionView.collectionViewLayout as? CollectionViewWalletLayout else { return }
        layout.titleHeight = 50.0
        layout.bottomShowCount = 4
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? CollectionViewWalletLayout else { return }
        layout.cardHeight = view.frame.height - 100.0
    }
    
	/// Set up reactive bindings inside this view controller. This should be
	/// called once when setting up the view controller.
	private func setupReactiveBindings() {
        viewModel.repositoriesObservable
            .bind(to: collectionView.rx.items(cellIdentifier: viewModel.collectionViewCellReuseIdentifier))(viewModel.collectionViewCellConfigure)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                (self?.collectionView.collectionViewLayout as? CollectionViewWalletLayout)?.featuredIndexPath = indexPath
            })
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .bind(to: viewModel.rxDidTapSortButton)
            .disposed(by: disposeBag)
    }
}

extension RepositoriesViewController: SortingViewControllerDelegate {
    func sortingController(sortingViewController: SortingViewController, didSelect sortType: SortType) {
        navigationController?.popViewController(animated: true)
        viewModel.sortRepositories(by: sortType)
    }
}
