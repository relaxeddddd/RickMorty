import UIKit

/// TabBarViewController
final class TabBarViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setTabBatVC()
  }
  
  func setTabBatVC() {
    let episodesVC = UINavigationController(rootViewController: CharacterViewController())
    let favouritesVC = UINavigationController(rootViewController: FavouritesViewController())
    
    episodesVC.tabBarItem = UITabBarItem(
      title: "Episodes",
      image: UIImage(systemName: "house"),
      tag: 1)
    episodesVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
    
    favouritesVC.tabBarItem = UITabBarItem(
      title: "Favourites",
      image: UIImage(systemName: "heart"),
      tag: 2)
    favouritesVC.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
    
    setViewControllers([episodesVC, favouritesVC], animated: true)
  }
}
