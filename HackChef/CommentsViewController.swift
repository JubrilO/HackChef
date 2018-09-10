//
//  CommentsViewController.swift
//  HackChef
//
//  Created by Jubril on 8/26/18.
//  Copyright © 2018 bitkoin. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.CommentCell)
            tableView.register(UINib(nibName: "CommentReplyCell", bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.ReplyCell)
        }
    }
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(11.0, 0.0, 0.0, 0.0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
    }
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        if !comment.reply {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.CommentCell) as! CommentCell
            let text = NSMutableAttributedString(string: comment.text)
           let indent =  NSMutableParagraphStyle()
            
            
            indent.firstLineHeadIndent = comment.author.widthOfString(usingFont: cell.userButton.font) + 4
            text.addAttribute(NSAttributedStringKey.paragraphStyle, value:indent, range:NSMakeRange(0, text.length))
            text.addAttribute(NSAttributedStringKey.font, value: cell.commentLabel.font, range: NSMakeRange(0, text.length))
            cell.commentLabel.attributedText = text
            cell.userButton.text = comment.author
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ReplyCell) as! CommentReplyCell
            let text = NSMutableAttributedString(string: comment.text)
            let indent =  NSMutableParagraphStyle()
            
            
            indent.firstLineHeadIndent = comment.author.widthOfString(usingFont: cell.usernameButton.titleLabel!.font) + 4
            text.addAttribute(NSAttributedStringKey.paragraphStyle, value:indent, range:NSMakeRange(0, text.length))
            text.addAttribute(NSAttributedStringKey.font, value: cell.commentLabel.font, range: NSMakeRange(0, text.length))
            cell.commentLabel.attributedText = text
            cell.usernameButton.setTitle(comment.author, for: .normal)
            
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
}
