//
//  PdfViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/24/25.
//

import UIKit
import PDFKit

class PdfViewController: ViewController {

    @IBOutlet weak var pdfView: UIView!
    
    var selectedBook : StoredBook? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("book in pdf viewer", selectedBook?.name)
        // Do any additional setup after loading the view.
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
