#!/usr/bin/env python3
import os

from aws_cdk import (
    Stack as Stack,
    App as App,
    Environment as envir,
)
# from deployment import EKS
from stacks.vpc_stack import VPCStack
from stacks.security_stack import SecurityStack
from pipeline import Pipeline
import constants



app = App()

# eks = EKS(
#     app,
#     'eks-dev',
    
# )

vpcstack = VPCStack(app, 'eks-vpc', env=constants.DEV_ENV)
securitystack = SecurityStack(app, 'eks-security', env=constants.DEV_ENV, vpc=vpcstack.vpc)

pipelinestack = Pipeline(app, 'eks-pipeline', env=constants.DEV_ENV)



app.synth()
