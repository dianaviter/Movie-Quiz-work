import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Lifecycle

    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()

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
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        showAnswer(answer: false)
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuestionShowedViewModel {
        let questionStep = QuestionShowedViewModel (
            question: model.text,
            image: UIImage(named: model.image) ?? UIImage (),
            questionNumber: ("\(currentQuestionIndex + 1)/\(questionsAmount)"))
        return questionStep
    }
    
    private func show (quiz step: QuestionShowedViewModel) {
        textLabel.text = step.question
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
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
                self.questionFactory.requestNextQuestion()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
                guard let self = self else { return }
                self.showResult()
            }
        }
    }
    
    private func showResult () {
        let alert = UIAlertController(title: "Этот раунд окончен!",
                                      message: "Ваш результат \(correctAnswers)/\(questionsAmount)",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.correctAnswers = 0
            self.currentQuestionIndex = 0
            self.questionFactory.requestNextQuestion()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
