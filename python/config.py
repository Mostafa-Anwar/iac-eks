from aws_cdk import (
    CfnOutput,
    Stack,
    aws_ssm as ssm,
    aws_secretsmanager as secretsmanager,
    CfnTag
)
from constructs import Construct
import constants
from string import Template


def formalize(string: str):
    return format((string)+"-"+constants.ENV_NAME+"-"+constants.PROJECT)


## VPC Vars
cidr_range           = "172.32.0.0/16"
azs_number           = 2
ngw_number           = 1
vpc_name             = "eks-vpc-cdk"
# pub_subnet_name    = "Public"
# pvt_subnet_name    = "Private"


## Security Group Vars
security_stack_name  = "eks-security-cdk" 
sg_access_name       = "eks-access"
sg_fs_name           = "eks-fs"
sg_db_name           = "eks-db"


## EKS Vars
eks_master_role_name = "py-eks-poc-cluster-role"
eks_node_role_name   = "py-eks-poc-nodegp-role"
eks_cluster_name     = "eks-cluster"
eks_nodegroup_name   = "worker-ng"
eks_instancetype     = "t3.medium"
eks_ssh_key_name     = "eks-ec2"

class SSMStack(Stack):
    def __init__(self,
        scope: Construct,
        construct_id: str,
        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)


        gh_repo = ssm.StringParameter(self, 'gh-repo',
                parameter_name='gh_repo',
                description='pipeline param for gh repo',
                string_value=constants.GH_REPO
            #    string_value=str(constants.GH_OWNER+'/'+constants.GH_REPO)
            )


        branch = ssm.StringParameter(self, 'pipeline-branch-param',
                parameter_name='pipe_repo',
                description='pipeline param for branch',
                string_value=constants.GH_BRANCH 
            )

        conn_arn = ssm.StringParameter(self, 'conn-arn-param',
                parameter_name='conn_arn',
                description='pipeline param for connection arn between github and aws pipelines',
                string_value=constants.GH_CONN
            )


        env_dev = ssm.StringParameter(self, 'env-dev-param',
                parameter_name='env_dev',
                description='variable for specifying env to dev',
                string_value=str(constants.ENV_DEV)
            )


        env_qa = ssm.StringParameter(self, 'env-qa-param',
                parameter_name='env_qa',
                description='variable for specifying env to qa',
                string_value=str(constants.ENV_QA)
            )


