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

ENV_DEV      = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])
ENV_QA       = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_QA_REGION'])
PIPELINE_ENV = Environment(account=os.environ["CDK_DEFAULT_ACCOUNT"], region=os.environ['CDK_DEV_REGION'])

vars = [CDK_PY_VER, GH_CONN, GH_OWNER, GH_REPO, GH_BRANCH, ENV_DEV, ENV_QA, PIPELINE_ENV]

class var(Stack):
    def __init__(self,
        scope: Construct,
        construct_id: str,

        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)
        try:   
            vars
        except NameError:
            print("well, it WASN'T defined after all!")        
            GH_REPO = "Mostafa-Anwar/iac-eks",
            GH_BRANCH = ssm.StringParameter.value_from_lookup(self, parameter_name="pipe_repo"),
            GH_CONN = ssm.StringParameter.value_from_lookup(self, parameter_name="conn_arn")
        else:
            print("sure, it was defined.")
