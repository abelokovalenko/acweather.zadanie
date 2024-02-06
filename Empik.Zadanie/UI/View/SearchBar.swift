//
//  SearchBar.swift
//  Empik.Zadanie
//
//  Created by Andrey Belokovalenko on 06/02/2024.
//

import UIKit

class CitySearchBar: UISearchBar {

    private weak var customDelegate: UISearchBarDelegate?
    
    private var suggestions = [City]()
    private var network: NetworkProtocol!
    
    override var delegate: UISearchBarDelegate? {
        get {
            customDelegate
        }
        set {
            customDelegate = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        super.delegate = self
    }
    
    private func search() {
        
    }
}

extension CitySearchBar: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool  {
        customDelegate?.searchBarShouldBeginEditing?(searchBar) ?? true
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        customDelegate?.searchBarTextDidBeginEditing?(searchBar)
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        customDelegate?.searchBarShouldEndEditing?(searchBar) ?? true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
        customDelegate?.searchBarTextDidEndEditing?(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        customDelegate?.searchBar?(searchBar, textDidChange: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        customDelegate?.searchBar?(searchBar, shouldChangeTextIn: range, replacementText: text) ?? true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        customDelegate?.searchBarSearchButtonClicked?(searchBar)
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        customDelegate?.searchBarBookmarkButtonClicked?(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        customDelegate?.searchBarCancelButtonClicked?(searchBar)
    }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        customDelegate?.searchBarResultsListButtonClicked?(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        customDelegate?.searchBar?(searchBar, selectedScopeButtonIndexDidChange: selectedScope)
    }
}
