# AWS Solutions Architect Associate Notes

## AWS Accounts

    An AWS Account is a container for identities (users) and resources, the prerequisites to create one is:

        1. An AWS Account Name, i.e. $projectName-sandpit, $projectName-dev, $projectName-prod, etc...
        2. A unique email.
        3. A payment card.

    When you create an AWS Account, the email provided is used to create an 'account root user', this is the only
    account to exist out of the box and has root privileges, i.e. it can perform every and any task. This account
    cannot be deleted. It's bad practice to do administration tasks from root user, therefore you should create an 
    IAM User (Identity and Access Management) with the exact permissions required to fulfil the respective
    tasks. The payment card provided is the account payment method, so any resources consumed that are
    billable will be charged to this payment card.

    Note: its not uncommon to have multiple AWS Accounts for mid to complex projects.
    Note: Cross account permissions are achievable (excluding account root user), which will be documented later.
    Note: It is possible for learning to create multiple aliases from one email address, i.e. on apple I use
    'hide my email', a gmail account you can do $yourEmail+$someString@gmail.com where, $someString is a random
    string that will form an alias for you. For hotmail, you can go into your account settings and create some
    aliases.

## Enable MFA

    You should try to always add some form of MFA to your AWS Account once created. There are several factors that
    can help improve the security of your account(s):

        1. Knowledge: Something you know, i.e. username & password.
        2. Possession: Something you have, i.e. MFA device/app.
        3. Inherent: Something you are, i.e. fingerprint.
        4. Location: Physical, i.e. company network.

    It is best practice to have at a minimum of 2 of these, commonly it will be your username & password along with
    some possession. This strikes a good balance that is convenient, and if your username & password are exposed,
    you have an extra layer of security, i.e. your MFA device/app.

    Step 1:
        Once you've created an account, navigate to the top left and click the drop down box, here we select
        'security credentials':

![AWS Security Credentials Link][awsLocateSecurityCredentials]

    Step 2:
        Scroll down to 'Multi-factor authentication (MFA)' amd click 'Assign MFA device:

![AWS Add MFA Device][awsAddMFA]

    Step 3:
        Add a device name, here you'd follow your companies naming standards, i.e. $env-$user-$function and then 
        select the desired medium, for this example we'll use Authenticator App:

![AWS Input Device Name and Select Medium][awsDeviceNameAndMedium]


    Step 4:
        Using the Google Authenticator app, in the bottom left of the app press the '+' symbol and scan the QR code 
        You will now need to enter two consecutive codes that the app generates:

![Example Google Authenticator App Entry][googleAuthenticatorApp]
![AWS QR Code and Auth Codes][awsScanQRCodeAndAddAuthCodes]


    Now you should be able to see your device in the MFA section of the security credentials page. To verify that
    you've applied the configuration correctly you can re-log.

![Successfully Added MFA][awsSuccessfullyAddedMFA]

## Creating a Budget

    The cloud by nature is dynamic, costs can run away unless we set budgets. Setting spending limits and alerts is
    a proactive measure that allows us to stay within our financial goals, mitigate unexpected costs and optimise
    resource usage.

    Note: For the following steps, you'll be required to login as the account root user.


    Step 1:
        Navigate to the top left and click the drop don box, select 'Billing and Cost Management'.

![AWS Billing and Cost Management Link][awsLocateBillingAndCostManagement]

    Step 2:
        You'll want to amend some billing preferences, on the left click 'Billing Preferences', edit to activate:

            1. PDF invoices delivery by email.
            2. AWS Free Tier alerts.
            3. CloudWatch billing alerts.

        These measures will help limit your exposure to extra, unexpected costs.

![AWS Billing Preferences][awsSetBillingPreferences]

    Step 3:
        Now we will want to set up some alerts to notify us if any thresholds we need to be aware of for us to stay
        within our cloud budget. I'll be using a zero-spend template. So on the left click 'budgets' then click
        'create budget'. The budget name should follow your companies naming standards.

![Create Budget From Zero-Spend Template][awsCreateZeroSpendTemplate]

    Note: It's good practice to keep an eye on the cost explorer. This can provide you with fine details on your
    cloud expenditure and give a forecast for the coming month's costs.

