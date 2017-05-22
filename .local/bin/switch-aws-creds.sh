# switch ~/.aws/credentials file with one specified
FROM=~/.aws/credentials-$1
TO=~/.aws/credentials

cp $FROM $TO

echo $FROM
