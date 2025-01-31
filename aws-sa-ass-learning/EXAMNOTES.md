# Notes for items with a high probability of showing on th exam.

## S3: Object Versioning and MFA Delete

    MFA Delete:

        1. Enabled in the versioning configuration.
        2. MFA is required to change the bucket versioning state (enabled/suspended).
        3. MFA is required to delete versions.
        4. When doing the afore mentioned API calls, your MFA Serial Number and Code is required.

## KMS

    Provides FIPS 140-2 (Level 2) compliance service - an American Standard, the Level 2 is important!
    Some services have achieved a Level 3, but overall it's a Level 2.