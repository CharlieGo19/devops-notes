# Assignment: DNS Round Robin Test

 - We can have multiple containers on a created network respond to the same DNS address.
 - Create a new virtual network (default bridge).
 - Create two containers of the **elasticsearch:2** image.
 - Research and use **-network-alias search** when creating them to give them an additional DNS name to respond to.
 - Run **alpine nslookup search** with **--network** to see the two containers list for the same DNS name.
 - Run **centos curl -s search:9200** with **--network** until you see both 'name' fields show.

 