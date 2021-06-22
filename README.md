# S3 Security Demo

## Data Custodian

```
./console.sh
terraform init -upgrade
```

```
aws sts get-caller-identity

terraform apply -auto-approve

S3_BUCKET_ID="$(terraform output -json | jq -r '.s3_bucket_id.value')"

cat data/customer-data.txt
cat data/anonymized-data.txt

aws s3api list-objects --bucket $S3_BUCKET_ID

aws s3 cp --acl public-read \
  ./data/customer-data.txt \
  s3://$S3_BUCKET_ID/anonymized-data.txt
```

Browse the uploaded object using its public URL (replace `<S3_BUCKET_ID>`): 

```
https://<S3_BUCKET_ID>.s3.amazonaws.com/anonymized-data.txt
```

Remove existing object and upload anonymized data:

```
aws s3 rm s3://$S3_BUCKET_ID/anonymized-data.txt

aws s3 cp --acl public-read \
  ./data/anonymized-data.txt \
  s3://$S3_BUCKET_ID/anonymized-data.txt
```

## Red Team

```
AWS_PROFILE="red-team"
S3_BUCKET_ID="<S3_BUCKET_ID>" # replace <S3_BUCKET_ID>

aws sts get-caller-identity

aws s3api list-object-versions --bucket $S3_BUCKET_ID

OBJECT_VERSION_ID="<copy from previous command>"

aws s3api get-object \
  --bucket $S3_BUCKET_ID \
  --key anonymized-data.txt \
  --version-id "$OBJECT_VERSION_ID" \
  anonymized-data.txt

cat anonymized-data.txt
```

## Blue Team

Define the following bucket policy (public access):

```
data "aws_iam_policy_document" "public_objects" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${local.bucket_arn}/*"
    ]
  }
}
```

Attach bucket policy to the bucket, set acl to private and remove any ACL
grants:

```
  # Attach policy to allow public s3:GetObject
  #
  policy        = data.aws_iam_policy_document.public_objects.json
  attach_policy = true

  # Owner gets FULL_CONTROL. No one else has access rights (default)
  #
  acl = "private"
```

```
terraform apply -auto-approve
```

After attaching the bucket policy to the bucket, set the following public
access flags:

```
  # API calls fail if the request includes a public ACL
  # When set to false do not fail when application sets a public ACL
  #
  block_public_acls       = false

  # Enables you to safely block public access granted by ACLs while still
  # allowing PUT Object calls that include a public ACL
  # When set to true it will ignore public ACLs set by the application
  #
  ignore_public_acls      = true
 
  # Reject calls to PUT access point policy and PUT bucket policy if the
  # specified policy is public
  # To use this setting effectively, you should apply it at the account level
  # When set to true protects existing bucket policy from changes
  #
  block_public_policy     = true

  # Restricts access to an access point or bucket with a public policy to only
  # authorized principals within the bucket owner's account
  #
  restrict_public_buckets = false
```

```
terraform apply -auto-approve
```

## Conclusion

- Red team no longer has access to API and previous versions
- Blue team preserve public access to the current version of bucket objects

## Cleanup 

```
terraform destroy \
  -target data.aws_canonical_user_id.current \
  -target data.aws_iam_policy_document.public_objects \
  -target random_id.suffix \
  -target module.s3_bucket \
  -auto-approve
```
