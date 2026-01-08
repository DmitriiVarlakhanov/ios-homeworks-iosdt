//
//  RealmMainViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 1/6/26.
//

import UIKit
import RealmSwift

class RealmMainViewController: UIViewController {

    // MARK: - Properties

    var mainNavigationController: UINavigationController?

    private lazy var loadQuoteButton: UIButton = {
        let loadQuoteButton = UIButton()

        loadQuoteButton.translatesAutoresizingMaskIntoConstraints = false
        loadQuoteButton.setTitle("Load random quote", for: .normal)
        loadQuoteButton.setTitleColor(.white, for: .normal)
        loadQuoteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loadQuoteButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        loadQuoteButton.alpha = 1.0

        loadQuoteButton.clipsToBounds = true

        loadQuoteButton.layer.cornerRadius = 10

        loadQuoteButton.addTarget(
            self,
            action: #selector(loadQuoteButtonAction),
            for: .touchUpInside
        )

        return loadQuoteButton
    }()

    private lazy var goToQuoteCategoriesButton: UIButton = {
        let goToQuoteCategoriesButton = UIButton()

        goToQuoteCategoriesButton.translatesAutoresizingMaskIntoConstraints = false
        goToQuoteCategoriesButton.setTitle("To quotes' categories", for: .normal)
        goToQuoteCategoriesButton.setTitleColor(.white, for: .normal)
        goToQuoteCategoriesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        goToQuoteCategoriesButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        goToQuoteCategoriesButton.alpha = 1.0

        goToQuoteCategoriesButton.clipsToBounds = true

        goToQuoteCategoriesButton.layer.cornerRadius = 10

        goToQuoteCategoriesButton.addTarget(
            self,
            action: #selector(goToQuoteCategoriesButtonAction),
            for: .touchUpInside
        )

        return goToQuoteCategoriesButton
    }()

    private lazy var labelForQuote: UILabel = {
        let labelForQuote = UILabel()

        labelForQuote.translatesAutoresizingMaskIntoConstraints = false

        labelForQuote.numberOfLines = 5
        labelForQuote.textAlignment = .left
        labelForQuote.textColor = .black
        labelForQuote.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        labelForQuote.text = ""

        return labelForQuote
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSubviews()
        self.setupConstraints()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

        self.setupTabBarItem()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc private func loadQuoteButtonAction() {
        let path = "https://api.chucknorris.io/jokes/random"

        let url = URL(string: path)!

        let task = URLSession.shared.dataTask(with: url) { data, httpResponse, error in
            if let error = error {
                print(error.localizedDescription)

                return
            }

            if let httpResponse = httpResponse as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error: status code \(httpResponse.statusCode)")

                return
            }

            guard let data = data else {
                print("Error: no data returned")

                return
            }

            do {
                let object = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                var categoriesValue = object!["categories"] as? [String] ?? []

                if categoriesValue.isEmpty {
                    categoriesValue.append("untitled")
                }

                let realmJSONRequestModel = RealmJSONRequestModel(
                    categories: categoriesValue,
                    value: object!["value"] as? String ?? ""
                )

                DispatchQueue.main.async {
                    self.labelForQuote.text = realmJSONRequestModel.value
                }

                let realm = try! Realm()

                let storedRealmObjects = realm.objects(RealmModel.self)

                if storedRealmObjects.isEmpty {
                    let realmModel = RealmModel()

                    realmModel.categories.append(objectsIn: realmJSONRequestModel.categories)
                    realmModel.value = realmJSONRequestModel.value
                    realmModel.date = realmJSONRequestModel.date

                    try! realm.write {
                        realm.add(realmModel)
                    }

                    return
                } else {
                    var arrayToCheck: [String] = []

                    for storedRealmObject in storedRealmObjects {
                        arrayToCheck.append(storedRealmObject.value)
                    }

                    if arrayToCheck.contains(realmJSONRequestModel.value) {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(
                                title: "The quote already exists",
                                message: "Add another one",
                                preferredStyle: .alert
                            )

                            let action = UIAlertAction(
                                title: "Ok",
                                style: .cancel
                            )

                            alertController.addAction(action)

                            self.present(alertController, animated: true)
                        }

                        return
                    } else {
                        let realmModel = RealmModel()

                        realmModel.categories.append(objectsIn: realmJSONRequestModel.categories)
                        realmModel.value = realmJSONRequestModel.value
                        realmModel.date = realmJSONRequestModel.date

                        try! realm.write {
                            realm.add(realmModel)
                        }

                        return
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    @objc private func goToQuoteCategoriesButtonAction() {
        let realmCategoriesViewController = RealmCategoriesViewController()

        self.mainNavigationController?.pushViewController(realmCategoriesViewController, animated: true)
    }

    // MARK: - Private

    private func setupTabBarItem() {
        self.tabBarItem = UITabBarItem(
            title: "Realm database",
            image: UIImage(systemName: "quote.bubble"),
            tag: 0
        )
    }

    private func addSubviews() {
        self.view.addSubview(loadQuoteButton)
        self.view.addSubview(goToQuoteCategoriesButton)
        self.view.addSubview(labelForQuote)
    }

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            labelForQuote.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 100),
            labelForQuote.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            labelForQuote.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),

            loadQuoteButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 300),
            loadQuoteButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            loadQuoteButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            loadQuoteButton.heightAnchor.constraint(equalToConstant: 50),

            goToQuoteCategoriesButton.topAnchor.constraint(equalTo: loadQuoteButton.bottomAnchor, constant: 16),
            goToQuoteCategoriesButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            goToQuoteCategoriesButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            goToQuoteCategoriesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
