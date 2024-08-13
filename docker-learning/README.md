# Docker Learning Notes

## Socials

[Discord](https://discord.gg/fZhMavcx)

## Side Quests to go on

    Read up on these Linux concepts, as they allow docker to do what it does.

        1. NAMESPACES
        2. CGROUPS
        3. VETH
        4. IPTABLES
        5. UNION MOUNT

## ***[command]*** docker version

    > docker version

    - Use: Displays version of Docker Client and Docker Server. It also verifies the CLI can talk to the docker
    engine.

    * Example output *

        charlie@fsociety devops-notes % docker version
        Client:
        Cloud integration: v1.0.35+desktop.5
        Version:           24.0.7
        API version:       1.43
        Go version:        go1.20.10
        Git commit:        afdd53b
        Built:             Thu Oct 26 09:04:20 2023
        OS/Arch:           darwin/arm64
        Context:           desktop-linux

        Server: Docker Desktop 4.26.1 (131620)
        Engine:
        Version:          24.0.7
        API version:      1.43 (minimum version 1.12)
        Go version:       go1.20.10
        Git commit:       311b9ff
        Built:            Thu Oct 26 09:08:15 2023
        OS/Arch:          linux/arm64
        Experimental:     false
        containerd:
        Version:          1.6.25
        GitCommit:        d8f198a4ed8892c764191ef7b3b06d8a2eeb5c7f
        runc:
        Version:          1.1.10
        GitCommit:        v1.1.10-0-g18a0cb0
        docker-init:
        Version:          0.19.0
        GitCommit:        de40ad0

## What is a docker image?

    An image is the binaries and libraries of the application to be run.

## What is a container?

    A container is an instance of the image running as a process.

    Note: You can run multiple instances of an image, therefore, many containers.

## Docker Hub (hub.docker.com)

    Docker Hub is Docker's default image registry, a place where you can upload your own images or download other 
    peoples/organisations images.

## ***[command]*** docker container run $args

    > docker container run -d --publish 9090:80 nginx

    - Use: Several things are going on here, and we will go through them sequentially. 'docker container run' is
    telling docker that we would like to run a container, '-d' is telling docker that we'd like to run this in
    detached mode, which is to say, that it doesn't take over your terminal and runs in the background... However it
    will print out your Container ID. Next we have '--publish {host}:{container}' in this example we used
    '--publish 9090:80', this says that we're opening port 9090 on our machine (the host ip) and routing all that
    that traffic to the containers ip on port 80. Finally we have 'nginx', this is web server image for serving
    websites, if you type localhost:9090 in your browser after running the command you will see the default website.
    This is running from the container!!! The ports used are configurable to your projects desire, but note some
    ports are convention/standard.

    Note: You can run the command 'docker container run --help' for more information about the options available to
    you.

    * Example output *

    charlie@fsociety devops-notes % docker container run -d --publish 9090:80 nginx
    a4b36258c8580d178d8ce490f7f4d5c13d6f9ddafb1cbc54ad45dda5cca53948

    Note: the second line is the ID of the container.

    ================================================================================================================
    
    What happens technically:

    1. Docker looks for the nginx image locally in your cache, if it;s not found it will look for it in an image 
    repo, the default is Docker Hub.
    2. Downloads the latest by default.
    3. Creates a new container based on that images and prepares to start.
    4. Gives a virtual IP on the private network inside the docker engine.
    5. Opens up port 9090 on the host and forwards to port 80 in the container.
    6. Starts container by using the CMD in the image Dockerfile.

    ==================================================== flags =====================================================

    --env | -e : Allows you to set environment variables in to the container on startup, i.e. for a mysql container
    we can pass in MYSQL_RANDOM_ROOT_PASSWORD=yes

## ***[command]*** docker container logs $args

    > docker container logs mysqlServer

    - Use: will print out the logs for a given container, this can be filtered down to specific time frames. Use the 
    docker container logs --help for more information.

    Note: if the container is logging to stderr you wont be able to use filtering tools like grep. So we have to add
    2>&1 linux flag which tells the shell to redirect the stderr to stdout, which is what grep reads from. This can
    be useful for filtering on specific phrases, i.e. 'docker container logs mysqlServer 2>&1 | grep ROOT' will look
    at the logs of my freshly made mysql container and then look for the generated root password.

## ***[command]*** docker container top $args

    > docker container top mysqlServer

    - Use: will print out the processes running inside the container.

    * example output *

![docker container top mysql][dockerContainerTop]

## ***[command]*** docker container inspect $args

    > docker container inspect mysql

    - Use: will print out a json format document that details the containers configuration.

## ***[command]*** docker container stats $args

    > docker container stats nxginx

    - Use: will provide a realtime stream of the containers statistics, good for local debugging. If no container
    name is provided it will provide realtime stream of all containers.

    Note: Press ctrl+c to get out of this.

    * example output *

![docker container stats][dockerContainerStats]

## ***[command]*** docker container run -it $args bash

    > docker container run -it nginx bash

    - Use: will provide an (i)nteractive (t)erminal, because the main process in this example is bash, once you
    exit out of the terminal, the container will stop running.

    Note: Not all images will have bash installed (Bourne Again SHell), images like alpine, which are super
    lightweight will use sh, as opposed to bash, i.e., docker container run -it alpine sh. You can, once you're in
    install bash if you'd like for the extra tooling.

## ***[command]*** docker container exec -it $args bash

    > docker container exec nginxServer bash

    - Use: the exec command allows you to run a command in a running container, in this case we're running bash. 
    This in turns allows use to do administrative tasks within our containers.

## ***[command]*** docker container rm $args

    > docker container rm angry_hofstadter

    - Use: the rm commands allows you to cleanup and remove containers that are not in use.

![docker container remove][dockerContainerRm]

## ***[command]*** docker container prune

    > docker container prune

    - Use: removes all containers that are not currently active.

![docker container prune][dockerContainerPrune]

## ***[command]*** docker network create $args

    > docker network create cgwr-net

    - Use: creates a network named 'cgwr-net' using the default bridge driver.

### ***[concept]*** docker network create xyz --driver overlay

    Creates a swarm wide bridge network, so containers on different hosts on the same virtual network can talk to
    each other as if they were on a VLAN. This is only for intra-swarm communication.

## What in a Docker Image?

    Simply put, there's a few hings: Application binaries, application dependencies, the metadata about the image 
    data and how to run the image.

    The official definition is: An image is an ordered collection of root filesystem changes and the corresponding
    execution parameters for use within a container runtime.

## ***[command]*** docker image tag $srcImage:tag $tarImage:tag

    This will take an image specified and add a new tag.

## ***[command]*** docker image push $image:tag

    Will upload your specified image to docker hub.

    Note: You must be logged in using the docker login command. If you're using a shared machine or a remote host,
    remember to use docker logout, as it saves an auth token (cat .docker/config.json).

## Docker Files

    Docker files are simply named 'Dockerfile' and you can only have one.

    Docker files will start with **FROM $image:tag** this is usually alpine i.e. FROM alpine:latest.

    The next stanza is usually ENV, setting Environment variables.
    Note: Each stanza is a new layer in your docker image; therefore the top down order matters.

    Next we should handle logs, all our output should be sent to the STDOUT and STDERR, as docker handles everything
    else for us. i.e ln -sf /dev/stdout /var/log/yourApp/access.log  -- creates a link between stdout and your log
    so that docker can pickup that information.

    Next will be exposing ports you'll need i.e. EXPOSE 80 443
    Note: You still need to use -p flag in your docker command to open/forward these ports.


    Note: Always try to put things that change the least at the top of your dockerfile, and things that change the 
    most at the bottom. Because subsequent layers would need to be rebuilt rather than using the cache (once it hits
    a line that's changed).

## UFS

    Docker images are based on the Union File System - allowing multiple file systems to be mounted on top of each
    other, forming a coherent fs  (file system). Contents of directories which have the same path within the merged
    branches (a branch is a separate file system) will be seen together in a single merged directory. This allows a 
    fs to appear writable, but without allowing writes to change the file system - this is known as copy-on-write.

    This will isolate changes to a container filesystem in its own layer, allowing for the container to be restarted
    from a known content (since the layer with the changes will be dismissed once container has been removed).

## Container Lifetime & Persistent Data

    Containers are usually immutable and ephemeral, that is to say, they can be changed and are short lived, 
    disposable. For applications that require a store of data, docker provides features to ensure there's a
    separation of concerns, aka, persistent data. This is achieved using two features:

    1. Volumes: make a special location outside of the containers UFS.
    2. Bind Mounts: link container path to host path.

## ***[command]*** [flag] docker container run -v $volName:$mountPath

    The -v flag will create a named volume on a given mountpath, making it easier to work with in development. 
    You can find the mountpath if part of an official repo by using the inspect command, or looking at the 
    dockerfile. i.e.

    docker container run -d --name mysqltesting -e MYSQL_ALLOW_EMPTY_PASSWORD=True -v mysqlVol:/var/lib/mysql mysql

    This will create/use the volume 'mysqlVol'.

## ***[command]*** [flag] docker container run -v $dirPath:$mountPath

    The -v flag followed by a dirPath will create a bind mount to folder or file on the host machine, remember: host
    always wins.

## Docker Compose

    Docker compose allows you to define and run multi-container applications. It is defined in a docker-compose.yml 
    file. A thing to note is, to avoid naming collisions docker compose will prepend the containing directories name
    to items created defined in the docker compose file. Additionally per docker-compose file, by default, will 
    create an isolated network.

## ***[command]*** docker compose up

    Will build images, start containers, networks and use/create volumes as per the docker-compose.yml document.

## ***[command]*** docker compose down

    Will stop all containers and remove network in relation to the definitions of the docker-compose.yml document,
    and any default networks started if an absence of one defined in the docker-compose file.

    Note: if you add the -v flag, it will also remove volumes.

## Docker Swarm

    Swarm mode is a clustering solution built into Docker. It's not enabled by default, once enabled the following
    commands will be available to you:

        docker swarm
        docker node
        docker service
        docker stack
        docker secret
    
    A basic concept in swarm is the idea of manager and worker nodes, managers nodes have a RAFT database, RAFT is a
    consensus algorithm that helps elect a new leaders. The RAFT database also holds other things like configuration 
    and other information that allows them to be the authority of that swarm. Managers issue commands down to the
    workers. Managers can be demoted to workers and vise versa.

    Benefits of using Swarm as an orchestrator:

        - Comes with Docker, single vendor container platform.
        - Easiest orchestrator to deploy and/or manage by yourself or as a small team.
        - Follows the 80/20 rule, 20% of features will cover 80% of use cases.
        - Diverse platform support.

![docker swarm simple][dockerSwarmSimple]
![docker swarm features][dockerSwarmFeatureSet]

## ***[command]*** docker swarm init

    For starting a swarm, will init leader node.

    Note: There is rules around how many nodes should be in a Swarm (due to the nature of RAFT). The general rule is
    that 2f + 1 Raft nodes tolerate a failure of f Raft nodes. So a 3-node group can withstand a failure of 1 node 
    and a 7-node group can tolerate a failure of 3 nodes (2*3 + 1 = 7).

## ***[command]*** docker swarm leave

    For stopping a swarm. If any nodes left, it will require --force.

## ***[command]*** docker node

    For managing nodes, for example docker node ls will list the nodes in the swarm.

## ***[command]*** docker service

    For managing services in the swarm.

## ***[command]*** docker stack deploy --compose-file $aFile $stackName

    This command takes a file that follows the docker-compose style configuration and syntax, and will start all
    services defined within.

## Note for post version 17.12

    If using an automation shell scripts, use --detach true for docker service create.

## Routing Mesh

    - Routes ingress (incoming) packets for a Service to the correct task.
    - Spans all nodes in Swarm
    - Uses IPVS* (IP Virtual Server) from Linux Kernel.
    - Loading balancing Swarm Services across their Tasks. This is achieved in two ways:
          Container-to-Container in an Overlay network (using VIP).
          External traffic incoming to published ports (all nodes listen).

    * IPVS is a Layer 4 transport-layer load balancing.

![docker swarm vip][dockerSwarmVIP]

## Docker Secrets

    Docker Swarm RAFT database is encrypted on disk and only stored on manager nodes. By default, managers and
    workers control plane is TLS + Mutual Auth; therefore container to container communication is encrypted.
    Secrets are stored within swarm, then assigned to services, only once a secret has been assigned to a service
    can the service access the secret. 
    
    Inside the containers the secrets will appear to be files stored on disk:

        (/run/secrets/<secret_name>) || (/run/secrets/<secret_alias>)
    
    However, they're actually stored within an in-memory filesystem, where the name of the file is the key/name and 
    the contents is the secret.

    Note: Local docker-compose can use filed-based secrets, but these are not secure.

## ***[command]*** docker secret create $name $src

    This command requires the name of secret and the secret itself, it can be input via text input (not recommended)
    or a file. The below example shows via text file.

![docker create secret][dockerSwarmSecretCreate]


## Passing a secret to a container

    For this example we will pass the secrets to postgres using a password file to illustrate how you might be using
    secrets, instead of passing it directly as an environment variable.

    Note: https://github.com/docker-library/docs/blob/master/postgres/content.md#docker-secrets
    
![docker use secret][dockerSwarmSecretUse]

    Out of curiosity we can look at the contents of the secret:

    ...Keep my secret safe, please...

![docker reveal secret][dockerSwarmSecretReveal]

## Handling secrets

    When passing secrets around and getting them to where they need to be, you will need to follow your companies 
    security guidelines. If ever you feel a companies security policies to be inadequate you should always feed this
    back:
        
        1. To protect the company from exposure.
        2. To protect customers.
        3. To protect yourself.
    
    You want to expose your secrets as close as possible to the place that will actually use them, and always be
    vigilant in clean up. Below is a primitive example of how you could expose a secret from your terminals
    history. If a bad actor was able to compromise the machine and you're leaving secrets in plaintext in the
    history, you've done half the work for the bad actor.

![docker leaked secret via cli history][dockerSwarmSecretLeak] 

## Running a private docker Registry

    Note: We're using using the 'registry' image, which will allow us to run a registry locally.  However, if we had
    a requirement where we might want to store these images in the cloud, we could use an image with a driver that
    will allow us to use third party registries.


    First of all, we will need to run the container with a volume:

![start local registry][dockerLocalRegistryStart]

    Now need an image to push to our local registry and re-tag it, as the format for a non docker hub registry it's
    required that it follows the format: $hostOfRegistry/image.

    Below you can see, I download from my repository, then re-tag it - prepending the host, i.e. localhost and the
    port that it has been exposed on, followed by the existing format for docker hub.

![push to local repository][dockerPushToLocalRegistry]

    To show data has been stored, i.e. the image, we can compare tree output vs when we started the container:

![docker tree output of bind-mount dir][dockerTreeOutputLocalRegistry]

## Kubernetes (K8s, Kube)

    Kubernetes like swarm is an orchestration tool and has become the most popular in the industry. It runs as a set
    of APIs within the containers and provides API/CLI tools to manage your containers across your servers. Vendors,
    like clouds providers, such as: AWS, Google Cloud, Microsoft Azure etc offer their own distribution. 

    Note: Kubernetes is more complex than swarm.
    Note: For learning we're using MicroK8s by Canonical.

## Basic Components of K8s

    kubectl:
        CLI to configure K8s and manage apps.
    Node: 
        A single server in the K8s cluster. A node will at a minimum have a Kubelet and a Kubelet-proxy to handle
        the networking.
    Control Plane:
        Consists of 1 or more managers (an odd number for fault tolerance) that manages the cluster. These managers
        include (non exhaustive) - etcd (distributed system for key-value store), scheduler (controlling how and 
        where your containers are placed on the nodes in objects called pods), controller manager (looks at the 
        state of the cluster and looks at the specs and whats going on, and figures out how to reflect the 
        difference).

        Note - you will need to addons for things like DNS, storage, networking etc.
    Kubelet: 
        An agent on each node that communicates between the local container runtime and the K8's control plane.

## Kubernetes Container Abstraction

    Pod:
        One or more containers running together on one node, this is the basic unit of deployment. Containers are
        always in pods. Pods share an IP Addresses and deployment mechanism.
    Controller:
        For creating or updating pods and other objects, you wouldn't normally deploy a pod directly, but have a 
        controller that validates that K8s is doing what you told it to do. There are many types of controllers
        such as Deployment, ReplicaSet, StatefulSet, DaemonSet, Job, CronJob etc.
    Service:
        A network endpoint given to a set of pods, a persistent endpoint in the cluster so we can access the pods at
        a specific DNS name & port.
    Namespace:
        Filtered group of objects in the cluster (for filtering views).

    There's many topics that will probably be out of the scope of these notes and will be included in the Kubernetes
    course such as: Secrets, ConfigMaps etc.

    Note: Remember, you can not directly deploy containers with K8s - you create pods, then the kubelet tells the 
    container runtime to create the containers for you.

## Adding ***[command]*** kubectl to your terminal

    Because we're using microk8's, the kubectl isn't there by default, you access it via: 

        microk8s.kubectl $args

    So for convenience we're going to add it via an alias. If you run the command:

        cat ~/.bachrc

    You'll see there is a section on aliases, as we should avoid editing this file directly where possible, we will
    create an alias file and put our alias there.

![Add kubectl alias to bashrc_alias file][microK8sAddKubectlAlias]

## ***[command]*** kubectl run $name $args --image $image

    The run command requires at a minimum a name and the image that you would like to run, for example:

          kubectl run nginx-pod --image nginx:1.26.0

    Note: you do not need to explicitly define the version of the image you'd like if your requirement requires the
    latest image. Which if is the case, you can omit the version, i.e. --image nginx. However, it's good practice to
    always define a version, because using the latest without review can lead to instability in your 
    service/application.

## ***[command]*** kubectl get $arg

    The get command will display the resources requested as defined by the $arg flag. For example, the all arg will
    return the most common resources that you're most likely to need, i.e. pods, services.

![kubernetes get example][k8sGetExample]

## ***[command]*** kubectl create deployment $name --image $image

    It's rare you will create a pod directly, most likely you'd create a pod for testing something. Normally you
    would use the deployment command. This manages pod creation and exists to achieve high availability (the 5 9s).
    When you issue a deployment command in the control plane the following happens:

        - You request a deployment via the API and it stores that record in the etcd database.
        - The controller manager will monitor the database and when it notices a new deployment resource which will
          then create a ReplicaSet.
        - The ReplicaSet controller will then create records of pods adding them to the etcd database.
        - The scheduler will then assign these to a node to be deployed which would be picked up by the kubelet 
          which will then tell the runtime to create the containers.

    Note: For a period of time, there may exist two versions of your resource, this is why deployment exists and how
    the high availability is achieved.

## ***[command]*** kubectl get $resource $name --output wide

    The --output flag can give us a variety of formats with different levels of information, the wide flag provides
    a small amount more than without; the key information is the selector. Labels and selectors allow one resource
    to find its other resources - i.e. if a deployment creates a ReplicaSet, how does it know which ReplicaSet knows
    which ReplicaSets it's own? This is a function of labels and selectors.

    Note: the get endpoint can return a lot of resources, check kubectl api-resources to see what resources are
    available to you.

## ***[command]*** kubectl get $resource $name --output yaml

    This --output will give detailed information, i.e. metadata, spec, status, selectors, labels, IPs and more.

## ***[command]*** kubectl get $resource --watch

    This is similar to the linux command, watch. Any state changes made to the resource will be shown in realtime in
    you CLI.

## ***[command]*** kubectl get events --watch-only

    This will show events happening in the cluster after the point you issued the watch command.

## ***[command]*** kubectl describe $resource $name

    Will give a structured, detailed output of the details associated with the resource requested. You'll get
    different information based on the resource requested.

## ***[command]*** kubectl logs deployment $name

    This will get the container's logs, but it will pick a random replica and the first container only.

    Note: you can add the flags --follow --tail 1 to follow new log entries that start with the last entry.
    Note: the log command technically only gives you logs from the containers, i.e. your app.

## ***[command]*** kubectl logs --selector $label

    This will enable you to get the logs for multiple pods.

## ***[command]*** kubectl scale $resource_type(/ | [space])$resource_name --replicas $n

    This command will scale up or down the number of replicas defined by $n.

## Exposing Containers

## ***[command]*** kubectl expose $resource_type(/ | [space])$resource_name

    kubectl expose creates a service for existing pod(s), the service will provide a stable address for the pod(s).
    If we want to connect to pod(s) we need a service. Services can be resolved by name due to CoreDNS.

    There are different types of services:

        - ClusterIP
            Provides stable internal (to the cluster) IP Address - allowing pod(s) to talk to each other.
        - NodePort
            Exposes an application on a static port on each node within the cluster.
        - LoadBalancer
            Distributes traffic across the nodes within the cluster, load balancing and routing to backend pods.
            The LB assigns a public IP address or domain name allowing external client access to the application.
            Note: under the hood, LB uses NodePort to assign the static ports.
        - External Name
            Maps a service to an external DNS name, for pod(s) to access external resources using a stable DNS name.
            This is achieved by returning a CNAME record that resolves to the specified DNS address - facilitating
            integration without exposing the K8's service itself.

    Note: you can define a --port and --target-port, both optional, however if --port is not defined then the
    exposed port will be used, and --target-port will have a random high-port within the configured range assigned.

![kubernetes expose nginx deployment][k8sExposeNginxExample]

    In the above example, we have a simple nginx deployment, and to access the deployment from our machine we can 
    expose it using a LoadBalancer. If you observe the PORT(S) column we can see it's reachable on 32091.

## Declarative Yaml

    Typing commands sequentially at the CLI is easy for us to understand but hard to automate. The commands are good
    if we're working locally and start with a fresh install - however in production and more mature systems typing
    the commands at the CLI is impractical. Using a more declarative approach ensures that our system and its
    configuration is reproducible. Therefore, we can use yaml file(s) to declare what state we would like our system 
    to reflect.

## ***[command]*** kubectl $action $resource $args --dry-run=client --output 

    These additional flags will do two things:

        1. --dry-run=client will only show us the output of the command we specify, it will not apply any of the
           changes stated.
        2. --output yaml will give us a generator for the command and resource we specify. It will show us how the
           arguments we provided are applied and what defaults k8's applied.

    example: 

        kubectl expose deployment nginx-test-1 --port 80 --dry-run client --output yaml

    output:

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: nginx-test-1
  name: nginx-test-1
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-test-1
status:
  loadBalancer: {}
```

## Management with Yaml

    There are two ways we can use yaml with K8's:

        1. We can use the commands, i.e. create, replace, delete... with the --filename=[], where the filename is
           the yaml file name with your specs in, and it will apply those.
        2. We can fully declare our system and simply use the apply --filename=[] which can be a yaml file or a
           directory of yaml files. This is easiest for automation, but can be hard to understand predict changes -
           we can use git style diff (kubectl diff --filename=[]) to show us changes in configuration between the
           input and the current live configuration.

    Using yaml along with a version control tool, like git, can enable a more robust system for automation,
    collaboration and deployment. By storing them in a git repository, we can track changes, have better consistency
    across different environments (using your companies design guidelines) and most important of all, it makes it 
    easier to roll a bad deployment back. This kind of design philosophy and implementation is the basis for GitOps. 



[dockerContainerTop]: ./images/docker-container-top.png
[dockerContainerStats]: ./images/docker-container-stats.png
[dockerContainerRm]: ./images/docker-container-rm.png
[dockerContainerPrune]: ./images/docker-container-prune.png
[dockerSwarmSimple]: ./images/docker-swarm-simple.png
[dockerSwarmFeatureSet]: ./images/docker-swarm-feature-set.png
[dockerSwarmVIP]: ./images/docker-swarm-vip.png
[dockerSwarmSecretCreate]: ./images/docker-swarm-secret-create.png
[dockerSwarmSecretUse]: ./images/docker-swarm-secret-use.png
[dockerSwarmSecretReveal]: ./images/docker-swarm-secret-reveal.png
[dockerSwarmSecretLeak]: ./images/docker-swarm-secret-history.png
[dockerLocalRegistryStart]: ./images/docker-local-registry-start.png
[dockerPushToLocalRegistry]: ./images/docker-retag-push-local-repo.png
[dockerTreeOutputLocalRegistry]: ./images/docker-local-registry-tree.png
[microK8sAddKubectlAlias]: ./images/microk8s-add-kubectl-alias.png
[k8sGetExample]: ./images/k8s-get-command.png
[k8sExposeNginxExample]: ./images/k8s-nginx-with-loadbalance.png