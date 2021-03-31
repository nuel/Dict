import UIKit

class RootViewController: UITableViewController {
    
    private var words = [Word]()
    private var filteredWords = [Word]()
    private let searchController = UISearchController(searchResultsController: nil)
    private let directionSegmentedControl = DirectionSegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table
        tableView.register(DictTableViewCell.self, forCellReuseIdentifier: "word")
        tableView.dataSource = self
        tableView.delegate = self
        
        // Styling
        navigationItem.title = "Dict"
        view.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.darkGray
        tableView.rowHeight = 90
        
        // Populate table
        words = Dict.fetchData() ?? []
        
        // Set up search
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Set up segmented control
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 50))
        directionSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(directionSegmentedControl)
        header.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[control]-20-|", options: [], metrics: nil, views: ["control": directionSegmentedControl]))
        header.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[control]|", options: [], metrics: nil, views: ["control": directionSegmentedControl]))
        
        tableView.tableHeaderView = header
        directionSegmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: .valueChanged)
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(currentWordSet()[indexPath.row])")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWordSet().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "word", for: indexPath) as! DictTableViewCell
        
        // Select word
        let word = currentWordSet()[indexPath.row]
        
        // Set original cell
        cell.originalLabel.text = currentDirection() == "rusa" ? word.rusa : word.english
        cell.originalLabel.font = UIFont(name: currentDirection() == "rusa" ? "Algemeen-Rusa" : "Algemeen-Regular", size: UIFont.labelFontSize)
        
        // Set translation cell
        cell.translationLabel.text = currentDirection() == "rusa" ? word.english : word.rusa
        cell.translationLabel.font = UIFont(name: currentDirection() == "rusa" ? "Algemeen-Regular" : "Algemeen-Rusa", size: UIFont.labelFontSize)
        
        return cell
    }
    
    // MARK: Search
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        // Check both Rusa and English definitions
        filteredWords = words.filter({( word : Word) -> Bool in
            return (
                word.rusa.lowercased().contains(searchText.lowercased()) ||
                word.english.lowercased().contains(searchText.lowercased())
            )
        })
        
        // Reload
        tableView.reloadData()
    }
    
    // Which words are we using?
    func currentWordSet() -> [Word] {
        let currentWordSet = isFiltering() ? filteredWords : words
        if currentDirection() == "english" {
            return currentWordSet.sorted{ $0.english < $1.english }
        }
        return currentWordSet.sorted{ $0.rusa < $1.rusa }
    }
    
    // MARK: Direction
    func currentDirection() -> String {
        return directionSegmentedControl.selectedSegmentIndex == 0 ? "rusa" : "english"
    }
    @objc func segmentedControlValueChanged() {
        tableView.reloadData()
    }
}

extension RootViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Do the filtery thing
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
