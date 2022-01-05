//
//  MovieListViewController.swift
//  360MedicsTestProject
//
//  Created by Guillaume Bourachot on 13/12/2021.
//

import Foundation
import UIKit
import Combine
import MBProgressHUD

protocol MovieListDisplayLogic: AnyObject {
    func searchMovies(searchText: String)
    func routeToDetail(movieId: Movie.Identifier)
}

class MovieListViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    // MARK: - Value Types
    typealias DataSource = UITableViewDiffableDataSource<Section, MovieList.CellModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MovieList.CellModel>
    
    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(nibName: "MovieListView", bundle: nil)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiSearchBar: UISearchBar!
    
    // MARK: - Variables
    private var subscriptions = [AnyCancellable]()
    private let viewModel: MovieListViewModelLogic = MovieListViewModel(movieAPI: MovieAPI.shared)
    private let throttleIntervalInMilliseconds = 500
    private lazy var dataSource = makeDataSource()
    @Published var keyStroke: String = ""
    
    // MARK: - Overrided functions
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTableView()
        setUpObservers()
        self.viewModel.displayEmptyCell()
        self.viewModel.setDelegate(to: self)
        applySnapshot(cellModels: [.empty], animatingDifferences: false)
    }
    
    private func bindTableView() {
        self.tableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListTableViewCell")
        self.tableView.register(UINib(nibName: "ErrorTableViewCell", bundle: nil), forCellReuseIdentifier: "ErrorTableViewCell")
        self.tableView.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
        tableView.tableFooterView = UIView()
        self.uiSearchBar.delegate = self
        self.tableView.delegate = self
    }
    
    private func setUpObservers() {
        $keyStroke
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (searchString) in
                self.viewModel.searchMovie(searchText: searchString)
            })
            .store(in: &subscriptions)
        self.viewModel.itemsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (cellModels) in
                self.applySnapshot(cellModels: cellModels)
            })
            .store(in: &subscriptions)
    }
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource(
        tableView: tableView,
        cellProvider: { (tableView, indexPath, cellModel) ->
          UITableViewCell? in
          
            switch cellModel {
            case .movie(let movie):
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell",
                                                                    for: indexPath) as? MovieListTableViewCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: movie)
                return cell
            case .error(let errorMessage):
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell",
                                                                    for: indexPath) as? ErrorTableViewCell else {
                    return UITableViewCell()
                }
                cell.configureCell(with: errorMessage)
                return cell
            case .empty:
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell",
                                                                    for: indexPath) as? EmptyTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            }
        })
      
      return dataSource
    }
    
    func applySnapshot(cellModels: [MovieList.CellModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(cellModels)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension MovieListViewController: MovieListDisplayLogic {
    func searchMovies(searchText: String) {
        self.viewModel.searchMovie(searchText: searchText)
    }
    
    func routeToDetail(movieId: Movie.Identifier) {
        let destinationVC = MovieDetailsViewController()
        destinationVC.movieIdentifier = movieId
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension MovieListViewController: MovieListViewModelDelegate {
    func showLoader(_ should: Bool) {
        if should {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
        } else {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}

//MARK: - UISearchBar Delegate
extension MovieListViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.keyStroke = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.keyStroke = ""
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellModel = dataSource.itemIdentifier(for: indexPath) else {
          return
        }
        switch cellModel {
        case .movie(let movie):
            self.routeToDetail(movieId: movie.identifier)
        case .empty, .error:
            break
        }
    }
}
