// Surf.Alarm

import UIKit

extension UISwipeActionsConfiguration {
  static func deleteConfiguration(_ handler: @escaping UIContextualAction.Handler) -> UISwipeActionsConfiguration {
    let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: handler)
    deleteAction.backgroundColor = UIColor.red
    deleteAction.image = R.image.trash()
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }

  static func viewMapConfiguration(_ handler: @escaping UIContextualAction.Handler) -> UISwipeActionsConfiguration {
    let mapAction = UIContextualAction(style: .normal, title: "View Map", handler: handler)
    mapAction.backgroundColor = R.color.saAccent() ?? UIColor.blue
    mapAction.image = R.image.location()
    let configuration = UISwipeActionsConfiguration(actions: [mapAction])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }
}
