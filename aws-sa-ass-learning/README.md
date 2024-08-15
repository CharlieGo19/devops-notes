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
    be a random number prepended to the AWS sign-in URL. To create a more friendly IAM sign-in URL do the following:

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
    expectation of the account root user, IAM users are the only entity on AWS to use access keys. IAM users are can
    have up-to two access keys at anyone time. This is to allow users to rotate access keys, i.e. to practice good
    security, periodically you will change your access keys and this process may go something like this:

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
