import UIKit
import PlaygroundSupport

class CollectionViewCell: UICollectionViewCell {}

class TableViewCell: UITableViewCell {}


class ViewController:
  UIViewController,
  UICollectionViewDataSource,
  UICollectionViewDelegate,
  UICollectionViewDelegateFlowLayout,
  UITableViewDataSource,
  UITableViewDelegate
{

  private var cellWidth: CGFloat {
    return (min(view.bounds.width, view.bounds.height) - 64) / 7
  }

  private lazy var collectionViewHeightConstraint: NSLayoutConstraint = {
    let constraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
    constraint.isActive = true
    return constraint
  }()

  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false

    collectionView.backgroundColor = .orange

    collectionView.register(
      CollectionViewCell.self,
      forCellWithReuseIdentifier: "cell")

    collectionView.dataSource = self
    collectionView.delegate = self

    return collectionView
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.dataSource = self
    tableView.delegate = self

    tableView.tableFooterView = UIView()

    tableView.backgroundColor = .blue
    tableView.rowHeight = UITableView.automaticDimension

    tableView.register(
      TableViewCell.self,
      forCellReuseIdentifier: "cell")

    return tableView
  }()


  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white

    let views = [
      "collectionView": collectionView,
      "tableView": tableView,
    ]
    views.values.forEach { view.addSubview($0) }
    [
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[collectionView(==tableView)]|",
        metrics: nil,
        views: views),
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:[collectionView][tableView]|",
        options: .alignAllCenterX,
        metrics: nil,
        views: views),
      ]
      .forEach { NSLayoutConstraint.activate($0) }

    collectionView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
      .isActive = true

    self.view = view
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    let height = collectionView.contentSize.height
    collectionViewHeightConstraint.constant = height
    collectionViewHeightConstraint.isActive = UIScreen.main.bounds.width < UIScreen.main.bounds.height
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    let height = collectionView.contentSize.height
    if height > 0 {
      collectionView.reloadData()
      collectionViewHeightConstraint.isActive = UIScreen.main.bounds.width < UIScreen.main.bounds.height
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int)
    -> Int
  {
    return 31
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "cell",
      for: indexPath)

    cell.backgroundColor = .red
    cell.contentView.subviews.forEach { $0.removeFromSuperview() }

    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false

    view.heightAnchor
      .constraint(equalToConstant: cellWidth).isActive = true

    view.widthAnchor
      .constraint(equalToConstant: cellWidth).isActive = true

    view.backgroundColor = .white

    let views = ["view": view]
    views.values.forEach { cell.contentView.addSubview($0) }
    [
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[view]|",
        metrics: nil,
        views: views),
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[view]|",
        metrics: nil,
        views: views),
      ]
      .forEach { NSLayoutConstraint.activate($0) }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }



  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int)
    -> Int {
      return 5
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath)
    cell.backgroundColor = .purple
    return cell
  }
}


PlaygroundPage.current.liveView = ViewController()
