//
//  ComponentDetailsViewController.swift
//  Schematic Capture
//
//  Created by Ufuk Türközü on 21.05.20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit

class ComponentDetailsViewController: UIViewController {
    
    var component: ComponentRepresentation? {
        didSet {
            headerView.setup(viewTypes: .componentDetails, value: [
                (component?.componentDescription ?? ""), "Details", ""
            ])
        }
    }
    
    // Labels
    var descriptionLabel = UILabel()
    var descriptionDetailLabel = UILabel()
    
    var manufacturerLabel = UILabel()
    var manufacturerDetailLabel = UILabel()
    
    var partNumberLabel = UILabel()
    var partNumberDetailLabel = UILabel()
    
    var rlCategoryLabel = UILabel()
    var rlCategoryDetailLabel = UILabel()
    
    var rlNumberLabel = UILabel()
    var rlNumberDetailLabel = UILabel()
    
    var stockCodeLabel = UILabel()
    var stockCodeDetailLabel = UILabel()
    
    var electricalAdsressLabel = UILabel()
    var electricalAdsressDetailLabel = UILabel()
    
    var referenceTagLabel = UILabel()
    var referenceTagDetailLabel = UILabel()
    
    var settingsLabel = UILabel()
    var settingsDetailLabel = UILabel()
    
    var resourcesLabel = UILabel()
    var resourcesDetailLabel = UILabel()
    
    var cutsheetLabel = UILabel()
    var cutsheetDetailLabel = UILabel()
    
    var storePartNumberLabel = UILabel()
    var storePartNumberDetailLabel = UILabel()
    
    var notesLabel = UILabel()
    var notesDetailLabel = UILabel()
    
    var headerView = HeaderView()
    var scrollView = UIScrollView()
    
    lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.medium
        view.hidesWhenStopped = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        indicator.layer.position.y = view.layer.position.y
        indicator.layer.position.x = view.layer.position.x
        indicator.startAnimating()
        view.addSubview(indicator)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        view.addSubview(headerView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.frame = CGRect(x: 250, y: 0, width: view.frame.width, height: view.frame.width - 250)
        view.addSubview(scrollView)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Description"
        descriptionDetailLabel.text = component?.componentDescription
        descriptionDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionDetailLabel.textColor = .systemGray2
        
        manufacturerLabel.translatesAutoresizingMaskIntoConstraints = false
        manufacturerDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        manufacturerLabel.text = "Manufacturer"
        manufacturerDetailLabel.text = component?.manufacturer
        manufacturerDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        manufacturerDetailLabel.textColor = .systemGray2
        
        partNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        partNumberDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        partNumberLabel.text = "Part #"
        partNumberDetailLabel.text = component?.partNumber
        partNumberDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        partNumberDetailLabel.textColor = .systemGray2
        
        rlCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        rlCategoryDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        rlCategoryLabel.text = "RL Category:"
        rlCategoryDetailLabel.text = component?.rlCategory
        rlCategoryDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        rlCategoryDetailLabel.textColor = .systemGray2
        
        rlNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        rlNumberDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        rlNumberLabel.text = "RL Number:"
        rlNumberDetailLabel.text = component?.rlNumber
        rlNumberDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        rlNumberDetailLabel.textColor = .systemGray2
        
        stockCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        stockCodeDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        stockCodeLabel.text = "Stock Code:"
        stockCodeDetailLabel.text = component?.stockCode
        stockCodeDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        stockCodeDetailLabel.textColor = .systemGray2
        
        electricalAdsressLabel.translatesAutoresizingMaskIntoConstraints = false
        electricalAdsressDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        electricalAdsressLabel.text = "Electrical Adsress:"
        electricalAdsressDetailLabel.text = component?.electricalAddress
        electricalAdsressDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        electricalAdsressDetailLabel.textColor = .systemGray2
        
        referenceTagLabel.translatesAutoresizingMaskIntoConstraints = false
        referenceTagDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        referenceTagLabel.text = "Reference Tag:"
        referenceTagDetailLabel.text = component?.referenceTag
        referenceTagDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        referenceTagDetailLabel.textColor = .systemGray2
        
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.text = "Settings:"
        settingsDetailLabel.text = component?.settings
        settingsDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        settingsDetailLabel.textColor = .systemGray2
        
        resourcesLabel.translatesAutoresizingMaskIntoConstraints = false
        resourcesDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        resourcesLabel.text = "Resources:"
        resourcesDetailLabel.text = component?.resources
        resourcesDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        resourcesDetailLabel.textColor = .systemGray2
        
        cutsheetLabel.translatesAutoresizingMaskIntoConstraints = false
        cutsheetDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        cutsheetLabel.text = "Cutsheet:"
        cutsheetDetailLabel.text = component?.cutSheet
        cutsheetDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        cutsheetDetailLabel.textColor = .systemGray2
        
        storePartNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        storePartNumberDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        storePartNumberLabel.text = "Store's Part #:"
        storePartNumberDetailLabel.text = component?.storePartNumber
        storePartNumberDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        storePartNumberDetailLabel.textColor = .systemGray2
        
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        notesDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        notesLabel.text = "Notes:"
        notesDetailLabel.text = component?.custom
        notesDetailLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        notesDetailLabel.textColor = .systemGray2
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(descriptionDetailLabel)
        stackView.setCustomSpacing(16, after: partNumberDetailLabel)
        
        stackView.addArrangedSubview(manufacturerLabel)
        stackView.addArrangedSubview(manufacturerDetailLabel)
        stackView.setCustomSpacing(16, after: manufacturerDetailLabel)
        
        stackView.addArrangedSubview(partNumberLabel)
        stackView.addArrangedSubview(partNumberDetailLabel)
        stackView.setCustomSpacing(16, after: partNumberDetailLabel)
        
        stackView.addArrangedSubview(rlCategoryLabel)
        stackView.addArrangedSubview(rlCategoryDetailLabel)
        stackView.setCustomSpacing(16, after: rlCategoryDetailLabel)
        
        stackView.addArrangedSubview(rlNumberLabel)
        stackView.addArrangedSubview(rlNumberDetailLabel)
        stackView.setCustomSpacing(16, after: rlNumberDetailLabel)
        
        stackView.addArrangedSubview(stockCodeLabel)
        stackView.addArrangedSubview(stockCodeDetailLabel)
        stackView.setCustomSpacing(16, after: stockCodeDetailLabel)
        
        stackView.addArrangedSubview(electricalAdsressLabel)
        stackView.addArrangedSubview(electricalAdsressDetailLabel)
        stackView.setCustomSpacing(16, after: electricalAdsressDetailLabel)
        
        stackView.addArrangedSubview(referenceTagLabel)
        stackView.addArrangedSubview(referenceTagDetailLabel)
        stackView.setCustomSpacing(16, after: referenceTagDetailLabel)
        
        stackView.addArrangedSubview(settingsLabel)
        stackView.addArrangedSubview(settingsDetailLabel)
        stackView.setCustomSpacing(16, after: settingsDetailLabel)
        
        stackView.addArrangedSubview(resourcesLabel)
        stackView.addArrangedSubview(resourcesDetailLabel)
        stackView.setCustomSpacing(16, after: resourcesDetailLabel)
        
        stackView.addArrangedSubview(cutsheetLabel)
        stackView.addArrangedSubview(cutsheetDetailLabel)
        stackView.setCustomSpacing(16, after: cutsheetDetailLabel)
        
        stackView.addArrangedSubview(storePartNumberLabel)
        stackView.addArrangedSubview(storePartNumberDetailLabel)
        stackView.setCustomSpacing(16, after: storePartNumberDetailLabel)
        
        stackView.addArrangedSubview(notesLabel)
        stackView.addArrangedSubview(notesDetailLabel)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 250),
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8.0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        indicator.stopAnimating()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
