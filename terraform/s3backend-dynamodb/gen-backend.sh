#!/bin/bash
d=`pwd`
sleep 5
#reg=`terraform output -json region | jq -r .[]`
reg=`terraform output -json region | jq -r .[]`
if [[ -z ${reg} ]] ; then
    echo "no terraform output variables - exiting ....."
    echo "run terraform init/plan/apply in the the init directory first"
else
    echo "region=$reg"
    rm -f $of $of
fi

mkdir -p generated

SECTIONS=('net' 'eks')

for section in "${SECTIONS[@]}"
do

    tabn=`terraform output dynamodb_table_name_$section | tr -d '"'`
    s3b=`terraform output -json s3_bucket | jq -r .[]`
    echo $s3b $tabn

    cd $d

    of=`echo "generated/backend-${section}.tf"`
    vf=`echo "generated/vars-${section}.tf"`

    # write out the backend config
    printf "" > $of
    printf "terraform {\n" >> $of
    printf "required_version = \">= 1.0.0\"\n" >> $of
    printf "required_providers {\n" >> $of
    printf "  aws = {\n" >> $of
    printf "   source = \"hashicorp/aws\"\n" >> $of
    printf "#  Allow any 3.1x version of the AWS provider\n" >> $of
    printf "   version = \"3.46\"\n" >> $of
    printf "  }\n" >> $of
    printf " }\n" >> $of
    printf "backend \"s3\" {\n" >> $of
    printf "bucket = \"%s\"\n"  $s3b >> $of
#    printf "key = \"${section}/%s.tfstate\"\n"  $tabn >> $of
    printf "key = \"terraform/%s.tfstate\"\n"  $tabn >> $of
    printf "region = \"%s\"\n"  $reg >> $of
    printf "dynamodb_table = \"%s\"\n"  $tabn >> $of
    printf "encrypt = \"true\"\n"   >> $of
    printf "}\n" >> $of
    printf "}\n" >> $of
    ##
    printf "provider \"aws\" {\n" >> $of
    printf "region = var.region\n"  >> $of
    printf "shared_credentials_file = \"~/.aws/credentials\"\n" >> $of
    printf "profile = var.profile\n" >> $of
    printf "}\n" >> $of

    # copy the files into place
    cp -v $of ../$section
    cp  variables.tf ../$section


done

# next generate the remote_state config files


cd $d
echo "**** REMOTE ****"

RSECTIONS=('net')
for section in "${RSECTIONS[@]}"
do
    tabn=`terraform output dynamodb_table_name_$section | tr -d '"'`
    s3b=`terraform output -json s3_bucket | jq -r .[]`

    echo $s3b $tabn
    of=`echo "generated/remote-${section}.tf"`
    printf "" > $of

    # write out the remote_state terraform files
    printf "data terraform_remote_state \"%s\" {\n" $section>> $of
    printf "backend   = \"s3\"\n" >> $of
#    printf "workspace = \"default\"\n" >> $of
    printf "config = {\n" >> $of
    printf "bucket = \"%s\"\n"  $s3b >> $of
#   printf "region = \"%s\"\n"  $reg >> $of
    printf "region = var.region\n"  >> $of
#    printf "key = \"${section}/%s.tfstate\"\n"  $tabn >> $of
    printf "key = \"terraform/%s.tfstate\"\n"  $tabn >> $of
    printf "}\n" >> $of
    printf "}\n" >> $of
done

echo "remotes"

# put in place remote state access where required
# cp  generated/remote-net.tf ../eks


terraform fmt --recursive > /dev/null
exit 0
