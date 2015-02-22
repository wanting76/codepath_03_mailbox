//
//  MailboxViewController.swift
//  mailbox
//
//  Created by Wanting Huang on 2/18/15.
//  Copyright (c) 2015 Wan-Ting Huang. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var messageFirst: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var rescheduleOverlay: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var listOverlay: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    var messageFinalPositionX: CGFloat!
    var messagePanStartingPositionX: CGFloat!
    //var messagePanLeftRevealingPositionX: CGFloat!
    
    var laterIconStartingPositionX: CGFloat!
    var laterIconFinalPositionX: CGFloat!
    
    var archiveIconStartingPositionX: CGFloat!
    var archiveIconFinalPositionX: CGFloat!
    
    var contentViewStartingPositionX: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1367)
        dismissButton.alpha = 0
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        contentView.addGestureRecognizer(edgeGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanMessage(sender: UIPanGestureRecognizer) {

        var translation = sender.translationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            
            messagePanStartingPositionX = messageFirst.frame.origin.x
            
            laterIconStartingPositionX = laterIcon.frame.origin.x
            archiveIconStartingPositionX = archiveIcon.frame.origin.x
            //println(archiveIconStartingPositionX)
            
            messageView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1) // gray
            
            
            
            laterIcon.alpha = 0
            archiveIcon.alpha = 0
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed){
            
            
            messageFinalPositionX = messagePanStartingPositionX + translation.x
            messageFirst.frame.origin.x = messageFinalPositionX
            
            
            //Pan to the left
            if (messageFinalPositionX > -60 && messageFinalPositionX <= 0){
                messageView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1) // gray
                
                
                laterIcon.alpha = messageFinalPositionX / -60
                laterIcon.frame.origin.x = laterIconStartingPositionX
            } else if (messageFinalPositionX > -260 && messageFinalPositionX <= -60){
                messageView.backgroundColor = UIColor(red: 252/255, green: 225/255, blue: 94/255, alpha: 1) // yellow
                //println(messageView.backgroundColor)
                laterIconFinalPositionX = laterIconStartingPositionX + translation.x + 60
                laterIcon.frame.origin.x = laterIconFinalPositionX
                laterIcon.image = UIImage(named:"later_icon")
                
            } else if (messageFinalPositionX <= -260){
                messageView.backgroundColor = UIColor(red: 170/255, green: 152/255, blue: 101/255, alpha: 1) // brown
                laterIconFinalPositionX = laterIconStartingPositionX + translation.x + 260 - 200
                laterIcon.frame.origin.x = laterIconFinalPositionX
                laterIcon.image = UIImage(named:"list_icon")
                
            }
            
            
            //Pan to the right
            if (messageFinalPositionX >= 0 && messageFinalPositionX < 60){
                messageView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1) // gray
                archiveIcon.alpha = messageFinalPositionX / 60
                archiveIcon.frame.origin.x = archiveIconStartingPositionX
            } else if (messageFinalPositionX >= 60 && messageFinalPositionX < 260){
                messageView.backgroundColor = UIColor(red: 144/255, green: 247/255, blue: 134/255, alpha: 1) // green
                archiveIconFinalPositionX = archiveIconStartingPositionX + translation.x - 60
                archiveIcon.frame.origin.x = archiveIconFinalPositionX
                archiveIcon.image = UIImage(named:"archive_icon")
                
            } else if (messageFinalPositionX >= 260){
                messageView.backgroundColor = UIColor(red: 244/255, green: 108/255, blue: 108/255, alpha: 1) // red
                archiveIconFinalPositionX = archiveIconStartingPositionX + translation.x - 260 + 200
                archiveIcon.frame.origin.x = archiveIconFinalPositionX
                archiveIcon.image = UIImage(named:"delete_icon")
                
            }
            
        
            
        } else if (sender.state == UIGestureRecognizerState.Ended){
            
            //Pan to the left
            if (messageFinalPositionX > -60 && messageFinalPositionX <= 0){
                
                messageFinalPositionX = messagePanStartingPositionX
                
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: nil, animations: { () -> Void in
                    
                    self.messageFirst.frame.origin.x = self.messageFinalPositionX
                    
                    
                    },completion:{ (finished: Bool) in
                        self.messageFirst.frame.origin.x = 0
                        self.laterIcon.image = UIImage(named:"later_icon")
                        self.laterIcon.frame.origin.x = self.laterIconStartingPositionX
                        self.messageView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1) // gray
                        
                })

            }else if (messageFinalPositionX > -260 && messageFinalPositionX <= -60){
                
                messageFinalPositionX = messagePanStartingPositionX - messageFirst.frame.width
                laterIcon.alpha = 0
                
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: nil, animations: { () -> Void in
                    
                    self.messageFirst.frame.origin.x = self.messageFinalPositionX

                    },completion:{ (finished: Bool) in
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.rescheduleOverlay.alpha = 1
                            self.dismissButton.alpha = 1
                        })
                        
                })
                
            }else if (messageFinalPositionX <= -260){
                
                messageFinalPositionX = messagePanStartingPositionX - messageFirst.frame.width
                laterIcon.alpha = 0
                
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: nil, animations: { () -> Void in
                    
                    self.messageFirst.frame.origin.x = self.messageFinalPositionX
                    
                    },completion:{ (finished: Bool) in
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
                            self.listOverlay.alpha = 1
                            self.dismissButton.alpha = 1
                        })
                        
                })
            }//position logic end
            
            //Pan to the right
            if (messageFinalPositionX >= 0 && messageFinalPositionX < 60){
                
                messageFinalPositionX = messagePanStartingPositionX
                
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: nil, animations: { () -> Void in
                    
                    self.messageFirst.frame.origin.x = self.messageFinalPositionX
                    
                    },completion:{ (finished: Bool) in
                        self.messageFirst.frame.origin.x = 0
                        self.archiveIcon.image = UIImage(named:"archive_icon")
                        self.archiveIcon.frame.origin.x = self.archiveIconStartingPositionX
                        
                })
                
            }else if (messageFinalPositionX >= 60 && messageFinalPositionX < 260){
                
                messageFinalPositionX = messagePanStartingPositionX + messageFirst.frame.width
                archiveIcon.alpha = 0
                
                
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: nil, animations: { () -> Void in
                    
                    self.messageFirst.frame.origin.x = self.messageFinalPositionX
                    
                    },completion:{ (finished: Bool) in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.feedImage.frame.origin.y = self.feedImage.frame.origin.y - 86
                            
                            }) { (finished:Bool) -> Void in
                                
                                //reset
                                self.messageFirst.frame.origin.x = 0
                                self.archiveIcon.image = UIImage(named:"archive_icon")
                                self.archiveIcon.frame.origin.x = self.archiveIconStartingPositionX
                                
                                UIView.animateWithDuration(0.3, animations: { () -> Void in
                                    self.feedImage.frame.origin.y = self.feedImage.frame.origin.y + 86
                                    
                                    
                                })
                        }
                        
                })
                
            }else if (messageFinalPositionX >= 260){
                
                messageFinalPositionX = messagePanStartingPositionX + messageFirst.frame.width
                archiveIcon.alpha = 0
                
                UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 30, options: nil, animations: { () -> Void in
                    
                    self.messageFirst.frame.origin.x = self.messageFinalPositionX
                    
                    },completion:{ (finished: Bool) in
                        
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.feedImage.frame.origin.y = self.feedImage.frame.origin.y - 86
                            
                            }) { (finished:Bool) -> Void in
                                
                                //reset
                                self.messageFirst.frame.origin.x = 0
                                self.archiveIcon.image = UIImage(named:"archive_icon")
                                self.archiveIcon.frame.origin.x = self.archiveIconStartingPositionX
                                
                                UIView.animateWithDuration(0.3, animations: { () -> Void in
                                    self.feedImage.frame.origin.y = self.feedImage.frame.origin.y + 86
                                    
                                })
                        }

                        
                })
            }//position logic end
            
        }//pan logic end

    }//didPanMessage end
    
    
    @IBAction func didPressDismissButton(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.rescheduleOverlay.alpha = 0
                self.listOverlay.alpha = 0
                self.dismissButton.alpha = 0
            }) { (finished:Bool) -> Void in
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.feedImage.frame.origin.y = self.feedImage.frame.origin.y - 86

                }) { (finished:Bool) -> Void in
                
                //reset
                self.messageFirst.frame.origin.x = 0
                self.laterIcon.image = UIImage(named:"later_icon")
                self.laterIcon.frame.origin.x = self.laterIconStartingPositionX
                    
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.feedImage.frame.origin.y = self.feedImage.frame.origin.y + 86
                    
                    
                })
                
                }
                
        }
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){

            contentViewStartingPositionX = contentView.frame.origin.x
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            contentView.frame.origin.x = contentViewStartingPositionX + translation.x
            

        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if ( velocity.x > 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.contentView.frame.origin.x = 300
                    
                    }, completion: { (finished:Bool) -> Void in
                        
                        var panGesture = UIPanGestureRecognizer(target: self, action: "pan:")
                        self.contentView.addGestureRecognizer(panGesture)
                        
                        
                })
                
                
                
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                })
            }

        }
    }
    
    
    func pan(sender: UIPanGestureRecognizer) {
        
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            
            contentViewStartingPositionX = contentView.frame.origin.x
            
            
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            contentView.frame.origin.x = contentViewStartingPositionX + translation.x
            
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            
            if ( velocity.x > 0) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.contentView.frame.origin.x = 300
                    
                    }, completion: { (finished:Bool) -> Void in
                        
                        
                })
                
            } else {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.contentView.frame.origin.x = 0
                })
            }
            
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
