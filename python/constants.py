import os
from aws_cdk import Environment

CDK_PY_VER = "3.8"
GH_CONN = os.environ["GH_CONN"]
GH_OWNER = os.environ["GH_OWNER"]
GH_REPO = os.environ["GH_REPO"]
GH_BRANCH = os.environ["GH_BRANCH"]

DEV_ENV      = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])
DEV_QA       = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_QA_REGION'])
PIPELINE_ENV = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])
