#!/usr/bin/env python3
import os

from aws_cdk import Stack, App
from stacks.vpc_stack import VPCStack


app = App()

vpcstack = VPCStack(app, 'eks-vpc-stack')


app.synth()
