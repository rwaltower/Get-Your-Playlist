# Get-Your-Playlist
## Project Description
- I’m a very busy 20 data entry professional. I need an app that will generate specific music playlists for me.
- I currently have Spotify and Apple Music but it doesn’t automatically personalize my playlists and I get too many songs that I don’t want to listen to. 
- I want to be able to tell the app how I’m feeling and what I’m doing and it create a playlist for me based on the information I give it. 
- I want playlists built to fit into the time I have to listen to it.
- I want it to be quick and easy to use because I don’t have a lot of free time and I’m not very good with technology.
- I want to be able to enter my mood, my activities, the length of time, my favorite artists, genres, and time period. 
- I want it to sync with calendar events like birthdays, meetings, and holidays.
- I want to the option to control the tempo of the playlist. 

We're using Apple MusicKit for our app. Take a look at this example <https://developer.apple.com/sample-code/wwdc/2017/Interacting-with-Apple-Music-Content.zip>


## Project Progress
- [ ] Create database
- [ ] Design UI
- [ ] Coding
- [ ] Testing

## Task Assignments
  - Database Design: Chang, Daniel
  - UI Design: Avinash, Quantonio
  - Implementation: Radasia, Roy
  - Testing: Daniel, Avinash
  
## How To Get Started
1. Clone the GitHub repository
	- Options:
		- Download repository in zip and extract files on your local machine
		- Use git command
		```
		git clone https://github.com/rwaltower/Get-Your-Playlist.git
		```
		- Use 'Open In Xcode" option

2. Create a new branch for your work
	```
	git checkout <yourbranchname>
	```

3. Do your work	
	- Be sure to commit to your local branch with brief descriptions when you finish sections.

4. When you get to a good stopping point that you're ready for everyone else to look at it and test, commit to your local branch then push it to our remote repository.
	```
	git commit -m "Your brief message here"
	git push origin <yourbranchname>
	```

5. Create a pull request in GitHub for your branch so everyone else can checkout your branch and test it

6. Once your branch has been tested and approved, we'll merge it into the master branch.

Since we're all working at the same time, we don't want to write over each other's code.

**Never commit/push to master branch**

## Extra info
### How to make apple music api requests in Terminal
```
curl -v -H 'Authorization: Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjM2NjdVMkJXTlUifQ.eyJpc3MiOiJENUg5NjRFNVQ2IiwiaWF0IjoxNTQzMDc2Mzk3LCJleHAiOjE1NDU2NjgzOTd9.qN6wYdCpdCqyviHPvV_nUsXC6xt4n8NfzFvOtlMA9QU2l7WjvgfgBs4JFQj2uxtAi8RJL1qviIF7dc5L1MazbA' "https://api.music.apple.com/v1/catalog/us/QUERY-GOES-HERE"
```
Replace QUERY-GOES-HERE with whatevere you're trying to fetch  based on this documentaion: <https://developer.apple.com/documentation/applemusicapi>
