//
//  OwnerUpcomingServicesCalendarViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/13/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class OwnerUpcomingServicesCalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

   @IBOutlet weak var calendarView: JTACMonthView!
   @IBOutlet var upcomingServices: UITableView!
        
   
    
        override func viewDidLoad() {
            super.viewDidLoad()

            fetchUsers()
            setUpSubViews()
            calendarView.calendarDataSource = self
            calendarView.calendarDelegate = self
            upcomingServices.delegate = self
            upcomingServices.dataSource = self
            upcomingServices.backgroundColor = UIColor.clear
            calendarView.backgroundColor = .clear
        }
    
    var owner = [Owner]()
    var confirmed = [FirebaseConfirm]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          confirmed.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceTableViewCell else {return UITableViewCell()}
          
          cell.servicePriceView.layer.cornerRadius = 15 
          cell.confirmed = confirmed[indexPath.row]
          cell.backgroundColor = UIColor.clear
          
          return cell
          
       }
        
        //MARK: - Recieve Part Data
        var part: Part!
        var serviceDate = Date()
        
        func setUpSubViews() {
           
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
        }
    
    //MARK: - Fetch User From Database
    func fetchUsers() {
        
        
        
        Database.database().reference().child("owner").child("owner").child("confirmed").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let owner = Owner()
                let confirm = FirebaseConfirm()
                
                //App will crash if Class properties don't exactly match up with the Firebase Dictionary Keys
                confirm.setValuesForKeys(dictionary)
                
                self.confirmed.append(confirm)
                self.owner.append(owner)
                
                DispatchQueue.main.async {
                    self.upcomingServices.reloadData()
                }
            }
            print(snapshot)
        }, withCancel: nil)
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
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }()
        
        
        //MARK: - Recieve the Part then Pass Both the Part Data & The Service Date Data Here In the Segue to Confirm
        
        // MARK: - Navigation

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
            
            if segue.identifier == "userCalendarSegue" {
                if let detailVC = segue.destination as? UserConfirmViewController {
                    detailVC.part = part
                    detailVC.serviceDate = serviceDate
                }
            }
            
        }
   
        
        

    }

    extension OwnerUpcomingServicesCalendarViewController: JTACMonthViewDataSource, JTACMonthViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
        
        func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
            guard let cell = cell as? DateCell else { return }
            handleCellSelected(cell: cell, cellState: cellState)
            let dateString = dateFormatter.string(from: date)
            let formattedDate = dateFormatter.date(from: dateString)
            print("Date? Test2 \(date)")
            self.serviceDate = date
            print("Date? Test3 \(self.serviceDate)")
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
            
            if cellState.dateBelongsTo == .thisMonth {
               cell.isHidden = false
            } else {
               cell.isHidden = true
            }
            
           
            

            configureCell(cell: cell, cellState: cellState)
            

            return cell

        }
        
        func handleCellEvents(cell: DateCell, cellState: CellState) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                      for confirm in self.confirmed {
                          
                          var confirmHolder: String = ""
                          confirmHolder = confirm.confirmDate!
                          let cutConfirm = confirmHolder.dropFirst(8)
                          
                          if cutConfirm == cellState.text {
                            print("MATCH: \(cutConfirm) + \(cellState.text)")
                            cell.dateHasAppointmentView.backgroundColor = .green
                          }
                        
                        if cutConfirm == "0\(cellState.text)" {
                            print("MATCH2: \(cutConfirm) + \(cellState.text)")
                            cell.dateHasAppointmentView.backgroundColor = .green
                        }
                      }
                      
                   
            }
       
            
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
          
            
            cell.dateHasAppointmentView.layer.cornerRadius = 5
            cell.dateLabel.text = cellState.text
            
            
            
            
    //
            handleCellEvents(cell: cell, cellState: cellState)
            handleCellTextColor(cell: cell, cellState: cellState)
            handleCellSelected(cell: cell, cellState: cellState)
        }
        
        func handleCellTextColor(cell: DateCell, cellState: CellState) {
            if cellState.dateBelongsTo == .thisMonth {
                cell.dateLabel.textColor = .black
    //            cell.dateLabel.font = UIFont(name: PoppinsFont.semiBold.rawValue, size: 12)
            } else {
                cell.dateLabel.textColor = .white
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
//            print("Month: \(header.monthTitle.text?.dropFirst(8))") // 2019
            
            
            return header
        }
        
        internal func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
            return MonthSize(defaultSize: 50)
        }
        
        
    }
