# Notes for items with a high probability of showing on th exam.

## S3: Object Versioning and MFA Delete

    MFA Delete:

        1. Enabled in the versioning configuration.
        2. MFA is required to change the bucket versioning state (enabled/suspended).
        3. MFA is required to delete versions.
        4. When doing the afore mentioned API calls, your MFA Serial Number and Code is required.

## S3: Default Limits for Account

    100 Soft limit, 1,000 hard limit for number of buckets per account.

## KMS

    Provides FIPS 140-2 (Level 2) compliance service - an American Standard, the Level 2 is important!
    Some services have achieved a Level 3, but overall it's a Level 2.

## S3 Replication

        i.    By default S3 Replication is not retroactive.
        ii.   Versioning must be ON.
        iii.  You can configure batch replication to replicate existing objects.
        iv.   It's a one-way replication process, from Source to Destination, by default. Bi-directional is
              something you need to additionally configure.
        v.    S3 Replication can handle unencrypted, SSE-C, SSE-S3 and SSE-KMS. SEE-KMS will require extra
              configuration due to the involvement of KMS.
        vi.   The Source Bucket owner will always need permissions to the objects to be replicated.
        vii.  No system events will be replicated.
        viii. Objects in Glacier or Glacier Deep Archive can not be replicated.
        ix.   Deleted markers are replicated, however it can be configured (DeleteMarkerReplication).