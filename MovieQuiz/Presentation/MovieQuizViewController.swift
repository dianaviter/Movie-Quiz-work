import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private let alertPresenter: AlertPresenterProtocol = AlertPresenter()
    private var statisticService: StatisticServiceProtocol = StatisicService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        showLoadingIndicator()
        questionFactory.loadData()
        
        setupFonts()
        setupImageView()
    }
    
    private func setupFonts() {
        let customFont = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = customFont
        noButton.titleLabel?.font = customFont
        
        questionTitleLabel.font = customFont
        counterLabel.font = customFont
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
    }
    
    private func setupImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    private func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            print("Failed to load the question.")
            return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        showAnswer(answer: true)
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswer(answer: false)
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    
    private func show (quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func showAlert(quiz: AlertModel) {
        let alert = AlertPresenter()
        alert.delegate = self
        
        alert.showAlert(quiz: quiz)
    }
    
    private func showCurrentQuestion (_ question: QuizQuestion) {
        let viewModel = convert(model: question)
        show(quiz: viewModel)
        
        styleImageView()
    }
    
    private func styleImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    
    private func showAnswer (answer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        if currentQuestion.correctAnswer == answer {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questionsAmount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.questionFactory?.requestNextQuestion()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
                guard let self = self else { return }
                self.showResult()
            }
        }
    }
    
    private func showResult () {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let resultMessage = "\(correctAnswers)/\(questionsAmount)"
        let numberOfQuizes = statisticService.gamesCount
        let record: String
        
        if let bestGame = statisticService.bestGame {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy hh:mm"
            let dateString = dateFormatter.string(from: bestGame.date)
            record = "\(bestGame.correct)/\(bestGame.total) (\(dateString))"
        } else {
            record = "Not found"
        }
        
        let averageAccuracy = statisticService.totalAccuracy
        
        let model = AlertModel(
            title: "Этот раунд окончен!",
            message: """
                    Ваш результат \(resultMessage)
                    Количество сыгранных квизов: \(numberOfQuizes)
                    Рекорд: \(record)
                    Средняя точность: \(String(format: "%.2f", averageAccuracy * 100))%
                    """,
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                self?.correctAnswers = 0
                self?.currentQuestionIndex = 0
                self?.questionFactory?.requestNextQuestion()
            }
        )
        showAlert(quiz: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.loadData()
            }
        )
        showAlert(quiz: model)
    }
}


