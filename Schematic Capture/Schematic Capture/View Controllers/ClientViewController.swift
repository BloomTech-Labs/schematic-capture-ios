//
//  ClientViewController.swift
//  Schematic Capture
//
//  Created by Kerby Jean on 6/20/20.
//  Copyright © 2020 GIPGIP Studio. All rights reserved.
//

import UIKit
import CoreData

class ClientViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    var collectionView: UICollectionView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Client> = {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
//        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
               let width = (view.frame.width / 3) - 10
               layout.itemSize = CGSize(width: width, height: width)
               layout.sectionInset = UIEdgeInsets(top: 25, left: 5, bottom: 50, right: 5)
               layout.minimumLineSpacing = 20
               layout.minimumInteritemSpacing = 10
               
               collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
               
               /// Setup tableview datasource/delegate
               collectionView.delegate = self
               collectionView.dataSource = self
               
               collectionView.register(ClientCell.self, forCellWithReuseIdentifier: ClientCell.id)
               collectionView.backgroundColor = .white
               
               view.addSubview(collectionView)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClientCell.id, for: indexPath) as! ClientCell
        let client = fetchedResultsController.object(at: indexPath)
        cell.client = client
        return cell
    }
}
