from aws_cdk import CfnOutput, Stack
from constructs import Construct
import constants


class CFOutputs(Stack):
    def __init__(self,
        scope: Construct,
        construct_id: str,
        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)

        gh_repo = CfnOutput(self,'gh-repo', 
            export_name='gh_repo',
            value=f"{constants.GH_OWNER}/{constants.GH_REPO}"
            )
        
        pipeline_branch = CfnOutput(self, 'pipeline-branch',
            export_name='pipe_branch',
            value=constants.GH_BRANCH,
        
            )

        conn_arn = CfnOutput(self, "conn-arn",
            export_name='conn_arn',
            value=constants.GH_CONN
            )