# Assignment: DNS Round Robin Test

<br />

 - We can have multiple containers on a created network respond to the same DNS address.
 - Create a new virtual network (default bridge).
 - Create two containers of the **elasticsearch:2** image.
 - Research and use **-network-alias search** when creating them to give them an additional DNS name to respond to.
 - Run **alpine nslookup search** with **--network** to see the two containers list for the same DNS name.
 - Run **centos curl -s search:9200** with **--network** until you see both 'name' fields show.

<br />

# Solution: DNS Round Robin Test

<br />

    Create a private network for these containers:

        - docker network create wrcg-net

![createVirtualNetwork][dockerNetworkCreate]

    Start two elasticsearch containers:

        docker container start --network wrcg-net --network-alias search elasticsearch

        Note: In my example there is a lot of extra stuff, this is because the latest elasticsearch images do not
        play nice with M1 Macs. You may get your own errors, may the odds be in your favour, chief.

![startElasticsearchx2][dockerStartElasticsearch]

    Use nslookup command to obtain the IP Address of the containers

        docker run --network wrcg-net alpine nslookup search

        Note I: here, we're making this container a member of the private network we created, do you understand why?
        WhatsApp me your answer. If not, try doing the command (after reading the bits related to this command and
        its output) without the --network tag, i.e. a member of the default network. What output do you get? Why do
        you think this is? Again, WhatsApp me your thoughts.

        Note II: the alpine part as you might have understood is the image part, alpine is a very lightweight linux
        distro.

        Note III: nslookup is the command we're running within the alpine container, here we're giving the arguement
        'search' to nslookup, so it'll go off, look for hostnames with the name 'search' and return their ip
        addresses. Read https://en.wikipedia.org/wiki/Nslookup for an explaination on nslookup, it's something you
        may use quiet often.

![nslookupSearchContainers][nslookupSearch]

    You might ask, how can we verify that these addresses belong to our containers? Well, we can use the inspect
    command and filter the ip address.

<br />

    docker container inspect 6f6 | grep IP

        Note I: You should already be familiar with the docker container inspect command, try running it without the
        '| ...' to see the amount of information available to you, if you need your memory jogged.

        Note II: I have used the first three characters of my CONTAINER ID, see 2 screenshots up, for quickness.

        Note III: The | in linux is called a pipe, it might even work on windows too, it means take the output of
        what comes before me and pipe it in as input to the bit that comes after me.

        Note IV: grep is a filtering tool on the linux CLI. This is a primitive query we're doing, we're basically
        saying, any line that contains the characters IP, print it out. You can get more sophisticated with regular
        expresssions.

![dockerContainerInspect6f6][inspect6f6]

    We can see that the ip is 172.18.0.3, so if we look at the output from our nslookup, the other container should
    be 172.18.0.2, if nslookup works as described... Let's check.

![dockerContainerInspect1f9][inspect1f9]

    It looks good 👌🏻👌🏻👌🏻

<br />

    docker container run --network wrcg-net centos curl -s search:9200

        You may have to curl several times, but what you're looking for is to query both containers, we can
        determine from the 'name' field which container was hit. I was lucky enough to hit them sequentially (see
        image below). Now, something clever is happeneing here. We're querying the same domain, i.e. search, but we
        are getting different hosts (containers), this is effectively disaster recovery and/or load balancing. So
        if one of our containers was to go down, if someone was to query the domain, there will still be one 
        available; or, if one container has a lot of traffic on it already, then new traffic can be routed to the
        other. This can also scale to many containers.

        Note I: You might be asking, why can't we just use apline instead of centos (another linux distro),
        remember, alpine is a minimal installation, so curl is not installed on the default image.

        Note II: curl is a commend we use for transferring data, so you hit a link and it'll download whatever is
        there. So for example, if you do 'curl https://www.google.com' it will go to google and download the 
        homepage and then spit out the HTML google has given, because by using the google link you're effectively 
        loading the homepage. For more information on curl: https://en.wikipedia.org/wiki/CURL

![curlContainersLuckyFirstTry][curlContainers]

[dockerNetworkCreate]: ./images/create-virtual-net.png
[dockerStartElasticsearch]: ./images/start-elasticsearch-containers.png
[nslookupSearch]: ./images/nslookup.png
[inspect6f6]: ./images/container-inspect-6f6.png
[inspect1f9]: ./images/container-inspect-1f9.png
[curlContainers]: ./images/curl.png