## IAM (Identity Access Management)

    IAM is a globally resilient service that's used for managing operational user access rights to the services
    associated with your AWS Account. Every AWS Account has its own dedicated instance of IAM, and the database
    linked to this instance is secured across ALL AWS regions. Therefore, there is full trust between your AWS
    account and your IAM service.

    IAM has three fundamental objectives:

        1. Manage Identities.
        2. Authenticate Identities (you are who you say you are).
        3. Authorise Identities (ensure your allowed to do what you've asked to do).

    IAM allows us to create three different identity objects:

        1. User
            A user can be a human or an application that requires access to your AWS Account.
        2. Group
            A set of related users, e.g. dev team, ops team, HR, etc...
        3. Role
            Used by AWS Services or granting external access to your AWS Account.
            [more coming later]

    We can impose AWS Service restrictions to the above objects via IAM policies. A policy document will will allow
    or deny any identity objects access to AWS Services.

    Note: When giving users, applications or groups privileges, always follow the principle of least privileged
    access, i.e. only the permissions they require to fullfil a specific task.

## IAM sign-in URL

    If we're to sign-in with an IAM account, we will can use an IAM sign-in URL - by default it's not very it will
    be a random number prepended to the AWS sign-in URL. To create a more user friendly IAM sign-in URL:

    Step 1:
        In the search bar type 'IAM' and click the IAM service.

    Step 2:
        Within the IAM dashboard you will see the following details:

            1. Account ID.
            2. Account Alias.
            3. Sign-in URL for IAM users in this account.
        
        We need to change the Account Alias, this must be globally unique. Click the edit button next to Account
        Alias and enter something unique and meaningful.

![AWS Account Alias Edit][awsAccountAlias]    

## Creating an IAM Account

    Step 1:
        On the left side of the IAM Service page, click users, then click create user.
    
    Step 2:
        Enter a username that is unique to your AWS Account.

        Note: because my account is fresh, I'm going to be creating an admin account with root privileges. This
        is to use instead of the account root user, therefore I'll name it iamadmin.

    Step 3:
        In the context of the iamadmin account I'll grant user access to the AWS Management Console, and for now
        I'll be creating is as an IAM user and not Specifying a user in the Identity Centre.

    Step 4: 
        Choose your password, either autogenerated on a custom. Because we'll be using this immediately, un-tick
        'Users must create a new password at sign-in'.

![Create An IAM User][awsCreateIAMUser]

    Step 5:
        If we had an existing user group with the permissions we require we could add this user to that group, or
        copy the permissions from another user, but because it's a fresh account we will Attach policies directly.
        For root user level privileges select AdministratorAccess | AWS managed - job function.

![Select AdministratorAccess Policy][awsCreateIAMUserPermissionPolicies]

    Step 6:
        Press create user.
    
    Note: To sign-in, use the IAM Sign-in URL from the previous section.
    Note: Don't forget to add MFA to your new account.

## Authentication via CLI

    When using the AWS CLI we don't use our username, password and MFA, instead we use IAM Access Keys. With the
    expectation of the account root user, IAM users are the only entity on AWS to use access keys. IAM users are
    can have up-to two access keys at anyone time. This is to allow users to rotate access keys, i.e. to practice
    good §§security, periodically you will change your access keys and this process may go something like this:

        1. Create new access keys along side old.
        2. Change access keys across your environments.
        3. Delete old access keys.

    An access key is comprised of two parts: an Access Key ID and a Secret Access Key. When you generate an access
    key, you will only have one opportunity to view or copy the secret access key, once the secret access key has
    been confirmed, there will be no future opportunity to obtain the secret part from AWS.
    An access key can also have two states: active or inactive. By default access keys are active.

## ***[command]*** aws --version

    Returns the current version of AWS CLI.

## ***[command]*** aws s3 ls $args

    Will return a list of S3 objects associated with configured credentials.

## ***[command]*** aws configure $args

    Will configure Access Keys for the AWS CLI to be able to authenticate the user.

    Note: configuring with the --profile argument will allow you to have multiple named profiles.

## Create Access Keys & Create CLI Profile

    To create an access key:

    Step 1:
        Sign in to the account that you're going to be using for the AWS CLI.

    Step 2:  
        Navigate to IAM > Users, select your user, i.e. iamadmin.

    Step 3:
        Select the tab 'Security credentials'
![IAM User Security Credentials][awsIAMUserSecurityCredentials]

    Step 4:
        In Access keys, click 'Create access key'.

    Step 5:
        Select 'Command Line Interface (CLI)' and confirm that you understand the recommendation in the yellow
        dialog that appears.
    
    Step 6:
        Provide a meaningful name that adheres to your companies naming standards for the Access Key,
        i.e. $account-$user-$env-$purpose (GENERAL-IAMADMIN-DEV-OPS).

    Step 7:
        Now safely store the Access Key ID and the Secret Access Key.
    
    Step 8:
        Follow the guide for installing AWS CLI Version 2: 
        https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

        Note: If on macOS you can use brew:
        https://formulae.brew.sh/formula/awscli

        Note: To verify installation was a success run: aws --version

    Step 9:
        To configure a profile using your access keys you can run the following command:

            aws configure --profile iamadmin-general
        
        When prompted enter the access key information (for region I used us-east-1). Now we can run:

            aws s3 ls --profile iamadmin-general

        To see what s3 objects are associated with this IAM User, it should return nothing if it's a fresh account.
        
        Note: If you receive an error message like 'The config profile (iamadmin-general) could not be found', you
        can check the content of the ~/.aws folder to see if the configuration details are correct.

![Configuring Profile of IAM User for AWS CLI][awsConfigureProfileCLI]

## IAM Users

    There is a hard limit of 5,000 IAM Users per AWS Account and each IAM User can be a member of 10 or less groups.
    Therefore IAM Users may not be a viable solution for you if you have internet-scale applications or you're part
    of a large organisation. For use cases that require a higher user count, consider IAM Roles and Identity 
    Federation.

## Public vs Private Services

    AWS public and AWS private services are defined by networking. public, accessed using public endpoints for
    example S3; S3 can be accessed from anywhere that uses an internet connection. A private AWS service runs from
    within a VPC (virtual private cloud) i.e. only entities within the VPC or entities connected to the VPC can
    access the service. Although services like S3 are accessible via the internet, that doesn't mean everyone has 
    authorisation to use it. The scope of use can be limited via permissions or networking. You should note that
    the public internet does not have direct connectivity to the AWS private zone, traffic goes via the AWS public
    zone (where public services exist), if configured.

    +-------------------------+       +--------------------+       +--------------------+
    |   Public Internet Zone  |<----->|   AWS Public Zone  |<----->|  AWS Private Zone  |
    |                         |       |                    |       |                    |
    |    - msn.com            |       |   - S3             |       |+------------------+|
    |    - google.com         |       |                    |       ||        VPC       ||
    |    - amazon.com         |       +--------------------+       |+------------------+|
    |    - yahoo.com          |                                    |          X         | <-- No connectivity
    |                         |                                    |+------------------+|     between VPC's unless
    +-------------------------+                                    |+------------------+|     configured
                                                                   ||        VPC       ||
                                                                   |+------------------+|
                                                                   +--------------------+

    Organisations that require connectivity from on premises networks to private EC2 instances can configure such 
    via a VPN or Direct Connect (Direct Connect is an AWS cloud service that is the shortest path to your AWS 
    resources). You can also attach an internet gateway to your private resource which allows the public internet
    access to the private resource (as long as the private resource has a public IP address allocated to it).

    Note:  By Default only the account root user can access your S3 instance.

## AWS Global Network

    AWS global infrastructure can be grouped into two types of deployments: AWS Regions and AWS Edge Locations.
    A region is an area of the world where AWS has deployed a full set of infrastructure: full compute services,
    storage, DB, AI, analytics, etc... Because AWS Regions are globally distributed, as a SA you can design systems
    which can withstand global level disasters, as well as allowing a level of geopolitical separation, i.e. if your
    customer base has a large EU demographic, you could use a european region so that your service is compliant with
    EU data regulations. There are areas in the world where AWS will not have a Region close to your customers, 
    for this, AWS has an AWS Edge Location: smaller deployments which have content distribution services and some 
    types of edge compute.

    Note: An up-to date list of AWS Regions - https://aws.amazon.com/about-aws/global-infrastructure/regions_az/

## AWS Regions

    By design, AWS Regions are resilient, if an outage was to happen London, UK, and you had a mirror of that
    infrastructure in Frankfurt, Germany, then your German deployment would be unaffected and your services will
    continue to run. However, AWS provides more localised resilience, in the form of availability zones (AZ). Each
    Region could have 2,3,4,5 or even 6 AZ's.

                                    +----------------------------------------------------------+
                                    |                       AWS Region                         |
                                    |                    London (EU West)                      |
                                    |                                                          |
                                    |   +-----------------------------------------------+      |
                                    |   | Availability Zone - eu-west-2a                |      |
                                    |   |                                               |      |
                                    |   +-----------------------------------------------+      |
                                    |                                                          |
                                    |   +-----------------------------------------------+      |
                                    |   | Availability Zone - eu-west-2b                |      |
                                    |   |                                               |      |
                                    |   +-----------------------------------------------+      |
                                    |                                                          |
                                    |   +-----------------------------------------------+      |
                                    |   | Availability Zone - eu-west-2c                |      |
                                    |   |                                               |      |
                                    |   +-----------------------------------------------+      |
                                    +----------------------------------------------------------+
    
    Each AZ has isolated infrastructure (compute, storage, networking, power and facilities), therefore, if there's
    an outage in one of these AZs within a Region, it's likely that the other AZs will be unaffected. So as a SA, 
    if you have 6 instances of your service running within a region, you could place 2 in each AZ.

    Note: An AZ may be a data centre, or it maybe part of multiple data centres.

## VPC (Virtual Private Cloud)

    A VPC is a virtual network inside of AWS and is within one account and one region, therefore VPC's are 
    regionally resilient. A VPC by default is private and isolated from other VPCs, the AWS Public Zone and the
    Public Internet, unless you configure otherwise; that's to say, that any services running with the VPC will be
    able to communicate, but unable to communicate with services outside the VPC. However, the Default VPC, is an
    exception. The Default VPC CIDR range is 172.31.0.0/16, each AZ within the region will be assigned a subnet, the
    IP Address ranges are always configured the same for the Default VPC, for example:


                                    +----------------------------------------------------------+
                                    |                       AWS Region                         |
                                    |                    London (EU West)                      |
                                    |                 VPC CIDR 172.31.0.0/16                   |
                                    |   +-----------------------------------------------+      |
                                    |   | Availability Zone - eu-west-2a                |      |
                                    |   | 172.31.0.0/20                                 |      |
                                    |   +-----------------------------------------------+      |
                                    |                                                          |
                                    |   +-----------------------------------------------+      |
                                    |   | Availability Zone - eu-west-2b                |      |
                                    |   | 172.31.16.0/20                                |      |
                                    |   +-----------------------------------------------+      |
                                    |                                                          |
                                    |   +-----------------------------------------------+      |
                                    |   | Availability Zone - eu-west-2c                |      |
                                    |   | 172.31.32.0/20                                |      |
                                    |   +-----------------------------------------------+      |
                                    +----------------------------------------------------------+

    The subnets for each AZ is where the resiliency comes from, i.e., if one AZ was to be unreachable, the other two
    subnets will be unaffected. The Default VPC comes configured with an Internet Gateway (IGW), Security Group (SG)
    and a Network Access Control List (NACL).

    Note: You can only have one Default VPC per region, but you can have many custom VPCs within a region.
    Note: When configuring subnets, the CIDR range can not be the same as other subnets in your VPC.

## EC2 (Elastic Compute Cloud)

    EC2 is IaaS (Infrastructure as a Service), it provides instances of private (by default) virtual machines. EC2
    instances use VPC networking, therefore, the VPC that the EC2 instance is running within must be configured to
    allow external access if you want to access the resource from outside the VPC. EC2 is AZ resilient, so, if the
    AZ fails, it's likely that the EC2 instance will also fail. EC2 is on demand billing, so you could be billed by
    the second, or by the hour. Factors of the instance charge is as follows: CPU, memory, storage and  any 
    commercial software the instance uses. An EC2 instance can be created from an AMI (Amazon Machine Image), an AMI
    contains Permissions of the AMI:

        1. Public - Everyone can launch an EC2 instance from the AMI
        2. Owner - Only the owner can launch an EC2 instance from the AMI
        3. Explicit - Owner grants permission to specified AWS Accounts to allow EC2 instances to be launched.

    It also contains at a minimum the Root Volume (it can contain multiple volumes), and containers block device 
    mappings (links the volumes to the device ID that the OS expects). You can also create an AMI from an EC2
    instance.

    Note: Because EC2 is IaaS, you're responsible from the OS and upwards on the infrastructure stack.

## S3 (Simple Storage Service)

    S3 delivers two things: objects and buckets. Objects uses unique keys to store objects. An object has the
    following attributes:

        Key: The name you assign.
        Version ID: An Amazon S3 generated string, that along with the key uniquely identifies an object within a 
        bucket.
        Value: The content being stored, this can range from 0 bytes to 5TB in size.
        Metadata: This is a combination of user defined metadata and Amazon generated metadata.
        Subresources: A subresource mechanism to store object-specific information.
        ACL (Access Control List): Control access to the object.

    Data stored within S3 buckets have a primary home region and it never leaves the region unless configured to do
    so, therefore S3 has stable and controlled data sovereignty. An S3 Bucket name must be globally unique. A bucket
    can hold an unlimited number of objects, which means, a buckets can store a near infinite bytes of data.

    Rules for Buckets:

        1. Bucket names must be globally unique.
        2. Must be 3-36 characters, lower case and no underscores.
        3. Must start with a lowercase letter or number.
        4. Can not be IP formatted, e.g. 172.132.0.0.
        5. Bucket Limits: 100 soft limit, 1,000 hard limit per account.
        6. You're allowed unlimited objects in a bucket, from 0 bytes to 5TB.
        7. S3 is not file or block storage, it's an object store.

    Note: Buckets should be the starting point when trying to set permissions for S3.  
    Note: a bucket is a flat structure, there is no concept of a filesystem - therefore, S3 does not have any
    understanding of files types, it's just a sequence of bytes.

## AWS CloudFormation

    CloudFormation is a tool in AWS that allows you to create, update and delete infrastructure within AWS, it can 
    be likened to Docker Swarm Stacks, i.e. you create a template that describes the logical resources, where the
    respective services will provision the physical resources and maintain the level of resources described.
    CloudFormation templates can be written in YAML or JSON.

        1. AWSTemplateFormationVersion: [optional]
                If version is omitted, then it is assumed.

        2. Description: [optional]
                A description of information you want users of this template to know. If you have both the
                AWSTemplateFormationVersion section and a Description section, then the Description must always
                follow the AWSTemplateFormationVersion section.

        3. Metadata: [optional]
                Has advanced functionality, and can control how the different things in the CloudFormation template 
                is presented through the AWS Console, i.e. adding labels, groupings, etc.

        4. Parameters: [optional]
                You can add criteria, set defaults, set AZ's or prompt the user for things like instance sizes.

        5. Mappings: [optional]
                Key-value pairs that allow you to specify conditional parameter values, i.e. dev, prod -> AMI.

        6. Conditions: [optional]
                Allows decision making in a template. This is a two step process, first you define the condition,
                then you use the condition in your Resources section.

        7. Transform: [optional]
                Specifies one or more macros that should be applied during the processing of the template.

        8. Resources: [required]
                List of resources that tells CloudFormation what to do, i.e. if  it says create, update or if 
                resources are removed, CloudFormation will update to reflect what has been defined. This is the only
                mandatory part of the document.

        9. Outputs: [optional]
                Describes the values that are returned when you view your stack's properties.

    The lifecycle of the CloudFormation process can be reduced to three stages:

        1. The user defines a template.
        2. Based on the resources defined, CloudFormation creates a stack of the logical resources.
        3. Based on the stack, CloudFormation provisions/removes physical resource.

    CloudFormation can be a powerful tool for managing multi-region deployments, scaling and disaster recovery.
    
    Note: CloudFormations primary function is to keep the stack and the physical resources in sync.

## AWS CloudWatch

    CloudWatch is a support service is for operational management and monitoring. Cloudwatch can:

        1. Collect and manages operation data, data about an environment how it performs nominally runs or logging
           data ir generates.
        2. Collect metrics for AWS products, Apps or on-prem instances.
        3. CloudWatch Logs - AWS Products, Apps or on-prem instances.
        4. CloudWatch Events - AWS SErvices & Schedules.


       Data Ingres                           CloudWatch 
    +---------------+    +-------------------------------------------------+     +-----+
    |               |    |                                                 |  +--| SNS |
    |      AWS      |    |  +----------------+           +-------+         |  |  +-----+
    |    Services   |    |  |    Metrics:    |           | Alarm | -----------+ 
    |               |    |  |                |           +-------+         |  |  +--------------+
    |     and/or    |===>|  |    - CPU       |---------<                   |  +--| Auto Scaling |
    |               |    |  |    - Memory    |           +------------+    |     +--------------+
    |  Custom Data  |    |  |    - Disk      |           | Statistics |    |
    |               |    |  +----------------+           +------------+    |  
    +---------------+    |                                     |           |
                         +-------------------------------------|-----------+
                                                               |
                                                       +-------+------+
                                                       |              | 
                                                  +---------+       +-----+
                                                  | Console |       | API |
                                                  +---------+       +-----+

    CloudWatch separates data via Namespaces, a Namespace can have a name as long as it adheres to the Namespace 
    naming standards. Namespaces are a collection of related metric, and a metric is a chronological ordering of
    like data points, i.e. CPU, Network I/O, Disk. Metrics can be further filtered on Dimensions, for example, your
    CPU Metrics will be aggregated from all your EC2 instances - to get targeted granularity you can filter on
    dimensions like: InstanceId, InstanceType, etc...
    
    CloudWatch allows you to take actions based on given metrics. You can create Alarms that once triggered, can
    enact an action that could send an SNS notification or scale you infrastructure.

    Note: There is a reserved namespace - AWS/$service, i.e. AWS/EC2
    Note: To monitor non-native processes, or metrics outside of AWS you'll need the CloudWatch Agent.

## Shared Responsibility Model

    When interacting with AWS's products, it's good practice to consider what security you're responsible. Below is
    AWS Shared Responsibility Model. Put simply, AWS is responsible for the security of the cloud and you're
    responsible for the security in the cloud.

![AWS Shared Responsibility Model (Security)][awsSharedResponsibilityModelSecurity]
![AWS Platform Shared Responsibility Model][awsPlatformsSharedResponsibilityModel]

## High Availability x Fault-Tolerance x Disaster Recovery

    High Availability: 
        Aims to ensure an agreed level of operational performance, usually uptime, for a higher than normal period
        of time. Therefore, we're trying to maximise the systems online time, we're not guaranteeing an absence of 
        outages.

    Fault Tolerance:
        Fault-Tolerance is the product of a more sophisticated design than high availability, a system must continue
        to operate properly in the event of the failure of one or more components. Fault-Tolerance is harder to
        design, implement and will be more expensive than high availability.
    
    Disaster Recovery:
        Disaster Recovery is a set of policies, tools and procedures to enable the recovery or continuation of vital
        technology infrastructure and systems following a natural or human-induced disaster. DR is more than the
        technology, it requires pre-planning for all reasonable outcomes, it requires robust and effective back-ups,
        it requires extra staffing and training, it requires a state of readiness and it requires consistent testing
        to ensure it's ready. Ultimately, it's designed to keep your critical and non replaceable components safe.

## Route 53

    Route 53 is AWS's managed DNS product, it allows you to register domain names and it can host zone files on 
    managed nameservers provided by AWS. It's a global service and is distributed globally as a single set and is
    replicated across regions, therefore it's a globally resilient service. Route 53 has a relationship with major
    domain name registries, i.e. .com, .io, .net etc, which allows AWS to register domains - it does this by
    checking with the registry if the top level domain is available,if it is then it creates a zone file for the
    domain being registered and allocates nameservers for this zone (a hosted zone), Route 53 will then liaise with
    with the registry and adds the nameservers records for the .{domain} nameserver record, which indicates those
    nameservers are authoritative for the domain.

    Note: A zone file is a config file that contains all the DNS information relating to the domain name.
    Note: There are usually 4 nameservers for a given zone (.com, .io, .net etc...).
    Note: A hosted zone can be public or private, so the domains are only accessible from your VPC(s).

## Route 53 (DNS in General)

    For a given domain name, i.e. www.amazon.com, api.amazon.com, name.amazon.com we need records so that the input
    address can be resolved. Below are some DNS Records that you should be aware of:

    A Records (Host to IP):
        This record is to map some host to an IPv4 Address, i.e. take www.amazon.com, there will be an A Record
        where the entry will have a name of www (entirety would be www.amazon.com, but define what is prepended to
        the first dot) and it would point to the IPv4 address of an amazon server, i.e. 123.123.123.123.
    
    AAAA Records (Host to IP):
        Serve the same function as A Records, but for IPv6.

    CNAME Records (Host to Host):
        This is a DNS shortcut, this allows you to resolve a different record to the same domain name, e.g.
        api.amazon.com, there will be some CNAME record that points to www.amazon.com where the A Record points to
        the ip address of a server that performs a common function.
    
    MX Records:
        MX Record have two parts: priority and value, if no FQL defined, then its assumed it's internal (within the 
        domain zone), i.e. assume we're working with google.com, there will be some A record named mail that points 
        to an SMTP server (the A record can be called whatever, but for simplicity we're using mail), then you can 
        have an MX Record that has a value of mail (rather than an FQDN). It's possible to have multiple
        MX Record, which you can assign priorities to, the lower the number, the higher the priority.

    TXT Records:
        You can add arbitrary text to a domain - this can serve functions such a proof of ownership of a domain,
        and spam protection.

    TTL (Time to Live):
        You can set a value (in seconds) on a DNS record, this is how long your DNS records are cached (a non
        authoritative answer) for on the resolver server. This can be a pain point if ever you're changing DNS 
        records.

## ARN (Amazon Resource Name)

    ARNs uniquely identify resources within any AWS Accounts, ARNs are used in IAM policies which are attached to
    identities like IAM users, the defined format is:

    arn:partition:service:region:account-id:resource-id
    arn:partition:service:region:account-id:resource-type/resource-id
    arn:partition:service:region:account-id:resource-type:resource-id

        Example 1: arn:aws:s3:::romcoms
        Example 2: arn:aws:s3:::romcoms/*

    The two examples refer to an S3 bucket, because bucket names are globally unique, the region and account-id do
    not need to be defined, so it's important to note that different services will have different looking ARNs. The
    examples also look very similar, however, their distinction has a fundamental effect. The two ARNs have no
    overlap, the first one refers to the bucket, the second one refers to the objects in the bucket. Some actions
    will work on buckets, some will work on objects, so you will need to specify the appropriate ARN in you policy.

    
## IAM Identity Policies

    IAM Identity Policies is a set of security statements for the relationship between IAM Users and AWS Resources. 
    An IAM Policy Document is one or more statements written in JSON. A statement requires at a minimum the 
    following fields:

        Sid (Statement ID):
            Informational to explain what the statement is doing, concisely.

        Effect:
            The intended response and effect you desire given some IAM users request.
        
        Action:
            A list of one or more actions you want to affect.
            Format: {service}:{[a list of operations]|wildcard}
        
        Resource:
            A list of resources you want to affect:
            Format: Follows IAM Amazon Resource Names 

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "FullAccess",
                    "Effect": "Allow",
                    "Action": ["s3:*"]
                    "Resource": ["*"]
                },
                {
                    "Sid": "DenyRomComBucket",
                    "Effect": "Deny",
                    "Action": ["s3:*"]
                    "Resource": ["arn:aws:s3:::romcoms", "arn:aws:s3:::romcoms/*"]
                }
            ]
        }

    There will be times when there's multiple policies applied which leads to an overlap of statements where there
     will be conflicts of access to resources, if this is the case there is an order in which they're applied:

        1. Explicit Denys always take precedence.
        2. Explicit Allow, this takes effect unless there's an explicit deny.
        3. Implicit Deny, if there's no explicit allow, then an implicit deny is applied.

    There are two main types of IAM Policies:

        1. Inline policies: Individual policy applied to a specific account. 
        2. Managed policies: A policy that can be applied to multiple accounts.
    
    Managed policies should always be the default choice, as you can change permissions across more people safely.
    It has less overhead as you only need to make changes in one location rather than multiple and is more secure
    as there's less scope for human error in giving wrong permissions to an individual.

    Note: Every interaction you have with AWS will have two main components, the resource and the action to be
    performed on that resource. A statement only applies in AWS if the action you're performing matches the Action 
    and the Resource.

## IAM Groups

    IAM Groups are containers for IAM users, they're solely for organising users and making management of the users 
    easier. you can not login to a group, and they have no credentials. When a user is a member of multiple groups,
    and those groups have IAM policies (inline and managed) associated with them, AWS will create a set of those 
    policies and use the permissions when evaluating access rights.

    IAM Policies can be attached to resources, it's worth noting that IAM Groups are not a true identity, they can't
    be referenced as a principal in a policy, therefore a resource can not grant access to a group; it can grant
    access to individual users and roles, but not a group.

    Note: A principle is a person, application, device or process that wants to authenticate with AWS.
    Note: Unless you define one, there is no universal group containing all users associated with the AWS Account.
    Note: There is a soft limit of 300 Groups per account, which can be increased via support ticket.

## IAM Roles

    IAM Roles are an entity that sits within an AWS Account. Where a single principle uses an IAM User, an IAM Role
    can have multiple or an unknown number of (internal or external) principles. Due to the 5,000 IAM User limit 
    imposed upon an AWS Account, IAM Roles are a perfect fit to scale beyond this limit due to it's ability to
    interact with users external to AWS i.e. Windows Active Directory, this is known as Federated Authentication.
    When a user assumes an IAM Role, that user becomes that role and inherits the permissions that comes with it.
    IAM Roles should be specific in scope and temporary, although a Unix root user is persistent, you could think
    of it as using the root user, you assume those elevated privileges for a very specific task that (should be) 
    is finite/short lived in duration.

    IAM Roles differ from IAM Users with regards to what policies can be attached, i.e. IAM Users can only have
    permission policies attached (inline or managed). However, IAM Roles have another type of policy, a trust 
    policy. A trust policy controls which identities can assume the role, a trust policy can reference identities 
    within the same AWS Account, i.e. IAM Users, other roles or AWS services; it can also reference identities from
    external AWS Account, external identities and even allows for anonymous usage of the role.

    When an identity assumes a role, it is given a temporary security credentials, whenever an identity uses the 
    temporary credentials are used, the credentials are checked against the permissions policy associated with that
    IAM Role, so if the permissions change, it will be reflected when the credentials are checked again, against 
    the permissions policy.

    Note: IAM Roles can be referenced in resource policies.

## Use Cases for IAM Roles

    For AWS Services:
        Services like AWS Lambda, you have asked Lambda to start and stop services or process real-time data. For it
        to fulfil it's function it requires permissions (as with most things in AWS, services start permissionless).
        AWS Lambda is not an identity, it's a component of a service, therefore we will need to give it access keys
        in order for it to function. Hard coding access keys is a security risk, therefore creating a Lambda 
        Execution Role is a perfect use case.

        In a typical scenario, a trust and permissions policy grants the Lambda Execution Role the necessary 
        permissions to access services like S3 and CloudWatch. When the Lambda function is invoked, STS (Secure 
        Token Service) provides a temporary set of security credentials, allowing the function’s runtime to interact
        with the required services during execution.
                                                                             +-------------+
                            Lambda Execution Role <---------------------+    |    Trust    |
                           +-------------------------------+            |    |    Policy   |    
                           |           AWS Lambda          |            |    +-------------+   
                           +-------------------------------+            +----+       
                                          | Lambda trusted and               +-------------+
                                          | permissions validate             |  Permission |
                                          | authorisation.                   |    Policy   |
                                          v                                  +-------------+
                                   +------------+
                                   |     STS    |              +------------------+
                                   +------------+              |        S3        | 
                                          |  sts:AssumeRole    +------------------+
                                          +-------------------> 
                                                               +-------------------+
                                                               |     CloudWatch    | 
                                                               +-------------------+

        Note: Because there can be many Lambda Functions running in parallel, this would be an unknown quantity,
        therefore again showing that IAM Roles is a perfect fit for this use case.

    Emergency Access:
        Consider a support team, where 99% of the time, read only access is required. On a Sunday morning at 04:00
        a urgent support request comes in, and the technical team is out of office and an EC2 instance needs
        terminating and recreating. We can allow a member of the support team additional access for a short time, 
        using IAM Roles that would grant them the permissions to restart the EC2 instance. This is known as a break
        glass event, i.e. it's an action with an intent. There is a complete auditable log that can show who the 
        access was granted to and when.

    Integrating AWS into an Existing Corporate System:
        Most corporations will have their own single sign-on implementation and will most likely exceed the 5,000
        identities. Because external identities can't directly interact with AWS Services, using an AWS Role to give
        an external identity permission to interact with AWS Services is also a good use case, this is known as
        ID Federation.

## Service-linked Roles

    Service-linked roles are linked to a specific AWS Service, they're predefined by the service and the provide the
    permissions that the service needs to interact with other AWS Service on your behalf. The Service-linked Roles
    also form part of AWS Security architecture, let's say you have a team member that should not directly have the
    ability to interact with a service, you can give that team member the PassRole permission, The PassRole 
    permission lets users allow services to assume roles without granting them full access.

    Note: You can't delete the role until it's no longer required.

## AWS Organisations

    AWS Organisations is a product that allows large organisations to manage multiple AWS Accounts in a cost
    effective way with minimal management overhead. If AWS Organisations didn't exist, organisations would have to
    manage multiple payment methods and IAM Users which would get very complicated very quick. AWS Organisations are
    structured as follows:

        1. You have standard AWS Account you create an AWS Organisation. A distinction that must be understood, that
           you're not creating an organisation within the AWS Account, you're just using the account to create the
           organisation.
        2. The AWS Account that you created the AWS Organisation with, becomes the management account of that
           organisation.
        3. Using the management account, you can invite other standard AWS Account to the AWS Organisation. When the
           accounts accept the invitation, they change from standard accounts to member accounts. Therefore, AWS
           Organisations have one management account and zero or more member accounts.
        4. You can then create a structure and group these member accounts, at the top is the organisation root: the
           organisation root is a container that can hold the management account, member accounts, or other
           containers that are known as organisational units (OU). OUs can also containers the management account,
           member accounts and other containers to form a complex nested structure should you have a requirement for
           such a structure.

    A feature of AWS Organisations is consolidated billing: the individual AWS Accounts delegate their billing to
    the management account. Therefore, you have one single bill that contains the billing for all member accounts
    of the organisation.

    Another feature a service call service control policies, which allows you to restrict what services accounts in 
    an AWS Organisation can use.

    When creating an organisation, it changes the best practices with regards to user logins and permissions.
    Within organisations you don't need to have IAM Users within every AWS Account, instead you can use IAM Roles
    to allow IAM Users to access other AWS Accounts.

    Most organisations will keep their management account clean and use it for billing only, and use another account
    as the 'Identity Account', because they will most likely have their own on-prem users and can utilise identity
    federation via this Identity Account. Once we've logged in using 

    Note: for larger businesses, the more services you use the cheaper some services are, also paying in advance 
    for services will also bring down the cost. Once logged in via the identity account, we can use a feature called
    role switch, allowing us to assume roles in different AWS Accounts within the organisation.

## Service Control Policies

    Service Control Policy (SCP) is a policy document (JSON), use to restrict permissions within an organisation.
    An SCP can be attached to the root container of the organisation, to one or more OUs and it can be attached to
    individual accounts. SCP's apply down the organisational tree, so it will affect nested OUs and individual
    accounts that are part of an OU with an SCP applied to it. SCP's can not give permissions to accounts or users,
    it can only restrict the actions an account can do (not the users directly); therefore you will still need to  
    give identities within the AWS accounts permissions to use services. SCP's are powerful tool in large 
    organisations because it enables you to restrict certain accounts to certain regions, or even restrictions for 
    certain accounts to a particular size of an EC2 instance.

    Note: You can not restrict the management account via SCP's, therefore it's good practice to not use the 
          management account for any AWS resources in production.
    Note: Because SCP's restrict the permissions of an account, they indirectly restrict what the root user of an
          account can do.

## AWS Control Tower

    AWS Control Tower is service that facilitates a multi-account environment. It orchestrates other AWS services to
    automate/delegate account provisioning, configuration, logging, auditing, SSO/ID Federation and policy 
    enforcement.

![AWS Control Tower Architecture][awsControlTowerArchitecture]

    Like AWS Organisations, you're required to create an AWS Control Tower, the account that does this becomes the
    management account of the landing zone (the landing zone* is the multi-account env of AWS Control Tower). 
    Within the management account we have Control Tower which orchestrates everything, AWS Organisations that 
    provides the multi-account structure, single sign-on via the identity centre. When AWS Control Tower is created
    two OU's are setup:
     
        1. Foundation Operational Unit (Security): 
               This will contain two accounts, the Audit Account and the Log Archive Account. The Audit Account for 
               users that need access to Audit information created by Control Tower, this is a good place for third 
               party tools that need access to audit information of your environment. Services used here could 
               include SNS, for notifications when governance is changed within the environments and CloudWatch for 
               landing zone wide metrics. The Log Archive Account is for access to all logging information for all 
               accounts enrolled within the landing zone. It's a secure read only environment for your logging and 
               explicit access must for  granted. Services used by this account could include AWS Config and 
               CloudTrail.

        2. Custom Operational Unit (Sandbox):
                This is where any accounts create by the Account Factory are placed. The Account Factory, automates
                the creation, editing or deletion of accounts. It can be interacted with via the AWS Control Tower
                management console or the Service Catalogue. The configuration of these accounts are handled by the
                Account Factory with a Account and Network Baseline - this is achieved by using AWS CloudFormation
                so you will notice stacks being created within your AWS Account. The Account Factory also utilises
                AWS Config or Service Control Policies to implement guardrails to alert if deviances in permissions
                occur or prevent them from occurring in the first place. This OU is used to test things out or have
                less rigid security, however, you can create other OUs and accounts.
    
    Guardrails are rules for multi-account governance, the come in three types:

        1. Mandatory: Always applied.
        2. Strongly Recommended: They're strongly recommended by AWS.
        3. Elective: Optional to implement your specific requirements.

    They have two different effects: 

        1. Preventative (using SCP): Policies that stop you from doing certain things which are either enforced or not enabled.

        2. Detective: A compliance check that uses AWS config rules to ensure a certain object in AWS is in
           compliance  of the defined Guardrail. Detective Guardrails can have one of the following statuses: clear,
           in violation or not enabled.

    * The Landing Zone is a feature to allow anyone to implement a well architected multi account environment, it 
    has the concept of a Home Region, the region you initially deploy it to. You can explicitly restrict regions. 

    Note: Automated account provisioning can be done by cloud admins or end users with permissions, that allow for a
    self service provisioning of accounts.

## S3 Advanced: Security

    S3 by default is private, explicit permissions to allow access must be configured. This can be done in a number 
    of ways. One of which is a Resource Policy, they're like identity policies, but attached to the resource, i.e. 
    an S3 Bucket. The permissions are from a resource perspective. Unlike identity policies, where you can only 
    allow/deny from within the same account, resource policies allow/deny from the same or different accounts.
    Another distinction between identity and resource policies is that permissions must be attached to a valid 
    identity, within an identity policy, however, in a resource policy permissions can be attached to anonymous 
    principles (i.e. unauthenticated principles).

    An example of a Resource Policy would be:

    {
        "Version":"2012-10-17",
        "Statement": [
            {
                "Sid": "PublicRead",
                "Effect": "Allow",
                "Principle": "*",
                "Action": ["s3:GetObject"],
                "Resource": ["arn:aws:s3:::secretromcomstash/*"]
            }
        ]
    }

    Note: In the above example, the principle is a wildcard, i.e., this allows anonymous principles to read the
    buckets objects. This is how we can infer that this is a Resource Policy and not an Identity Policy.


    Note: For more enforceable permissions please see - 
    https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html

    In some legacy implementations you may come across ACLs (Access Control Lists), these are simple, very limited
    security feature that should never be used in place of a Resource Policy. See below for the full extent of
    permissions afforded by an ACL.

![AWS ACL Permission Limitation][awsACLPermissions]

    You can block any anonymous principles from accessing your bucket using the block public access feature. This is
    another layer of security to prevent misconfigurations revealing sensitive data. The feature has levels of what
    configurations it will ignore, i.e. if an ACL has granted public access, it will be ignored if configured to do
    so via Block Public Access.

    In Summary here is some rule of thumb principles:

    Use an Identity Policy when:
        
        1. Controlling different resources: Some resources don't support Resource Policies and managing multiple
           Resource Policies can be burdensome.
        2. You have a preference for IAM: IAM Policies can manage all resources.
        3. The same account: No external access means it'll be easier to use IAM to control your principles that are
           within your account.

    Use a Resource Policy for an S3 Bucket when:

        1. You're just controlling access to S3.
        2. You need to allow access to other accounts or anonymous principles.

    Use an ACL when:

        1. Never, just don't.
        2. There is an explicit requirement with a very good justification.

## S3 Advanced: Static Hosting§

    To use S3 for static hosting you will need to do the following:

        1. Configure the S3 Bucket to enable static hosting.
        2. Set the Index and Error documents.

    Note: Website endpoints are automatically created, unless you're using a custom domain via Route 53. If you're
    using a custom domain then you must name your bucket name the same as your domain, i.e. the url - 
    https://www.romcoms.charliego.com would need a bucket named romcoms.charliego.com, so if you're starting a
    project that requires a static website, then reserve your bucket names asap.

    Two good use cases for S3 static hosting are:

        1. Offloading: If you have a website with some media, i.e. videos, images, etc... rather than storing those
           within your compute instance which would not be cost effective, you could store them within an S3 bucket
           and have your HTML reference the S3 bucket instead. 
        2. Out-of-bounds pages: For example pages that wouldn't be best suited for being stored on your main server,
           like maintenance or status pages that should be accessible in the event your main servers are not
           reachable. 

    If you're using SSR frameworks there are a few things to consider:

        1. S3 can not process SSR, so you will need another mechanism and architecture, i.e. using a static-adapter
           to render a SPA and then call API endpoints that could be run using EC2.
        2. If you need a complete SSR implementation consider AWS Fargate/Lambda.


## S3 Advanced: Object Versioning and MFA Delete

    Object versioning is disabled by default, once enabled however, it can not be disabled, but can be suspended. 
    Versioning allows for multiple versions of an object to be stored, operations that modify objects generate a new
    version. To uniquely identify a version (as the object name/key will be the same) you would use the defined id:

        ---+-- KEY = CutePictureOfHenryCavill.png, ID = 1111112
           |
           |
           |
           +-- KEY = CutePictureOfHenryCavill.png, ID = 1111111
           |
           |
           |
           +-- KEY = CutePictureOfHenryCavill.png, ID = 1111110

    When deleting an object that is in a versioned bucket, the object is not actually deleted, it is replaced by a
    delete marker, which is just a new version of that object which hides previous objects. Upon deleting the delete
    marker you will restore previous versions. There are certain controls on bucket versioning, for example you can 
    configure MFA Delete, which will require MFA to delete an object or to change the versioning state of a bucket.

    Note: Because objects are not deleted, you should be mindful of storage costs.
    Note: You can fully delete an object by specifying the ID of an object, this is irreversible. If you delete a 
          specific version, then the most recent version will become the active version.
    Note: The only way to zero a cost of a bucket, is by deleting the bucket.
    Note: When deleting via a version when MFA Delete is enabled the serial number and the MFA Code is required to 
          be passed with the API call. 

## S3 Advanced: Performance Optimisation

    Normal upload is a single PUT upload stream - if an upload is interrupted, it would need to be restarted - it's
    limited to 1 steam and will be limited in upload speed. Limited to 5GB upload, if you're uploading 5GB then the
    single PUT method is probably not appropriate for your use case, as it's unreliable.

    Multipart Upload: Breaks file up into blobs, min size is 100MB. An upload can be split into a maximum of 10,000
    parts, ranging from 5MB to 5GB in size. The last part however can be smaller than 5MB. If a part fails, it can
    be restarted - making it more reliable to transfer. It also increases the transfer rate, as this is the sum of
    the speed of all parts that are simultaneously being uploaded.

    Accelerated Transfer: When transferring data between two geologically distant regions, your data will traverse
    the public internet, what route the data takes depends on the various ISP's involved and they will consider the
    most economically viable route. These considerations may not always align with our requirements as we may need
    a more performant route. For this AWS has S3 Accelerated Transfer: this uses strategically placed Edge Locations
    to send the data through fewer normal networks and provide a more optimal route.

    Note: S3 Accelerated Transfer is off by default and has some restrictions when enabling it, such as the name of
    the S3 bucket must be DNS Compatible.

## Key Management Service

    AWS KMS is a Regional & Public Service supporting Symmetric and Asymmetric Keys. Using KMS you can Create, Store
    and Manage Keys. It also supports cryptographic operations, i.e. encrypt, decrypt... Keys part of the KMS NEVER
    leave KMS, and provides a FIPS 140-2 (Level 2) compliant service. KMS Keys can be used by you, applications and
    other AWS Services.

    KMS Keys are logical and consist of:

        - Key ID
        - Creation Date
        - Key Policy (Resource Policy)
        - Description
        - State

    Every key is backed by physical key material, and this is what's used by KMS to perform its operation - it can
    be generated or imported. KMS Keys can be used to encrypt up to 4KB of data. A typical flow for using KMS may
    look like this:

        1. Charlie requests to CreateKey, the Key is created and stored in an encrypted form within KMS.
        2. Charlie requests to Encrypt some data, providing the data to KMS and specifying which key to use. Given
           correct permissions, KMS takes the data and encrypts it with the specified key and returns the encrypted
           data.
        3. Charlie needs to decrypt the data and calls the decrypt operation, KMS doesn't ask which key was used as
           this information is encoded in the cipher text, returning the plaintext.

    For encrypting data larger than 4KB you can use Data Encryption Key, the DEK is generated using the KMS key, 
    therefore, they're linked to the KMS key that generated the it. It's important to understand and remember that KMS
    DOES NOT STORE THE DEK key. It provides it to you, or the service that requested it, then discards it because KMS
    doesn't perform the encryption or decryption of the data using the DEK, it's done by you or the service requesting 
    it.

    Key Concepts:

        - KMS Keys are isolated to a region and never leave the KMS Service.
        - Keys are AWS owned or customer owned, AWS Owned keys are usually managed by the service that uses them.
        - Customer owned keys are either AWS managed or customer managed. AWS managed are created automatically when
          you use a service like S3 that has integrations with KMS. Customer managed are created explicitly by the 
          customer to be used within the service or application.
        - Customer managed keys are more configurable that AWS managed keys, i.e. you can edit rotation policy etc.
        - Aliases: shortcuts to keys, i.e. my-app-primary-key. Be aware, aliases are per region.

    Key Permissions: (high level)

    Usually, services that are contained within the creating account usually have an implicit allow unless there's an
    explicit deny - however, KMS Key policies differ, a Key Policy is a resource policy, EVERY KEY HAS ONE. Therefore,
    a common setup might have a KMS Key Policy that allows an account, management permissions for the key, then use IAM
    policies to apply further permissions. In high security use cases, it is best practice to grant permissions directly
    within the key policy, and not delegate permission management.

    A key policy might look like:

        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::8998135:user/KMSAdmin"
            },
            "Action": "kms:*",
            "Resource": "*"
        }

    Note: KMS is capable of supporting some multi-region features.
    Note: KMS NEVER stores the keys in plaintext on disc. It will exist in plaintext on memory when needed.
    Note: Operations within KMS have separate permissions.
    Note: https://csrc.nist.gov/pubs/fips/140-2/upd2/final

[awsLocateSecurityCredentials]: ./images/aws-security-credentials.png
[awsAddMFA]: ./images/aws-add-mfa.png
[awsDeviceNameAndMedium]: ./images/aws-device-name-medium.png
[awsScanQrCodeAndAddAuthCodes]: ./images/aws-scan-qr-mfa.png
[awsSuccessfullyAddedMFA]: ./images/aws-added-mfa.png
[googleAuthenticatorApp]: ./images/ga-aws-cgo-general.jpg
[awsLocateBillingAndCostManagement]: ./images/aws-billing-and-cost-management.png
[awsSetBillingPreferences]: ./images/aws-billing-preferences.png
[awsCreateZeroSpendTemplate]: ./images/aws-zero-cost-budget-setup.png
[awsAccountAlias]: ./images/aws-account-alias.png
[awsCreateIAMUser]: ./images/aws-iam-create-user.png
[awsCreateIAMUserPermissionPolicies]: ./images/aws-iam-permission-policies.png
[awsIAMUserSecurityCredentials]: ./images/aws-iam-user-security-credentials.png
[awsConfigureProfileCLI]: ./images/aws-configure-profile-cli.png
[awsSharedResponsibilityModelSecurity]: ./images/aws-shared-responsibility-model-v2.jpeg
[awsPlatformsSharedResponsibilityModel]: ./images/aws-shared-responsibility-model.png
[awsControlTowerArchitecture]: ./images/aws-control-tower-architecture.png
[awsACLPermissions]: ./images/aws-acl-permissions.png
