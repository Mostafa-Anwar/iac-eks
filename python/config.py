from inspect import Parameter
from multiprocessing.sharedctypes import Value
from unicodedata import name
from aws_cdk import (
    CfnOutput,
    Stack,
    aws_ssm as ssm,
    aws_secretsmanager as secretsmanager,
    CfnTag
)
from constructs import Construct
import constants


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
                string_value=f'{constants.GH_OWNER}/{constants.GH_REPO}'
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


        ord_url_qa = ssm.StringParameter(self, 'ord-url-qa',
                    parameter_name='ord_qa_token_url',
                    string_value=constants.ord_url_qa
                    )

        ord_id_qa = ssm.StringParameter(self, 'ord-client-id-qa',
                    parameter_name='ord_qa_client_id',
                    string_value=constants.ord_id_qa
                    )

        
        ord_sec_qa = secretsmanager.CfnSecret(self, 'ord-client-sec-qa',
                      name='ord_qa_client_secret',
                      secret_string=constants.ord_sec_qa
                    )


        # CfnOutput(self,'gh-repo', 
        #     export_name='gh_repo',
        #     value=f"{constants.GH_OWNER}/{constants.GH_REPO}"
        #     )
        
        # CfnOutput(self, 'pipeline-branch',
        #     export_name='pipe_branch',
        #     value=constants.GH_BRANCH        
        #     )

        # CfnOutput(self, "conn-arn",
        #     export_name='conn_arn',
        #     value=constants.GH_CONN
        #     )


        # CfnOutput(self, "env-dev",
        #     export_name='env_dev',
        #     value=constants.ENV_DEV
        #     )


        # CfnOutput(self, "env-qa",
        #     export_name='env_qa',
        #     value=constants.ENV_QA
        #     )