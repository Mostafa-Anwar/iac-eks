import os
from constructs import Construct
from aws_cdk import (
    Environment,
    Stack,
    aws_ssm as ssm,
    Stack
)


CDK_PY_VER = "3.8"
GH_CONN = os.environ["GH_CONN"]
GH_OWNER = os.environ["GH_OWNER"]
GH_REPO = os.environ["GH_REPO"]
GH_BRANCH = os.environ["GH_BRANCH"]

PROJECT = os.environ["PROJ"]
ENV_NAME = os.environ["ENV"]

DEV_ENV      = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])
QA_ENV       = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_QA_REGION'])
PIPELINE_ENV = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])



