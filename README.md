# LifeSpeak

Topic 

1) Master screen will list Youtube videos
2) Detail screen will play the selected video

Functional Scope 

1) Call to data feed to populate Master screen
2) Searchable option for user to pick any video in the Master screen
3) Upon selection of any video, Detail screen will play the video
4) Option to navigate to other videos from Detail screen
5) Back button from Detail screen will navigate to Master screen


What features must exist for the App to make any sense?

1) App requires Youtube  data feed.


Screen Controllers & Flow -
1) App features Table View Controller in MasterVC
2) Data feed will populate Table View Controller
3) Search bar in Master VC to provide additional UI capability
4) Click of any row in MasterVC will navigate to DetailVC screen
5) Detail VC will play the video selected 
6) Next and Prev in DetailVC for easy navigation across videos.

Background Task -
1) Alamofire to request Youtube data feed
2) Background thread to load thumbnail image


Images -
1) Star image - Rating purposes - Downloaded from Google Image - Source mentioned - Wikimedia commons


Data Model

Required fields-

    title
    videoURL
    imageURL
    rating
    
Programming Pattern -

1) Even based programming. Use of NSNotification. Model will fire event and subscriber will act upon it
2) Delegate pattern - View Controllers talk to each through Delegate protocol
3) Closure - Call back method passed as argument to the function
4) Singleton pattern - Singleton based design to access video content and network layer
5) MVC - Assignment follows MVC architecture. 

Packages included -
1) Alamofire - This is for asynchronouse retrieval of data
2) SwiftyXMLParser - This is for parsing XML from the data feed
3) YouTubePlayer_Swift - This is for playing video

What additional features can be included in the app?

1) Caching of videos. If the user clicks same video, we don't have to necessarily stream it. This is out of scope for now.




