//
// RepositoriesViewModel.swift
//
// Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional

/// A view model of `RepositoriesViewController`.
public final class RepositoriesViewModel {

	// MARK: Initializers

	/// Inititialize an instance with its dependencies.
	///
	/// - Parameters:
	///     - apiRequester: An instance of API requester.
    public init(apiRequester: ApiRequester, delegate: RepositoriesViewControllerDelegate?) {
		self.apiRequester = apiRequester
        self.delegate = delegate
        setupRx()
	}
    
    convenience init(apiRequester: ApiRequester, delegate: RepositoriesViewControllerDelegate?, language: Language, sortType: SortType) {
        self.init(apiRequester: apiRequester, delegate: delegate)
        self.language = language
        self.sortType = sortType
        sortRepositories(by: sortType)
    }
    
    // MARK: Properties - internal
    
    var sortType: SortType?
    var language: Language?
    weak var delegate: RepositoriesViewControllerDelegate?
    let rxDidTapSortButton = PublishSubject<Void>()

	// MARK: Properties - private

	/// An instance of API requester.
	private let apiRequester: ApiRequester

	/// An instance of pageable provider.
	private var provider: PageableProvider {
		return PageableProvider(apiRequester: apiRequester)
	}
    
    private let disposeBag = DisposeBag()

	// MARK: Properties - data

	/// An observable of repositories.
    public lazy var repositoriesObservable: Observable<[Repository]> = self.repositoriesPublishSubject.asObservable()
    private let repositoriesPublishSubject = PublishSubject<[Repository]>()

	// MARK: Properties - collection view

	/// A collection view cell class.
	public let collectionViewCellClass: UICollectionViewCell.Type = RepositoryCollectionViewCell.self

	/// A collection view cell reuse identifier.
	public var collectionViewCellReuseIdentifier: String {
		return String(describing: collectionViewCellClass)
	}

	/// A closure that configures a collection view cell. To be used with Rx
	/// data source bindings.
	public var collectionViewCellConfigure: (Int, Repository, UICollectionViewCell) -> Void {
		return { [unowned self] row, repository, cell in
            guard let cell = cell as? RepositoryCollectionViewCell else { return }
            cell.setupViewHierarchy()
            cell.ownerLabel.text = repository.owner
            cell.nameLabel.text = repository.name
            cell.starsLabel.text = "\(repository.stars)"
            cell.forksLabel.text = "\(repository.forks)"
            cell.watchersLabel.text = "\(repository.watchers)"

            cell.backgroundColor = Language.allValues.map({ $0.color })[row % 5]
            
            let query = Request.readme(repository).query
            self.apiRequester.jsonResponse(for: query)
                .map { _, json -> URL? in
                    guard let urlString = json.dictionaryObject?["download_url"] as? String else { return nil }
                    
                    return URL(string: urlString)
                }
                .filterNil()
                .map { url in
                    return try? String(contentsOf: url, encoding: .utf8)
                }
                .filterNil()
                .subscribe(onNext: { markdownString in
                    cell.markdownString = markdownString
                })
                .disposed(by: self.disposeBag)
		}
	}
    
    func sortRepositories(by sortType: SortType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.sortType = sortType
        repositories()
            .do(onNext: { _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .bind(to: repositoriesPublishSubject)
            .disposed(by: disposeBag)
    }
    
    private func repositories() -> Observable<[Repository]> {
        guard let language = language, let sortType = sortType else { return .just([]) }
        let query = Request.repos(language, sortType).query
        
        return apiRequester
            .jsonResponse(for: query)
            .map { $0.json }
            .mapRepositories()
            .filterNil()
    }

    private func setupRx() {
        rxDidTapSortButton
            .subscribe(onNext: { [weak delegate = self.delegate] _ in
                delegate?.didTapSortButton()
            })
            .disposed(by: disposeBag)
    }
}
