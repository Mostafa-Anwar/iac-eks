import os
from aws_cdk import Environment

CDK_PY_VER = "3.8"
GH_CONN = os.environ["GH_CONN"]
GH_OWNER = os.environ["GH_OWNER"]
GH_REPO = os.environ["GH_REPO"]
GH_BRANCH = os.environ["GH_BRANCH"]

ENV_DEV      = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])
ENV_QA       = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_QA_REGION'])
PIPELINE_ENV = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])

ord_url_qa = os.environ["ord_url_qa"]
ord_id_qa  = os.environ["ord_client_id_qa"]
ord_sec_qa = os.environ["ord_client_secret_qa"]