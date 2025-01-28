//
//  PdfViewController.swift
//  TakeItEasy
//
//  Created by admin on 1/24/25.
//

import UIKit
import PDFKit

class PDFViewController: ViewController {

    @IBOutlet weak var documentWrapper: UIView!

    var selectedBook: BookInfo?
    var documentView: PDFView?

    override func viewDidLoad() {
        super.viewDidLoad()

        documentView = PDFView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false

        documentWrapper.addSubview(documentView!)
        let viewsDict = ["view": documentView]
        documentWrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", metrics: nil, views: viewsDict as [String : Any]))
        documentWrapper.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", metrics: nil, views: viewsDict as [String : Any]))
        documentView?.autoScales = true

        if selectedBook?.document != nil {
            self.documentView?.document = selectedBook?.document
            return
        }

        if selectedBook?.url != nil {
            let spinner = SpinnerViewController()
            spinner.view.frame = view.frame
            self.view.addSubview(spinner.view)

            DispatchQueue.global().async {
                let document = PDFDocument(url: self.selectedBook!.url!)
                self.selectedBook?.document = document
                DispatchQueue.main.async {
                    spinner.view.removeFromSuperview()
                    self.documentView?.document = document
                }
            }
        }
    }

}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
