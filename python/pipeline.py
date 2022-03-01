from asyncio import constants
from aws_cdk import (
    CfnParameter,
    Fn,
    aws_codebuild as codebuild,
    pipelines,
    Stack,
    CfnOutput
)
from aws_cdk.pipelines import CodePipeline, ShellStep
from constructs import Construct
import constants
import config


class Pipeline(Stack):
    def __init__(self,
        scope: Construct,
        construct_id: str,
        **kwargs
    ) -> None:
        super().__init__(scope, construct_id, **kwargs)



        
        codepipeline_source = pipelines.CodePipelineSource.connection(
                                repo_string=Fn.import_value(config.gh_repo),
                                branch=Fn.import_value(config.pipeline_branch),
                                connection_arn=Fn.import_value(config.conn_arn),
        )
        synth_python_version = {
            "phases": {
                "install": {
                    "runtime-versions": {"python": constants.CDK_PY_VER}
                }
            }
        }
        ## TODO: store the constants in ssm params or CF outputs
        pipeline = CodePipeline(self, "cdk-pipeline",
                        pipeline_name="eks-cdk-pipeline",
                        synth=ShellStep("Synth",
                            input=codepipeline_source,
                            commands=["npm install -g aws-cdk",
                                "ls -al && cd python",
                                "python -m pip install -r requirements.txt",                                 
                                "cdk synth"]
                            )
        )