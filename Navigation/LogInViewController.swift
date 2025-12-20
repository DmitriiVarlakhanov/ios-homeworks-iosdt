//
//  LogInViewController.swift
//  Navigation
//
//  Created by Dmitrii Varlakhanov on 8/8/25.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    // MARK: - Properties

    var profileCoordinator: ProfileCoordinator?

    var randomPassword: String?

    private lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = UIImage(named: "VKIcon")

        return iconImageView
    }()

    private lazy var emailOrPhoneTextField: MyCustomTestField = {
        let emailOrPhoneTextField = MyCustomTestField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        emailOrPhoneTextField.placeholder = "Email or phone"
        emailOrPhoneTextField.backgroundColor = .systemGray6
        emailOrPhoneTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailOrPhoneTextField.textColor = .black
        emailOrPhoneTextField.autocapitalizationType = .none
        emailOrPhoneTextField.keyboardType = UIKeyboardType.default
        emailOrPhoneTextField.returnKeyType = UIReturnKeyType.done
        emailOrPhoneTextField.clearButtonMode = UITextField.ViewMode.whileEditing

        emailOrPhoneTextField.layer.cornerRadius = 0
        emailOrPhoneTextField.layer.borderWidth = 0
        emailOrPhoneTextField.layer.borderColor = .none

        emailOrPhoneTextField.delegate = self

        emailOrPhoneTextField.addTarget(
            self,
            action: #selector(invalidateTimer),
            for: .editingDidBegin
        )

        emailOrPhoneTextField.addTarget(
            self,
            action: #selector(enableOrDisableSignUpAndLogInButtons),
            for: .editingDidEnd
        )

        return emailOrPhoneTextField
    }()

    private lazy var passwordTextField: MyCustomTestField = {
        let passwordTextField = MyCustomTestField(insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))

        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordTextField.textColor = .black
        passwordTextField.autocapitalizationType = .none
        passwordTextField.keyboardType = UIKeyboardType.default
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.isSecureTextEntry = true

        passwordTextField.layer.cornerRadius = 0
        passwordTextField.layer.borderWidth = 0
        passwordTextField.layer.borderColor = .none

        passwordTextField.delegate = self

        passwordTextField.addTarget(
            self,
            action: #selector(invalidateTimer),
            for: .editingDidBegin
        )

        passwordTextField.addTarget(
            self,
            action: #selector(enableOrDisableSignUpAndLogInButtons),
            for: .editingDidEnd
        )

        return passwordTextField
    }()

    private lazy var logInStackView: UIStackView = {
        let logInStackView = UIStackView()

        logInStackView.translatesAutoresizingMaskIntoConstraints = false
        logInStackView.axis = .vertical
        logInStackView.spacing = 0.5
        logInStackView.backgroundColor = .lightGray
        logInStackView.alignment = .fill
        logInStackView.distribution = .fillEqually

        logInStackView.clipsToBounds = true

        logInStackView.layer.borderColor = UIColor.lightGray.cgColor
        logInStackView.layer.borderWidth = 0.5
        logInStackView.layer.cornerRadius = 10

        logInStackView.addArrangedSubview(emailOrPhoneTextField)
        logInStackView.addArrangedSubview(passwordTextField)

        return logInStackView
    }()

    private lazy var logInButton: UIButton = {
        let logInButton = UIButton()

        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log In", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        logInButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        logInButton.alpha = 1.0

        logInButton.clipsToBounds = true

        logInButton.layer.cornerRadius = 10

        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)

        logInButton.isEnabled = false

        return logInButton
    }()

    private lazy var logInScrollView: UIScrollView = {
        let logInScrollView = UIScrollView()

        logInScrollView.translatesAutoresizingMaskIntoConstraints = false
        logInScrollView.showsHorizontalScrollIndicator = false
        logInScrollView.showsVerticalScrollIndicator = true
        logInScrollView.backgroundColor = .white

        return logInScrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white

        return contentView
    }()

    private lazy var generatePassword: UIButton = {
        let generatePassword = UIButton()

        generatePassword.translatesAutoresizingMaskIntoConstraints = false
        generatePassword.setTitle("Generate password", for: .normal)
        generatePassword.setTitleColor(.white, for: .normal)
        generatePassword.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        generatePassword.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        generatePassword.alpha = 1.0

        generatePassword.clipsToBounds = true

        generatePassword.layer.cornerRadius = 10

        generatePassword.addTarget(self, action: #selector(genaratePassword), for: .touchUpInside)

        return generatePassword
    }()

    private lazy var bruteForce: UIButton = {
        let bruteForce = UIButton()

        bruteForce.translatesAutoresizingMaskIntoConstraints = false
        bruteForce.setTitle("Brute force", for: .normal)
        bruteForce.setTitleColor(.white, for: .normal)
        bruteForce.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        bruteForce.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        bruteForce.alpha = 1.0

        bruteForce.clipsToBounds = true

        bruteForce.layer.cornerRadius = 10

        bruteForce.addTarget(self, action: #selector(bruteForcePassword), for: .touchUpInside)

        return bruteForce
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.hidesWhenStopped = true

        return activityIndicator
    }()

    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()

        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        signUpButton.setBackgroundImage(UIImage(named: "PixelVKColor"), for: .normal)
        signUpButton.alpha = 1.0

        signUpButton.clipsToBounds = true

        signUpButton.layer.cornerRadius = 10

        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)

        signUpButton.isEnabled = false

        return signUpButton
    }()

    var logInDelegate: LogInViewControllerDelegate? = LogInInspector()

    var timer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addSubviews()
        setupConstraints()
        createTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObservers()
    }

    // MARK: - Actions

    @objc func logInButtonTapped() {
        if logInDelegate!.check(
            login: self.emailOrPhoneTextField.text ?? "",
            password: self.passwordTextField.text ?? ""
        ) {
            do {
                try logInButtonTappedNotObjc()
            } catch MyError.unauthorized {
                let alertController = UIAlertController(
                    title: "Неверный логин или пароль (.unauthorized)",
                    message: "Повторите попытку",
                    preferredStyle: .alert
                )

                let action = UIAlertAction(
                    title: "OK",
                    style: .cancel
                )

                alertController.addAction(action)

                self.present(alertController, animated: true)
            } catch {
                print("Unknowed error")
            }
        }
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height

        logInScrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        logInScrollView.contentInset.bottom = 0.0
    }

    @objc func genaratePassword() -> String {
        var randomPassword: String = ""

        for _ in 1...4 {
            randomPassword.append(String().printable.randomElement()!)
        }

        print("Generated password - \(randomPassword)")

        self.randomPassword = randomPassword

        return randomPassword
    }

    @objc func bruteForcePassword() {
        self.activityIndicator.startAnimating()

        DispatchQueue.global(qos: .default).async {
            let bruteForcePassword = BruteForce().bruteForce(passwordToUnlock: self.randomPassword ?? "")

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()

                self.passwordTextField.text = bruteForcePassword
                self.passwordTextField.isSecureTextEntry = false
            }
        }
    }

    @objc func showHint() {
        let alertController = UIAlertController(
            title: "Подсказка",
            message: "Введите пароль и/или логин в поля ввода",
            preferredStyle: .alert
        )

        self.present(alertController, animated: true)

        let alertAction = UIAlertAction(
            title: "Ок",
            style: .cancel
        )

        alertController.addAction(alertAction)
    }

    @objc func invalidateTimer() {
        self.timer?.invalidate()
    }

    @objc func signUp() {
        self.logInDelegate!.signUp(
            login: self.emailOrPhoneTextField.text ?? "",
            password: self.passwordTextField.text ?? ""
        )
    }

    @objc func enableOrDisableSignUpAndLogInButtons() {
        if (self.emailOrPhoneTextField.text != "" && self.passwordTextField.text != "") {
            logInButton.isEnabled = true
            signUpButton.isEnabled = true
        } else {
            logInButton.isEnabled = false
            signUpButton.isEnabled = false
        }
    }

    // MARK: - Private

    private func setupConstraints() {
        let safeAreaGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            logInScrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            logInScrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            logInScrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            logInScrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

            contentView.trailingAnchor.constraint(equalTo: logInScrollView.trailingAnchor),
            contentView.leadingAnchor.constraint(equalTo: logInScrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: logInScrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: logInScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: logInScrollView.widthAnchor),

            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            iconImageView.heightAnchor.constraint(equalToConstant: 100),

            logInStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInStackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 120),
            logInStackView.heightAnchor.constraint(equalToConstant: 100),

            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInButton.topAnchor.constraint(equalTo: logInStackView.bottomAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),

            generatePassword.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            generatePassword.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            generatePassword.heightAnchor.constraint(equalToConstant: 50),
            generatePassword.widthAnchor.constraint(equalToConstant: 150),

            bruteForce.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bruteForce.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            bruteForce.heightAnchor.constraint(equalToConstant: 50),
            bruteForce.widthAnchor.constraint(equalToConstant: 150),

            activityIndicator.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),

            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.topAnchor.constraint(equalTo: bruteForce.bottomAnchor, constant: 16),
            signUpButton.heightAnchor.constraint(equalToConstant: 45),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func addSubviews() {
        self.view.addSubview(logInScrollView)

        logInScrollView.addSubview(contentView)

        contentView.addSubview(iconImageView)
        contentView.addSubview(logInStackView)
        contentView.addSubview(logInButton)
        contentView.addSubview(generatePassword)
        contentView.addSubview(bruteForce)
        contentView.addSubview(signUpButton)

        passwordTextField.addSubview(activityIndicator)
    }

    private func setupView() {
        self.view.backgroundColor = .white
    }

    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.removeObserver(self)
    }

    private func createTimer() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 120,
            target: self,
            selector: #selector(showHint),
            userInfo: nil,
            repeats: true
        )

        // Задача №1
        // В данном примере таймер создается для того, чтобы инициировать появление alertController в качестве
        // подсказки после 30 секунд ожидания действия ввода.
    }

    private func logInButtonTappedNotObjc() throws {
#if DEBUG
        let service = TestUserService()
#else
        let service = CurrentUserService()
#endif
        guard service.testUser != nil else {
            preconditionFailure("User must not be nil")
        }

        if service.loginCheck(login: emailOrPhoneTextField.text ?? "") != nil && self.logInDelegate!.check(login: emailOrPhoneTextField.text ?? "", password: passwordTextField.text ?? "") {
            let profileViewController = ProfileViewController()

            profileViewController.user = service.testUser

            profileCoordinator?.goToProfileViewController(profileViewController: profileViewController)

            self.timer?.invalidate()
        } else {
            throw MyError.unauthorized
        }
    }
}

// MARK: - UITextFieldDelegate Protocol

extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}
