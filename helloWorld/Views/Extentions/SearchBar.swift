//
//  SearchBar.swift
//  helloWorld
//
//  Created by Іван Богоносюк on 15.07.2020.
//

import Combine
import SwiftUI

extension View {
    func navigationBarSearch(_ searchText: Binding<String>, onTitleView: Bool = false) -> some View {
        return overlay(SearchBar(text: searchText, onTitleView: onTitleView).frame(width: 0, height: 0))
    }
}

fileprivate struct SearchBar: UIViewControllerRepresentable {
    @Binding var text: String
    var onTitleView: Bool = false
    
    init(text: Binding<String>, onTitleView: Bool = false) {
        self._text = text
        self.onTitleView = onTitleView
    }
    
    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }
    
    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.onTitleView = onTitleView
        controller.searchController = context.coordinator.searchController
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UISearchResultsUpdating {
        @Binding var text: String
        let searchController: UISearchController
        
        private var subscription: AnyCancellable?
        
        init(text: Binding<String>) {
            self._text = text
            self.searchController = UISearchController(searchResultsController: nil)
            
            super.init()
            
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.obscuresBackgroundDuringPresentation = false
            
            self.searchController.searchBar.text = self.text
            self.subscription = self.text.publisher.sink { _ in
                self.searchController.searchBar.text = self.text
            }
        }
        
        deinit {
            self.subscription?.cancel()
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            DispatchQueue.main.async {
                self.text = text
            }
        }
    }
    
    class SearchBarWrapperController: UIViewController {
        var onTitleView: Bool = false

        var searchController: UISearchController? {
            didSet {
                if onTitleView {
                    self.parent?.navigationItem.titleView = searchController?.searchBar
                    searchController?.hidesNavigationBarDuringPresentation = false
                } else {
                    self.parent?.navigationItem.searchController = searchController
                }
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            if onTitleView {
                self.parent?.navigationItem.titleView = searchController?.searchBar
                searchController?.hidesNavigationBarDuringPresentation = false
            } else {
                self.parent?.navigationItem.searchController = searchController
            }
        }
        override func viewDidAppear(_ animated: Bool) {
            if onTitleView {
                self.parent?.navigationItem.titleView = searchController?.searchBar
                searchController?.hidesNavigationBarDuringPresentation = false
            } else {
                self.parent?.navigationItem.searchController = searchController
            }
        }
    }
}
