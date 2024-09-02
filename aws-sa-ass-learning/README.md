# AWS Solutions Architect Associate Notes

## AWS Accounts

    An AWS Account is a container for identities (users) and resources, the prerequisites to create one is:

        1. An AWS Account Name, i.e. $projectName-sandpit, $projectName-dev, $projectName-prod, etc...
        2. A unique email.
        3. A payment card.

    When you create an AWS account, the email provided is used to create an 'account root user', this is the only
    account to exist out of the box and has root privileges, i.e. it can perform every and any task. This account
    cannot be deleted. It's bad practice to do administration tasks from root user, therefore you should create an 
    IAM User (Identity and Access Management) with the exact permissions required to fulfil the respective
    tasks. The payment card provided is the account payment method, so any resources consumed that are
    billable will be charged to this payment card.

    Note: its not uncommon to have multiple AWS accounts for mid to complex projects.
    Note: Cross account permissions are achievable (excluding account root user), which will be documented later.
    Note: It is possible for learning to create multiple aliases from one email address, i.e. on apple I use
    'hide my email', a gmail account you can do $yourEmail+$someString@gmail.com where, $someString is a random
    string that will form an alias for you. For hotmail, you can go into your account settings and create some
    aliases.

## Enable MFA

    You should try to always add some form of MFA to your AWS account once created. There are several factors that
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

    IAM is a globally resistent service that's used for managing operational user access rights to the services
    associated with your AWS Account. Every AWS account has its own dedicated instance of IAM, and the database
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
