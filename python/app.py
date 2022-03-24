#!/usr/bin/env python3
import os

from aws_cdk import (
    Stack as Stack,
    App as App,
    Environment as envir,
    Fn
)
# from deployment import EKS
from stacks.vpc_stack import VPCStack
from stacks.security_stack import SecurityStack
from stacks.eks_stack import EKS
from config import SSMStack
from pipeline import Pipeline
import constants



app = App()

# eks = EKS(
#     app,
#     'eks-dev',
    
# )

ssmstack = SSMStack(app, 'ssm-params', env=constants.ENV_DEV)
vpcstack = VPCStack(app, 'eks-vpc', env=constants.ENV_DEV)
securitystack = SecurityStack(app, 'eks-security', env=constants.ENV_DEV, vpc=vpcstack.vpc)
eksstack = EKS(app, 'eks-cluster', env=constants.ENV_DEV, vpc=vpcstack.vpc, sg=securitystack.sg_eks_access)
securitystack.add_dependency(vpcstack)
eksstack.add_dependency(securitystack)


# pipelinestack = Pipeline(app, 'eks-pipeline',
#         env=constants.ENV_DEV
#        )
# pipelinestack.add_dependency(ssmstack)


app.synth()
