Submission for the Rackspace contest. Although I only had about 3 hours to spare, I thought that I would
be able to create a Rube Goldberg-esque style app.  The app was supposed to:

1. Create a Rackspace Cloud Compute instance
2. Place the string "SCALING IN THE OPEN CLOUD WITH RACKSPACE" onto a location in Cloud Files
3. Create a Cloud Database
4. Copy the message from Cloud Files to the Cloud Database
5. Query the Cloud Database for the message
6. Print the message

However I ran into a number of issues that hampered my short window of time:

1. When I went to create my own account (rather than using the company's). I was originally unable to access my
API key. It turns out that maybe that was due to and issue navigating between the 2nd and 1st generation servers.

2. I didn't have a high level of trust that the Rackspace Ruby API at 
https://github.com/rackspace/ruby-cloudservers was still current (given that the last commit
was 1 year ago (with the next commit being from 2 years ago!), and I wanted to use the v2 servers).

3. I tried Fog, and while I've had much success with it in the past against AWS, I had trouble getting
a Compute instance created against Rackspace.  After some searching, it appears that I ran into this issue:

https://github.com/fog/fog/pull/1475

...which might be a combination of Fog and the Rackspace API Service

So that cop out statement above :) led me to pair things down to just copying a file with the intended output to 
Cloud Files and then grabbing the content via HTTP GET and printing it.  I've left some of the other Ruby code in 
for the obfuscation factor.  Enjoy!

Uses ruby-1.9.3, rubygems, and bundler along with the gems defined in Gemfile. 
