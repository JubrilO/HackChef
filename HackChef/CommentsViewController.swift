//
//  CommentsViewController.swift
//  HackChef
//
//  Created by Jubril on 8/26/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    
    var tableView = UITableView()
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CommentCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.CommentCell)
        tableView.register(CommentReplyCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.ReplyCell)
        tableView.frame = view.frame
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        if !comment.reply {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.CommentCell) as! CommentCell
            cell.commentLabel.text = comment.text
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ReplyCell) as! CommentReplyCell
            cell.
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
}
