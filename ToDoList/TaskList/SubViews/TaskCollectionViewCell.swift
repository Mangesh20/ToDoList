//
//  TaskCollectionViewCell.swift
//  ToDoList
//
//  Created by mangesht on 20/04/23.
//

import UIKit

protocol TaskCollectionViewCellDelegate: AnyObject {
    func deleteTapFor(task: Task, indexPath: IndexPath)
    func markDoneFor(task: Task, indexPath: IndexPath)
}





class TaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMarkDone: UIButton!
    @IBOutlet weak var stackViewLables: UIStackView!
    @IBOutlet weak var kHeightStackView: NSLayoutConstraint!
    @IBOutlet weak var kHeightPriorityView: NSLayoutConstraint!
    @IBOutlet weak var lblReaminingTime: UILabel!
    @IBOutlet weak var lblValueRemainingTime: UILabel!
    var longPressGestureForDone: UILongPressGestureRecognizer!
    var longPressGestureForDelete: UILongPressGestureRecognizer!

    @IBOutlet weak var kHeightDoneButtom: NSLayoutConstraint!
    private var timerForLableRefresh: Timer?
    weak var delegate: TaskCollectionViewCellDelegate?
    
    private let kValueHeightDoneButton: CGFloat = 40
    private let kValueHeightStackView: CGFloat = 30
    private let kValueHeightPriorityView: CGFloat = 5
    
    var indexPath : IndexPath?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Add a border radius
        layer.cornerRadius = 8.0
        
        // Add a shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // Adjust the shadow path to improve performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    var task: Task? {
        didSet {
            if task != nil  {
                if !(task?.isDone ?? false) {
                    timerForLableRefresh = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.configureCell), userInfo: nil, repeats: true)
                }
                configureCell()
            } else {
                nameLabel.text = ""
                lblValueRemainingTime.text = ""
                priorityView.backgroundColor = AppTheme.TaskPriorityColors.none
                timerForLableRefresh?.invalidate()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
        if let task = task, let indexPath = indexPath {
            delegate?.deleteTapFor(task: task, indexPath: indexPath)
        }
    }
    
    @objc func configureCell() {
        
        guard let task = task else { return }
        nameLabel.text = task.name
                
        nameLabel.textColor = AppTheme.TaskCellStyles.nameLabelColor
        nameLabel.font = AppTheme.TaskCellStyles.nameLabelFont
        
        lblValueRemainingTime.textColor = AppTheme.TaskCellStyles.valueLabelColor
        lblReaminingTime.textColor = AppTheme.TaskCellStyles.remainingTimeLabelColor
        
        lblValueRemainingTime.font = AppTheme.TaskCellStyles.valueLabelFont
        lblReaminingTime.font = AppTheme.TaskCellStyles.remainingTimeLabelFont


        contentView.backgroundColor = AppTheme.TaskCellStyles.taskCellBgColor
        
        btnDelete.setImage(UIImage(systemName: "trash"), for: .normal)
        btnDelete.tintColor = AppTheme.TaskCellStyles.deleteIconColor
        
        btnMarkDone.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        btnMarkDone.tintColor = AppTheme.TaskCellStyles.doneIconColor

        if let deadline = task.deadline {
            let timeRemaining = Int(deadline.timeIntervalSinceNow)
            if timeRemaining < 0 {
                lblValueRemainingTime.text = "Overdue"
                lblValueRemainingTime.textColor = AppTheme.TaskCellStyles.reaminingTimeOverdueColor
            } else if timeRemaining < 3600 {
                lblValueRemainingTime.text = "Due now"
                lblValueRemainingTime.textColor = .red
            } else {
                let minutes = (timeRemaining / 60) % 60
                let hours = (timeRemaining / 3600) % 24
                let days = timeRemaining / 86400
                if days > 0 {
                    lblValueRemainingTime.text = "\(days)d"
                } else if hours > 0 {
                    lblValueRemainingTime.text = "\(hours)h"
                } else {
                    lblValueRemainingTime.text = "\(minutes)m"
                }
                lblValueRemainingTime.textColor = AppTheme.TaskCellStyles.valueLabelColor
            }
        } else {
            lblValueRemainingTime.text = ""
        }
        switch task.priority {
        case .high:
            priorityView.backgroundColor = AppTheme.TaskPriorityColors.high
        case .medium:
            priorityView.backgroundColor =  AppTheme.TaskPriorityColors.medium
        case .low:
            priorityView.backgroundColor =  AppTheme.TaskPriorityColors.low
        case .none:
            priorityView.backgroundColor =  AppTheme.TaskPriorityColors.none
        }
        
    }
    
    private var timer: Timer?
    private var progress: CGFloat = 0.0
    private var progressViewCircular = CircularProgressView()
    var isDone: Bool = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupLongPressGesture()
        addSubview(progressViewCircular)
        
        // Set up constraints for circularProgressView
        progressViewCircular.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressViewCircular.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            progressViewCircular.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            progressViewCircular.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            progressViewCircular.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
        // Hide circularProgressView initially
        hideCircularProgress()
        
    }
    
    func showCircularProgress(isDone: Bool) {
        progressViewCircular.isHidden = false
        progressViewCircular.isDone = isDone
        progressViewCircular.showCheckmark()
        
    }
    
    func hideCircularProgress() {
        progressViewCircular.isHidden = true
    }
    
    private func setupLongPressGesture() {
        longPressGestureForDone = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureDone(_:)))
        addGestureRecognizer(longPressGestureForDone)
        longPressGestureForDelete = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureDelete(_:)))
        btnDelete.addGestureRecognizer(longPressGestureForDelete)
    }
    
    @objc private func handleLongPressGestureDone(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            startTimer(isDone: true)
        } else {
            stopTimer()
        }
    }
    
    @objc private func handleLongPressGestureDelete(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            startTimer(isDone: false)
        } else {
            stopTimer()
        }
    }
    
    private func startTimer(isDone: Bool) {
        showCircularProgress(isDone: isDone)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            self.progress += 0.01 / 1.5 // Update progress for 3 seconds
            if self.progress >= 1.0 {
                self.stopTimer()
                self.hideCircularProgress()
                self.markAsDone(isDone:  isDone)
            } else {
                self.updateProgress()
            }
        })
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
//        progressViewCircular.isHidden = true
        resetProgress()
    }
    
    private func updateProgress() {
        // Update your circular progress indicator here based on the `progress` property
        setProgress(progress: Float(self.progress), forCircularProgress: progressViewCircular)
    }
    
    private func resetProgress() {
        // Reset your circular progress indicator here
        progressViewCircular.reset()
    }
    
    
    private func markAsDone(isDone: Bool) {
        // Mark your task as done here
        //progressViewCircular.reset()
        if isDone {
            if let task = task, let indexPath = indexPath {
                delegate?.markDoneFor(task: task, indexPath: indexPath)
            }

        } else {
            if let task = task, let indexPath = indexPath {
                delegate?.deleteTapFor(task: task, indexPath: indexPath)
            }

        }
        
    }
    
    func setProgress(progress: Float, forCircularProgress progressView: CircularProgressView) {
        // Clamp the progress value to the range [0, 1]
        let clampedProgress = min(max(progress, 0.0), 1.0)
        
        // Set the progress value of the circular progress view
        progressView.setProgress(CGFloat(clampedProgress))
        
        // If the progress value is equal to 1.0, show the checkmark icon
        if clampedProgress == 1.0 {
            progressView.showCheckmark()
        } else {
            progressView.hideCheckmark()
        }
    }
    
}
