//
//  Tabbar.swift
//  Katana
//
//  Created by Luca Querella on 15/08/16.
//  Copyright © 2016 Bending Spoons. All rights reserved.
//

import Katana

struct TabbarProps : Equatable,Frameable,Keyable {
  var frame = CGRect.zero
  var key: String?
  
  static func ==(lhs: TabbarProps, rhs: TabbarProps) -> Bool {
    return lhs.frame == rhs.frame
  }
  
}

struct TabbarState : Equatable {
  
  var section : Int
  
  static func ==(lhs: TabbarState, rhs: TabbarState) -> Bool {
    return false
  }
  
}

struct Tabbar : NodeDescription, PlasticNodeDescription {
  
  var props : TabbarProps
  var children: [AnyNodeDescription] = []
  
  static var initialState = TabbarState(section: 0)
  static var viewType = UIView.self
  
  init(props: TabbarProps) {
    self.props = props
  }
  
  static func render(props: TabbarProps,
                     state: TabbarState,
                     children: [AnyNodeDescription],
                     update: (TabbarState)->()) -> [AnyNodeDescription] {
    
    
    struct Section {
      var color: UIColor
      var node: AnyNodeDescription
    }
    
    let sections = [
      Section(
        color: .red,
        node: Album(props: AlbumProps()
          .frame(props.frame.size))
      ),
      
      Section(
        color: .orange,
        node: View(props: ViewProps()
          .frame(props.frame.size)
          .color(.orange))
      ),
      
      Section(
        color: .green,
        node: View(props: ViewProps()
          .frame(props.frame.size)
          .color(.green))
      ),
      
      Section(
        color: .white,
        node: View(props: ViewProps()
          .frame(props.frame.size)
          .color(.white))
      ),
      
      Section(
        color: .purple,
        node: View(props: ViewProps()
          .frame(props.frame.size)
          .color(.purple))
      )
    ]
    
    return [
      View(props: ViewProps().key("viewContainer").color(.blue)),
      View(props: ViewProps().key("tabbarContainer").color(.black), children: sections.enumerated().map { (index,section) in
        
        return View(props: ViewProps().color(.black).key("tabbarButton-\(index)"), children: [
          View(props: ViewProps().key("tabbarButtonImage-\(index)").color(section.color))
          ])
        })
    ]
  }
  
  static func layout(views: ViewsContainer, props: TabbarProps, state: TabbarState) -> Void {
    let root = views.rootView
    let viewContainer = views["viewContainer"]!
    let tabbarContainer = views["tabbarContainer"]!
    let buttons = views.orderedViews(withPrefix: "tabbarButton-", sortedBy: <)
    
    tabbarContainer.asFooter(root)
    tabbarContainer.height = .scalable(80)
    
    viewContainer.asHeader(root)
    viewContainer.bottom = tabbarContainer.top
    
    
    // buttons
    buttons.fill(left: tabbarContainer.left, right: tabbarContainer.right)
    
    for (index, btn) in buttons.enumerated() {
      btn.height = tabbarContainer.height
      btn.bottom = tabbarContainer.bottom
      
      // this is very ugly but in a real case scenario probably btn will be some self contained
      // view
      let image = views["tabbarButtonImage-\(index)"]!
      image.fill(btn, insets: .scalable(10, 10, 10 , 10))
    }
  }
}