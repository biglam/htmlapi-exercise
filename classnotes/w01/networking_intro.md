### title

### topic

### objectives

* Students should understand the basic networking infrastructure of the internet
* Students should understand the request/response model
* Students should understand how HTTP works, including verbs
* Students should understand how browsers interpret responses
* Students should understand how web servers work

### standards

### materials

### summary

A very high level introduction to the fundementals of internetworking.
An exposure to the terminology of the area, but not an in-depth explanation of their operation.

### assessment

### follow-up

====================


Web pages are files that are sent to browser applications. Web browsers need to get those files from somewhere - that is web servers located somewhere on the internet. Web servers are just programs running on computers somewhere that respond to web requests.


## What is a network?

It is a connection between computers, either physically or wirelessly. "Internetworking" is a connection between networks.

If you have three computers connected in a network, there will be one computer, called a switch or a hub, through which the other computers communicate. Imagine there are two networks and you'd like to communicate between them. This requires a router between them in order to communicate. 

![Router communication](https://lh3.googleusercontent.com/EQk3B2P1CHaoqNjK13vObWFtXzJI2dyL9GSDEAmdqLsgdiEod-G8B4OvUVmELFKtjyjII5A5gk6pIvzZo3mmgBgCSKDoN2hR1oS31KB27OtXuokXvIoOJDdOVA)


## What is The Internet?

> "The Internet is a global system of interconnected computer networks that use the standard Internet protocol suite (TCP/IP) to link several billion devices worldwide."
> Wikipedia

The internet is frequently represented as a "cloud", or a "web" constructed from the interconnections (the name of the "World Wide Web" is a corollary of this - but is from the interconnections of content over the network), and the architecture of the protocols that allows traffic to take any route around the interconnections that gets to the destination.

![The Internet](http://www.holistichosting.com.au/glossary/theInternet.gif)


We type in a web address into a browser... what's going on under the hood to get us the web page displayed? How much of this do we need to understand and how thoroughly, to be able to make useful software that works like this? (how much of how a car works do you need to understand to be able to drive it to work?)


## IP Address

Every connection to the internet gets a numbered 'address' (like every phone has a phone number on the telephone network). This address allows internet-connected devices to communicate with each other, and has a particular format of four octets (8-bit numbers) separated with full-stops: 

`192.168.0.1`

This gives us about 4-billion unique addresses (in IPv4). With the ever-increasing number of new devices being connected to the Internet, the need arose for more addresses than IPv4 is able to accommodate. IPv6 uses a 128-bit address, allowing 2^128, or approximately 3.4x10^38 addresses, or more than 7.9x10^28 times as many as IPv4, which uses 32-bit addresses (let's just summarise by saying that's a lot of addresses!).

IPv6 addresses are represented as eight groups of four hexadecimal digits separated by colons, for example:   

`2001:0db8:85a3:0042:1000:8a2e:0370:7334`

Harder to read to someone than IPv4 addresses... but methods of abbreviation of this full notation exist.

IPv6 is intended to replace IPv4, which still carries the vast majority of Internet traffic as of 2013. As of September 2013, the percentage of users reaching Google services over IPv6 surpassed 2% for the first time.

The two protocols are not designed to be interoperable, complicating the transition to IPv6.


## DNS

Rather than remembering all the IP addresses for all the websites we visit, we use a database of names that map to IP addresses. This Domain Name Service means you can type in words to get to IP addresses of computers - which is easier for people to understand, remember, and type.


## URL/URI

A URI (Uniform resource identifier) is a is a string of characters used to identify a name or a web resource.

A URL (Uniform resource location) is a string that constitutes a reference to a resource


### Elements of a URL

```
    http://www.example.org/hello/world/foo.html?foo=bar&baz=bat#footer
    \___/  \_____________/ \__________________/ \_____________/ \____/
  protocol  host/domain name        path         querystring     hash/fragment
```

Element | About
------|--------
protocol | the most popular application protocol used on the world wide web is HTTP. Other familiar types of application protocols include FTP, SSH, HTTPS
host/domain name | the host or domain name is looked up in DNS to find the IP address of the host - the server that's providing the resource
path | web servers can organise resources into what is effectively files in directories; the path indicates to the server which file from which directory the client wants
querystring | the client can pass parameters to the server through the querystring (in a GET request method); the server can then use these to customise the response - such as values to filter a search result
hash/fragment | the URI fragment is generally used by the client to identify some portion of the content in the response; interestingly, a broken hash will not break the whole link - it isn't the case for the previous elements


## The OSI/IP Stack

The OSI, or "Open System Interconnection", model defines a networking framework to implement protocols in seven layers. The OSI Reference Model is really just a guideline. Actual protocol stacks often combine one or more of the OSI layers into a single layer.

![OSI Model compared to TCP/IP](https://s-media-cache-ak0.pinimg.com/originals/a5/74/d3/a574d3bd55e8218a7df9f13bf20997a8.jpg)

The point of this modelling is to represent how the traffic on networks gets turned from text files into electrical signals that are sent down wires or through the air-waves, and back again to be displayed on screen.


## Web requests

A web client makes a request to a server, and that server makes a response. But what is the server doing in the background?

![Request/Response Cycle](http://1.bp.blogspot.com/-eqm6AQyKOvA/Tr1599o-GZI/AAAAAAAABOo/W5m9t3CEek0/s1600/2.png)

Essentially... the client doesn't care what the server does, as long as it gets the content it asked for.

  - Could be serving static files
  - Could be pulling something out of a database
  - Could be calculating something and making it up as you go along
    - Like those ruby snippets you did that return strings. You could return a string that's an HTML document...
  - Might not even be talking to a web server at all! (the response might be cached somewhere along the line)

The language of the requests is formalised in the protocols they're made in. Mostly this will be HTTP (and HTTPS).


## Where did all this come from? 

"Requests for Comments" are the documents put out by the IETF (the Internet Engineering Task Force) to specify the technical operations of the Internet.

You can [browse through them](https://www.ietf.org/rfc.html) (if you have trouble sleeping). It's worth noting some of the language conventions used, particularly the capitalised occurances of "must", "should", "shall", etc., which [define](https://www.ietf.org/rfc/rfc2119.txt) how strict different parts of the requirements are.

RFCs aren't "law" - many companies have historically trampled all over them from time to time, but they are well informed opinions of how things *SHOULD* work.

* [Original RFC for HTTP](https://www.ietf.org/rfc/rfc1945.txt)
* [Internet Users' Glossary](https://www.ietf.org/rfc/rfc1983.txt)
* [The Hitchhikers Guide to the Internet](https://www.ietf.org/rfc/rfc1118.txt)
* [April Fools](https://tools.ietf.org/rfc/rfc748.txt)
