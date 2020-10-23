//
//  UserCalendarViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 8/31/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import JTAppleCalendar

class UserCalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: Time Selection
    @IBOutlet var timeSelectionView: UIView!
    
    @IBOutlet var timeView1: UIView!
    @IBOutlet var timeView2: UIView!
    @IBOutlet var timeView3: UIView!
    @IBOutlet var timeView4: UIView!
    
    @IBOutlet var timeOneLabel: UILabel!
    @IBOutlet var timeTwoLabel: UILabel!
    @IBOutlet var timeThreeLabel: UILabel!
    @IBOutlet var timeFourLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeOneLabel.text = "10:00 am"
        timeTwoLabel.text = "12:00 pm"
        timeThreeLabel.text = "2:00 pm"
        timeFourLabel.text = "4:00 pm"

        setUpSubViews()
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        timeSelectionView.isHidden = true
    }
    
    //MARK: - Recieve Part Data
    var part: FirebaseServices!
    var serviceDate: String = ""
    
    var cartArray = [FirebaseServices]() {
        didSet{
            print("Calendar Cart: \(cartArray.count)")
        }
    }
    
    var selectedDate = ""
    
    func setUpSubViews() {
        
        
        
        nextButton.layer.cornerRadius = 30
        calendarView.layer.borderColor = #colorLiteral(red: 0.1722870469, green: 0.1891334951, blue: 0.2275838256, alpha: 1)
        calendarView.backgroundColor = .white
        calendarView.layer.borderWidth = 1.0
        calendarView.layer.cornerRadius = 12
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.allowsRangedSelection = true
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.3).isActive = true
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        
        timeSelectionView.layer.cornerRadius = 20
        timeView1.layer.cornerRadius = 10
        timeView2.layer.cornerRadius = 10
        timeView3.layer.cornerRadius = 10
        timeView4.layer.cornerRadius = 10
    }
    
    //MARK: - Set Up Animation
          func animateNext() {
              UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
                  self.nextButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                      
                  }) { (_) in //Is finished
                      
                      
                      UIView.animate(withDuration: 0.01, animations: {
                          self.nextButton.transform = .identity
                      })
                                      
                  }
          }
    
    //MARK: - Formatters
    let jtCalCompareFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }()

    let jtCalMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    let jtCalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.timeStyle = .none
        formatter.setLocalizedDateFormatFromTemplate("yyyy MM dd")
        formatter.dateFormat = "MMM yyyy dd"
        return formatter
    }()
    
    
    
    @IBAction func nextbuttonTapped(_ sender: Any) {
        animateNext()
    }
    
    
    //MARK: - Recieve the Part then Pass Both the Part Data & The Service Date Data Here In the Segue to Confirm
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        if segue.identifier == "userCalendarSegue" {
            let navController = segue.destination as! UINavigationController
            if let detailVC = navController.viewControllers[0] as? UserConfirmViewController {
               detailVC.navigationController?.navigationBar.isHidden = true
                detailVC.part = part
                detailVC.serviceDate = serviceDate
                detailVC.cartArray = cartArray
                detailVC.selectedDate = selectedDate
            }
        }
        
    }
    
    //MARK: - Gesture Recognizers
    @IBAction func tapViewOne(_ sender: Any) {
        // Time One
        timeView1.backgroundColor = .green
        timeOneLabel.textColor = .black
        
        // Time Two
        timeView3.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeTwoLabel.textColor = .white
        
        // Time Four
        timeView4.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeFourLabel.textColor = .white
        
        // Time Three
        timeView2.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeThreeLabel.textColor = .white
        selectedDate = timeOneLabel.text!

        
    }
    
    
    
    @IBAction func tapViewTwo(_ sender: Any) {
        //Time Two
        timeView3.backgroundColor = .green
        timeTwoLabel.textColor = .black
        
        //Time One
        timeView1.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeOneLabel.textColor = .white
        
        // Time Four
        timeView4.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeFourLabel.textColor = .white
        
        // Time Three
        timeView2.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeThreeLabel.textColor = .white
        selectedDate = timeTwoLabel.text!

    }
    
    
    @IBAction func tapViewThree(_ sender: Any) {
        
        //Time One
        timeView1.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeOneLabel.textColor = .white
        // Time Two
        timeView3.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeTwoLabel.textColor = .white
        // Time Four
        timeView4.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
              
        timeFourLabel.textColor = .white
        
        // Time Three
        timeView2.backgroundColor = .green
        timeThreeLabel.textColor = .black
        selectedDate = timeThreeLabel.text!
        
    }
    
    
    @IBAction func tapViewFour(_ sender: Any) {
        //Time One
        timeView1.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeOneLabel.textColor = .white
        // Time Two
        timeView3.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeTwoLabel.textColor = .white
        
        // Time Four
        timeView4.backgroundColor = .green
        timeFourLabel.textColor = .black
        
        // Time Three
        timeView2.backgroundColor = UIColor(red: 52/255, green: 78/255, blue: 94/255, alpha: 1)
        
        timeThreeLabel.textColor = .white
        print(timeFourLabel.text)
        selectedDate = timeFourLabel.text!
        
    }
    
    

}

extension UserCalendarViewController: JTACMonthViewDataSource, JTACMonthViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        handleCellSelected(cell: cell, cellState: cellState)
        
        
        let dateString = dateFormatter.string(from: date)
        let formattedDate = dateFormatter.date(from: dateString)
        let reverseFormat = dateFormatter.string(from: formattedDate!)
        
      
        
        
        
        print("Date? Test2 \(dateString)")
        self.serviceDate = dateString
        print("Date? Test3 \(self.serviceDate)")
        
        timeSelectionView.isHidden = false
//        self.dateSelected = formattedDate
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        handleCellSelected(cell: cell, cellState: cellState)
       
        
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        configureCell(cell: cell, cellState: cellState)

    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as? DateCell else { return JTACDayCell() }

        configureCell(cell: cell, cellState: cellState)

        return cell

    }
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = jtCalCompareFormatter.date(from: "01-jan-2019")!
        let endDate = jtCalCompareFormatter.date(from: "17-may-2027")!

        let config = ConfigurationParameters.init(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: .autoupdatingCurrent, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
        return config
    }
    
    func configureCell(cell: DateCell, cellState: CellState) {
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = #colorLiteral(red: 0.1722870469, green: 0.1891334951, blue: 0.2275838256, alpha: 1)
//        cell.selectedView.backgroundColor = #colorLiteral(red: 0.1721869707, green: 0.1871494651, blue: 0.2290506661, alpha: 1)
        
//        if cell.isSelected {
//            cell.selectedView.isHidden = false
//        } else {
//            cell.selectedView.isHidden = true
//        }
        cell.dateLabel.text = cellState.text
//
//        handleCellEvents(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
//            cell.dateLabel.font = UIFont(name: PoppinsFont.semiBold.rawValue, size: 12)
        } else {
            cell.dateLabel.textColor = .lightGray
//            cell.dateLabel.font = UIFont(name: PoppinsFont.light.rawValue, size: 12)
        }
    }
    
    func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
//            cell.selectedView.isHidden = false
            cell.dateLabel.textColor = .white
            cell.layer.borderColor = UIColor.white.cgColor
        } else {
//            cell.selectedView.isHidden = true
            cell.dateLabel.textColor = .black
            cell.layer.borderColor = #colorLiteral(red: 0.1721869707, green: 0.1871494651, blue: 0.2290506661, alpha: 1)
        }
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendarView.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = jtCalMonthFormatter.string(from: range.start)
        return header
    }
    
    internal func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
    
}
