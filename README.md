# Skills Test

This app uses the Imgur API to search for images in their gallerry in order to display them in a simple grid.

To do this we have a simple `ImgurAPI` class that has all the information needed to use the API and uses the `NetworkManager` class which is responsible to do the GET request. For the Search bar we have a subclass of `UISearchController` named `PhotosSearchController`. To display the photos we are using a UICollectionView with a subclass of `UICollectionViewFlowLayout` named `PhotosCollectionViewLayout` which is in charge of the cells size and we are also using two different `UICollectionViewCells`, one for the photos and one for the activity indicator.

The main file for this app is the `PhotosViewControlle`r which is in charge of comunicating with the different files of the project. We get a response back from the `PhotosSearchController` through a protocol every time there's a new search. After that we ask the `ImgurAPI` to load the photos given the new search query. We get the photos asynchronously, we filter them so we end with an array of  `ImgurImage`s which is going to be the data source of the collection view, and after that we reload the collection view. Being a small app, here is the place that we manage the collection view data source. When we create each cell we see if we already have the image in our `NSCache`, if not we load the image and then save it to the cache. When we get to the bottom of the collection view we load the next page of data from the API.

My goal here was to separate the different functionality to different classes and so the app is easy to read, to maintain and also scalable in case of future changes.
