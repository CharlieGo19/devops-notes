# Notes for items with a high probability of showing on th exam.

## S3: Object Versioning and MFA Delete

    MFA Delete:

        i.   Enabled in the versioning configuration.
        ii.  MFA is required to change the bucket versioning state (enabled/suspended).
        iii. MFA is required to delete versions.
        iv.  When doing the afore mentioned API calls, your MFA Serial Number and Code is required.

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

# S3 PresignedURLs

    i.   You can create a PresignedURL for an object you have no access to.
    ii.  When using the URL, the permissions match the GET/PUT access of the identity which generated it.
    iii. Access denied could indicate the generating identity never had the access, or has since had it revoked.
    iv.  Try not to use roles to generate PresignedURLs. The URL will stop working when the temporary credentials
         expire.

# S3 Select and Glacier Select

    i.   Retrieving a 5TB object takes time and uses a full 5TB of network resources.
    ii.  Filtering on client side doesn't reduce i.
    iii. S3/Glacier gives SQL-like statements to filter S3 side.
    iv   Supported formats: CSV, JSON, Parquet, BZIP2 for CSV and JSON.