//
//  CommentView.swift
//  Youfilx
//
//  Created by 삼인조 on 2023/09/08.
//

import UIKit

class CommentView: UIViewController {
    
    private enum Section {
        case comment
    }
    
    private var commentCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, CommentThreadInformation>!
    private lazy var snapshot = NSDiffableDataSourceSnapshot<Section, CommentThreadInformation>()
    private let apiManager = APIManager.shared
    private let videoId: String?
    private let commetId: String?
    
    init(videoId: String? = nil, commentId: String? = nil) {
        self.videoId = videoId
        self.commetId = commentId
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentView {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchDatas(videoId: videoId, commentId: commetId)
    }
    private func configure() {
        collectionViewConfigure()
        view.addSubview(commentCollectionView)
        layout()
        applySnapshot(items: [])
    }
    
    private func layout() {
        commentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            commentCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            commentCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            commentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func collectionViewConfigure() {
        commentCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeCompositionalLayout())
        commentCollectionView.register(
            CommentViewCollectionViewCell.self,
            forCellWithReuseIdentifier: CommentViewCollectionViewCell.identifier
        )
        configureDataSource()
    }
    
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return compositionalLayout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CommentThreadInformation>(
            collectionView: commentCollectionView
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommentViewCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentViewCollectionViewCell else {return UICollectionViewCell()}
            cell.bind(item)
            return cell
        }
    }
    
    private func applySnapshot(items: [CommentThreadInformation]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.comment])
        snapshot.appendItems(items, toSection: .comment)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func applySnapshotAppend(items: [CommentThreadInformation], section: Section) {
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func fetchDatas(videoId: String? = nil, commentId: String? = nil) {
        if let videoId {
            apiManager.request(YoutubeAPI.commentThread(videoId)) { [weak self] result in
                guard let self else {return}
                switch result {
                case let .success(data):
                    do {
                        if let commentThreadInformations = try data.toObject(CommentThreadResponse.self).toCommentThreadInformations() {
                            DispatchQueue.main.async {
                                self.applySnapshotAppend(items: commentThreadInformations, section: .comment)
                            }
                        }
                    } catch {
                        print(error)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
        if let commentId {
            apiManager.request(YoutubeAPI.commentsList(commentId)) { [weak self] result in
                guard let self else {return}
                switch result {
                case let .success(data):
                    do {
                        if let commentThreadInformations = try data.toObject(CommentListResponse.self).toCommentThreadInformations() {
                            DispatchQueue.main.async {
                                self.applySnapshotAppend(items: commentThreadInformations, section: .comment)
                            }
                        }
                    } catch {
                        print(error)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}

